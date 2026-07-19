# Tasks: [Script Name]

## Legend

- `[ ]` — Pending
- `[/]` — In progress
- `[x]` — Completed

## 1. Script Skeleton

- [ ] Create `[script-name].bat` with `@echo off` + `setlocal enabledelayedexpansion` + header block (Script/Purpose/Usage)
- [ ] Write `:main` flow calling `:ValidateInput`, `:DoWork`, `:Cleanup` in order
- [ ] Add `exit /b 0` at the end of `:main`

## 2. ValidateInput

- [ ] Check required arguments are present (`if "%~1"==""`)
- [ ] Check paths/preconditions exist (`if not exist`)
- [ ] Exit 1 with a clear stderr message on any failure

## 3. DoWork

- [ ] Implement the script's core task
- [ ] Quote every path used
- [ ] Use `!VAR!` for any variable set and read within the same loop/block
- [ ] Check `%ERRORLEVEL%` after every command that can fail, using the correct success threshold for that command

## 4. Cleanup

- [ ] Delete any temp files created during the run
- [ ] Ensure `:Cleanup` is called from every exit path (success AND failure), not just the happy path

## 5. Manual Verification

(No automated test framework exists for batch — see `.agents/skills/batch-scripting/references/verification-checklist.md`)

- [ ] Happy path: runs to completion, `%ERRORLEVEL%` is 0, output matches expectation
- [ ] Path with a space in it (e.g. `C:\Program Files\...` or `C:\Test Folder\`)
- [ ] Missing/invalid arguments — fails cleanly with a clear message
- [ ] Run twice in a row — idempotency check, if applicable
- [ ] Force at least one failure path deliberately — confirm it's detected, exits nonzero, and cleans up partial state
- [ ] Delayed-expansion sanity check inside any `for`/`if` block
- [ ] Environment isolation — no leaked variables into the caller's shell after the script exits
- [ ] Unattended-context check — no command can block on interactive input, logging goes to a file if scheduled

## 6. Integration and Review

- [ ] Register the script wherever it's invoked from (scheduled task, deployment pipeline, README)
- [ ] `/review` against `.agents/rules/batch-conventions.md` and `.specify/constitution.md`
- [ ] Sign off only after every applicable checklist item above was actually run, not just read
