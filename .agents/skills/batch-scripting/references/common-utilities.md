## Robocopy — File/Directory Copying

Prefer `robocopy` over `xcopy`/`copy` for anything beyond a single file —
it's restartable, has real logging, and handles long paths and retries.

```batch
robocopy "%SOURCE%" "%DEST%" /E /R:3 /W:5 /LOG:"%~dp0copy.log" /NP
if %ERRORLEVEL% geq 8 (
  echo ERROR: robocopy failed, see copy.log 1>&2
  exit /b 1
)
```

- `/E` — copy subdirectories, including empty ones.
- `/R:3 /W:5` — retry 3 times, 5 seconds apart (default is 1 million
  retries, 30s apart — always override this for unattended scripts or a
  locked file will hang the script for days).
- `/LOG:file` — write output to a log instead of the console; `/NP`
  suppresses the per-file progress percentage (noisy in a log file).
- **Exit codes 0-7 are success** (0=nothing copied, 1=files copied,
  2=extra files present, 4=mismatched files present — these OR together).
  **8+ means real failure.** Never treat any nonzero exit code as
  failure — check `geq 8` specifically.

## findstr — Text Search

`findstr` is batch's `grep` — regex support is limited (BRE-like, not
PCRE) but sufficient for most script needs.

```batch
:: Find lines matching a literal string
findstr /C:"ERROR" "%LOGFILE%"

:: Case-insensitive, line numbers
findstr /I /N "warning" "%LOGFILE%"

:: Check if a string exists (for scripting logic, not display)
findstr /C:"SUCCESS" "%LOGFILE%" >nul
if %ERRORLEVEL% equ 0 (
  echo Found success marker
)
```

- `/C:"literal"` — treat the pattern as a literal string, not a regex
  (avoids surprises from special characters).
- Redirect to `nul` and check `%ERRORLEVEL%` when using `findstr` purely
  as a boolean test (0 = found, 1 = not found) rather than for its output.

## for /f — Parsing Command Output and Files

The most commonly misused batch construct. Use `for /f` to iterate over
lines of a file or the output of another command.

```batch
:: Read each line of a file
for /f "usebackq delims=" %%L in ("%FILE%") do (
  echo Line: %%L
)

:: Parse CSV-style output, tokens 1 and 3
for /f "tokens=1,3 delims=," %%A in (myfile.csv) do (
  echo Name=%%A Value=%%C
)

:: Capture the output of a command into a variable
for /f "usebackq tokens=* delims=" %%V in (`hostname`) do set "HOST=%%V"
echo Running on !HOST!
```

- `usebackq` lets you use double-quoted filenames (otherwise quotes are
  interpreted as a literal string to parse, not a filename) — use it by
  default unless you specifically want the literal-string behavior.
- `delims=` with nothing after it disables tokenizing entirely — needed
  when you want whole lines, not space-separated tokens.
- Capturing command output (backtick form) requires the result to be
  read inside the loop body via delayed expansion if used outside a
  single `set` — see the Golden Rules on `!VAR!` vs `%VAR%`.

## reg.exe — Registry Access

```batch
:: Read a value
for /f "tokens=2,*" %%A in (
  'reg query "HKCU\Software\MyApp" /v InstallPath 2^>nul'
) do set "INSTALL_PATH=%%B"

:: Write a value
reg add "HKCU\Software\MyApp" /v LastRun /t REG_SZ /d "%DATE% %TIME%" /f

:: Delete a key (use /f to suppress the confirmation prompt in unattended scripts)
reg delete "HKCU\Software\MyApp\Temp" /f
```

- `2^>nul` — the `^` escapes the `>` inside a `for /f` command string
  (the whole backtick-quoted command is itself subject to batch's own
  parsing, so redirection operators inside it need escaping).
- Always use `/f` on `reg add`/`reg delete` in unattended scripts to
  suppress the interactive "are you sure" prompt — without it the script
  hangs waiting for input that will never come.

## schtasks.exe — Scheduled Tasks

```batch
:: Create a daily task running as the current user
schtasks /create /tn "MyApp Daily Backup" /tr "\"%~dp0backup.bat\"" ^
  /sc daily /st 02:00 /f

:: Check whether a task exists (for idempotent setup scripts)
schtasks /query /tn "MyApp Daily Backup" >nul 2>&1
if %ERRORLEVEL% neq 0 (
  echo Task does not exist, creating...
)

:: Remove a task
schtasks /delete /tn "MyApp Daily Backup" /f
```

- Quote the `/tr` (task run) command carefully — nested quotes around a
  path containing spaces need `\"..\"` escaping since the whole `/tr`
  value is itself quoted.
- `/f` suppresses confirmation prompts, same reasoning as `reg`.


## Calling PowerShell from Batch

When a task genuinely needs something batch can't do natively (JSON
parsing, REST calls, real objects) — shell out to PowerShell rather than
fighting batch's limitations. See the `rad-powershell-master`-style
skill in a PowerShell-focused template for PowerShell-side conventions;
from the batch side:

```batch
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "Invoke-RestMethod -Uri 'https://api.example.com/status' | ConvertTo-Json" ^
  > "%~dp0status.json"

if %ERRORLEVEL% neq 0 (
  echo ERROR: PowerShell call failed 1>&2
  exit /b 1
)
```

- `-NoProfile` — skip loading the user's PowerShell profile (faster,
  avoids profile-script side effects in an unattended context).
- `-ExecutionPolicy Bypass` — scoped to this one invocation only, doesn't
  change the system-wide policy; safe for a single automated call.
- Prefer this for anything beyond simple text/file operations — don't
  try to reimplement JSON parsing or HTTP calls in pure batch.

## git.exe — Clone-if-Missing / Update-if-Present

Verified pattern (actually run against real `cmd.exe` and a live public
repo — see `src/git-clone-or-update.bat` for the full script): clone a
repo if the target folder doesn't exist yet, or fast-forward-pull it if
it does, deriving the target folder name from the URL when not given
explicitly.

```batch
:: Deriving the repo name from the URL (basename via for /f delims=/) —
:: works for both HTTPS ("https://host/owner/repo.git") and SSH
:: ("git@host:owner/repo.git") URLs because delimiter runs collapse and
:: only "/" needs to be split on; the trailing ".git" is stripped after.
set "REMAINDER=%REPO_URL%"
:SplitLoop
for /f "tokens=1* delims=/" %%A in ("%REMAINDER%") do (
  set "SEGMENT=%%A"
  set "REMAINDER=%%B"
)
if not "%REMAINDER%"=="" goto :SplitLoop
if /i "%SEGMENT:~-4%"==".git" set "SEGMENT=%SEGMENT:~0,-4%"
set "TARGET_DIR=%SEGMENT%"

:: Switch on whether the target is already a git repo
if exist "%TARGET_DIR%\.git" (
  call :UpdateRepo
) else (
  git clone "%REPO_URL%" "%TARGET_DIR%"
)
```

```batch
:UpdateRepo
pushd "%TARGET_DIR%"

:: Don't pull over uncommitted local changes — findstr "." matches any
:: non-empty line, so this is a reliable dirty-check without parsing output
git status --porcelain | findstr . >nul
if %ERRORLEVEL% equ 0 (
  echo WARNING: uncommitted local changes present - skipping update 1>&2
  popd
  exit /b 1
)

git fetch --all --prune
if errorlevel 1 ( popd & exit /b 1 )

:: --ff-only fails loudly instead of silently creating a merge commit
:: when the local branch has diverged from the remote
git pull --ff-only
if errorlevel 1 ( popd & exit /b 1 )

popd
exit /b 0
```

- **Basename derivation** — the `for /f "delims=/"` split-loop is the
  standard batch idiom for "last path segment of a string"; it works
  regardless of `/` vs `\` mixing in the URL because git URLs always use
  `/`, and it naturally handles a trailing slash (empty trailing token is
  dropped by the delimiter-collapsing behavior of `for /f`).
- **`git status --porcelain | findstr .`** — a reliable non-empty-output
  check without needing to parse the porcelain format; empty output = 0
  matches = errorlevel 1 = clean tree.
- **`git pull --ff-only`, not a bare `git pull`** — a bare pull can create
  a merge commit or hang waiting for a commit-message editor in an
  unattended context; `--ff-only` either fast-forwards cleanly or fails
  with a nonzero exit code that the script can detect and report.
- Deliberately does **not** force-sync (`git reset --hard` /
  `git clean -fd`) — that would silently discard local work. If a
  script genuinely needs guaranteed exact-match-to-remote (e.g. a
  deployment pull), that's a different, more destructive contract and
  should be a separate, clearly-named subroutine, not the default
  "update" behavior.

## wmic.exe — Deprecated, Avoid in New Scripts

`wmic` is deprecated as of Windows 10 21H1+ and removed in newer Windows
builds. For new scripts, use PowerShell's `Get-CimInstance` (called from
batch per the pattern above) instead of `wmic` for system/hardware
queries. If maintaining an existing script that already uses `wmic`,
don't block on migrating it, but flag it as tech debt.
