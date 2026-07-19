---
description: "Windows Batch (.bat/.cmd) conventions — variable naming, error handling, quoting, structure."
globs: ["**/*.bat", "**/*.cmd"]
alwaysApply: false
---

# Batch Script Conventions

## Line Endings — CRLF, Not LF (Mandatory)

Every `.bat`/`.cmd` file **must** use Windows-style CRLF (`\r\n`) line
endings, not Unix-style LF. This is not a style preference — `cmd.exe`'s
parser can silently misparse multi-line parenthesized blocks (`if ... ( )`,
`for ... ( )`) when the file has LF-only endings, producing confusing
"X is not recognized as an internal or external command" errors that point
at fragments of unrelated lines, not the actual problem. This was
discovered by actually running an LF-saved example script in this kit —
reading the file looked completely correct; only real execution caught it.

- If your editor/tool defaults to LF (many AI coding tools and Unix-based
  editors do), explicitly convert before treating a script as done:
  ```powershell
  $c = Get-Content path\to\script.bat -Raw
  [IO.File]::WriteAllText("path\to\script.bat", ($c -replace "`r`n","`n" -replace "`n","`r`n"))
  ```
- Verify with a byte check if unsure: the byte before every `\n` (0x0A)
  should be `\r` (0x0D).
- This is exactly why "never declare a batch script correct from reading
  alone" (see `.agents/skills/batch-scripting/references/verification-checklist.md`)
  is a hard rule, not a suggestion — a line-ending problem is invisible in
  a text viewer but breaks execution immediately.

## Header Block (mandatory)

Every script starts with a header comment and `@echo off` + `setlocal`:

```batch
@echo off
setlocal enabledelayedexpansion
REM ============================================================
REM Script:  backup-logs.bat
REM Purpose: Archives logs older than 30 days to \\server\archive
REM Usage:   backup-logs.bat [target-dir]
REM ============================================================
```

- `@echo off` — suppress command echo (always, unless actively debugging).
- `setlocal` — always scope variables to the script; never leak into the
  caller's environment. Use `setlocal enabledelayedexpansion` whenever the
  script modifies a variable inside a `for`/`if` block (see Delayed
  Expansion below) — forgetting this is the single most common batch bug.
- Pair every `setlocal` with `endlocal` at every exit point, or rely on
  `setlocal`'s automatic scope-exit at script end — don't leave it
  ambiguous which one applies.

## Naming Conventions

- **Variables:** `UPPER_SNAKE_CASE` (e.g. `TARGET_DIR`, `LOG_FILE`) —
  matches the casing of built-in variables (`%ERRORLEVEL%`, `%CD%`) so
  user-defined and built-in variables are visually distinct from literal
  text.
- **Subroutine labels:** `PascalCase` prefixed with a verb (e.g.
  `:ValidateInput`, `:CopyFiles`, `:Cleanup`) — called via `call :Label`.
- **Script files:** `kebab-case.bat` (e.g. `backup-logs.bat`) unless the
  environment this script runs in has an established different convention
  (say so explicitly if so).

## Variable Expansion — the #1 Source of Bugs

Batch has two expansion mechanisms and mixing them up silently produces
wrong values:

- **`%VAR%`** — expanded once, at parse time, before the line/block runs.
  Inside a `for` or `if` block, this means `%VAR%` reflects the value
  *before* the block started, not updates made during it.
- **`!VAR!`** — delayed expansion, evaluated at execution time. Required
  whenever a variable is set and read within the same `for`/`if` block.
  Requires `setlocal enabledelayedexpansion` to be active.

```batch
:: WRONG — %COUNT% never updates inside the loop, always prints the
:: value from before the loop started
set COUNT=0
for %%F in (*.txt) do (
  set /a COUNT+=1
  echo %COUNT%
)

:: RIGHT — delayed expansion reads the live value
setlocal enabledelayedexpansion
set COUNT=0
for %%F in (*.txt) do (
  set /a COUNT+=1
  echo !COUNT!
)
```

## Error Handling

- **Check `%ERRORLEVEL%` after every command whose failure matters** —
  batch does not stop on error by default.
- **`exit /b <code>`** to return from a script/subroutine with a status
  code — never bare `exit` (that closes the whole cmd.exe host, including
  the caller's shell if invoked without `call`).
- **`if errorlevel N`** tests "errorlevel is N or greater" — for an exact
  match use `if %ERRORLEVEL% equ N`.

```batch
robocopy "%SOURCE%" "%DEST%" /E
if %ERRORLEVEL% geq 8 (
  echo ERROR: robocopy failed with code %ERRORLEVEL% 1>&2
  exit /b 1
)
```

> **Robocopy note:** exit codes 0-7 are all *success* variants (0=no
> files copied, 1=files copied, etc.) — only 8+ is a real failure. Don't
> treat any nonzero `robocopy` exit code as failure; check `geq 8`.

## Paths — Always Quote, Always Use `%~dp0`

```batch
:: WRONG — breaks on any path containing a space
set LOGDIR=C:\Program Files\MyApp\logs
copy %LOGDIR%\out.log C:\backup\

:: RIGHT — quoted throughout
set "LOGDIR=C:\Program Files\MyApp\logs"
copy "%LOGDIR%\out.log" "C:\backup\"

:: RIGHT — script-relative path, works regardless of caller's cwd
set "SCRIPT_DIR=%~dp0"
call "%SCRIPT_DIR%lib\helpers.bat"
```

- `set "VAR=value"` (quotes around the whole assignment, not just the
  value) avoids trailing-space bugs — the quote itself isn't stored in
  the variable.
- `%~dp0` — the invoking script's own directory (drive + path), always
  ends with a trailing backslash. Use this instead of a hardcoded
  absolute path or assuming the working directory.

## Modularity — Subroutines over GOTO Spaghetti

```batch
@echo off
setlocal enabledelayedexpansion

call :ValidateInput "%~1"
if errorlevel 1 exit /b 1

call :CopyFiles "%~1" "%~2"
call :Cleanup

exit /b 0

:ValidateInput
if "%~1"=="" (
  echo ERROR: source path required 1>&2
  exit /b 1
)
exit /b 0

:CopyFiles
robocopy "%~1" "%~2" /E
exit /b 0

:Cleanup
del /q "%TEMP%\myapp_*.tmp" 2>nul
exit /b 0
```

- Structure scripts as a short main flow at the top calling named
  subroutines below — never a long flat sequence of commands, and never
  bare `goto` for control flow (only for genuine jumps like `:eof`
  shortcuts or explicit `goto :ValidateInput` style calls when `call` is
  unsuitable).
- Each subroutine ends with an explicit `exit /b <code>` — don't fall
  through to the next label by accident.

## User-Facing Output — Color and Progress (for interactive scripts)

For scripts a human actually watches run (not silent/scheduled ones — see
the Documentation/unattended-context guidance elsewhere), color-coded
status and progress feedback is worth the small extra effort: green for a
positive/in-progress action (e.g. downloading), blue/cyan for a neutral
one (e.g. updating), red for errors — pick colors that read clearly against
both light and dark terminal backgrounds, not just what's convenient.

**Don't use the classic `for /f %%A in ('echo prompt $E^| cmd') do set
"ESC=%%A"` ANSI-escape-capture trick** — verified broken in this kit's own
testing: the captured line can come back empty (`for /f` treats a
line containing only a non-printable character as blank and skips it),
silently leaving colors unset so escape codes print as literal text
(`[32m`) instead of rendering. **Delegate colored output to PowerShell
instead** — reliable, and consistent with this kit's existing "shell out to
PowerShell for what batch can't do natively" pattern:

```batch
powershell -NoProfile -Command "Write-Host 'Downloading repo...' -ForegroundColor Green"
powershell -NoProfile -Command "Write-Host 'Updating repo...' -ForegroundColor Cyan"
```

**Don't use `timeout` for a script-internal delay** (e.g. pacing a progress
indicator) — verified in this kit's own testing that `timeout` fails with
`ERROR: Input redirection is not supported, exiting the process
immediately.` whenever stdin isn't a genuine interactive console, which is
exactly the case for anything run non-interactively (CI, another process,
an AI agent testing the script) — `/nobreak` does **not** fix this. Use a
`ping`-based delay instead, which works in every context:

```batch
:: Delay ~1 second (ping -n 2 = 1 initial + 1 timed packet)
ping -n 2 127.0.0.1 >nul
```

For a simple inline progress indicator (no newline between ticks),
`set /p "=X" <nul` is confirmed reliable:

```batch
set /p "=Progress: [" <nul
for /l %%i in (1,1,10) do (
  set /p "=#" <nul
  ping -n 2 127.0.0.1 >nul
)
echo ] Done
```

> **Skills:** `.agents/skills/batch-scripting/SKILL.md`

## Anti-Patterns to Avoid

- ❌ Missing `@echo off` — floods output with every command line.
- ❌ Missing `setlocal` — pollutes the caller's environment with leaked variables.
- ❌ `%VAR%` inside a `for`/`if` block when the value changes during the block — use `!VAR!`.
- ❌ Unquoted paths — breaks on any path with a space (`Program Files`, `OneDrive` folders, etc.).
- ❌ Bare `exit` instead of `exit /b` — closes the parent shell if the script wasn't invoked with `call`.
- ❌ Ignoring `%ERRORLEVEL%` after commands that can fail.
- ❌ `goto`-spaghetti instead of `call :Subroutine` — impossible to follow control flow.
- ❌ Hardcoded absolute paths instead of `%~dp0`-relative ones.
- ❌ Leaving temp files behind on error paths — clean up in a `:Cleanup` routine called from every exit point, not just the happy path.
- ❌ Native ANSI-escape color tricks (`for /f ... echo prompt $E`) — unreliable, verified broken; delegate colored output to PowerShell instead.
- ❌ `timeout` for a script-internal delay — fails outside a real interactive console (`/nobreak` doesn't help); use `ping -n <N+1> 127.0.0.1 >nul` instead.

> **Skills:** `.agents/skills/batch-scripting/SKILL.md`
