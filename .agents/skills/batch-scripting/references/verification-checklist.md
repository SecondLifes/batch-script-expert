## Why a Checklist Instead of a Test Framework

Batch has no automated test framework — there's no assertion library,
no test runner, and mocking `cmd.exe` builtins isn't practical. The
verification discipline for batch scripts is **manual, structured
execution against real `cmd.exe`**, covering the failure modes that
static reading of the script won't catch. Treat this checklist as
mandatory before considering a script "done," the same way a test suite
passing is mandatory in languages that have one.

## Pre-Flight: Run It For Real

Never declare a batch script correct from reading it alone — batch's
expansion rules (`%VAR%` vs `!VAR!`, quoting) produce bugs that are
easy to miss by eye and immediate when actually run. Line-ending problems
are the extreme case of this: a script saved with LF-only endings (common
when a script is written or edited by a tool that defaults to Unix line
endings) can look byte-for-byte correct in a text viewer while `cmd.exe`
misparses its multi-line `( )` blocks at runtime — see the Line Endings
rule in `.agents/rules/batch-conventions.md`. If a script throws
"X is not recognized" errors that reference fragments of otherwise-correct
lines, check line endings before anything else.

```batch
:: Run directly, watch the output
cmd /c "%~dp0script.bat" arg1 arg2

:: Check the exit code afterward
echo Exit code: %ERRORLEVEL%
```

## Checklist

### 1. Happy path

- [ ] Script runs to completion with valid, typical inputs.
- [ ] `%ERRORLEVEL%` is `0` after a successful run.
- [ ] Output/log content matches what's expected (not just "no crash").

### 2. Paths with spaces

- [ ] Run the script against a path containing a space (e.g. copy the
      target into `C:\Test Folder\`, or point it at a real
      `C:\Program Files\...` or `%USERPROFILE%\OneDrive\...` path).
      Unquoted-path bugs are invisible in normal testing because
      developer test paths rarely have spaces — this is the single most
      common gap between "tested" and "actually works."

### 3. Missing / invalid inputs

- [ ] Run with no arguments (if arguments are expected) — does it fail
      cleanly with a clear message, or does it proceed with blank
      variables and fail confusingly three commands later?
- [ ] Point it at a file/directory that doesn't exist — same check.
- [ ] Run it twice in a row (idempotency) — does a second run behave
      sanely, or does it error on "already exists" conditions it should
      have handled?

### 4. Error paths actually get exercised

- [ ] Force at least one failure condition deliberately (rename/hide a
      required file, point `robocopy` at an inaccessible path) and
      confirm:
  - The script detects it (`%ERRORLEVEL%` checked, not ignored).
  - It exits with a nonzero code via `exit /b N`, not a bare `exit`.
  - Any partial state (temp files, half-written output) is cleaned up —
    check the target directory/temp folder after the failed run, don't
    just check the console output.

### 5. Delayed expansion sanity check

- [ ] If the script sets and reads a variable inside the same
      `for`/`if` block, confirm the value shown is the *live* value
      (changes each iteration), not frozen at the pre-block value. This
      is the #1 batch bug class — verify it explicitly rather than
      assuming `setlocal enabledelayedexpansion` was applied correctly
      everywhere it's needed.

### 6. Environment isolation

- [ ] After the script exits, confirm it did **not** leak variables into
      the calling shell (open a fresh `cmd.exe`, run `set` before and
      after calling the script with `call`, diff the two — a missing or
      mismatched `setlocal`/`endlocal` shows up here).

### 7. Unattended-context checks (if the script will run scheduled/CI)

- [ ] No command in the script can block on interactive input (missing
      `/f` on `reg`/`schtasks`, a `pause` statement left in from
      debugging, a prompt-for-confirmation the script doesn't suppress).
- [ ] Logging goes to a file (`/LOG:`, redirection), not just the
      console — nobody will be watching the console for a scheduled run.

## Sign-Off

Only mark a batch script verified once every applicable item above has
been checked **by actually running the script**, not by reading it.
State plainly which checks were run and which were skipped (and why) —
"verified" without having executed the failure-path and space-in-path
cases is a static read, not a verification.
