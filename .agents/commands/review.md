# project:review

`project:review`

Please review the current diffs (`git diff` and `git diff --cached`) against this project's coding standards from `.claude/CLAUDE.md` and the appropriate rules within `.claude/rules/` (generated from the canonical `.agents/rules/`). Use the `batch-scripting` skill's golden rules as the review structure, and confirm at minimum that:
- Naming conventions (`UPPER_SNAKE_CASE` variables, `PascalCase` verb-prefixed subroutine labels, `kebab-case.bat` filenames) are respected.
- `%ERRORLEVEL%` is checked after every command that can fail, with `exit /b <code>` (never bare `exit`) used to propagate it.
- `!VAR!` (not `%VAR%`) is used for any variable read and written within the same `for`/`if` block.
- Every path is quoted (`set "VAR=value"`, `"%VAR%"`) and `%~dp0` is used for script-relative paths instead of a hardcoded or assumed working directory.
- Temp files and any environment leakage into the caller's shell are cleaned up via a `:Cleanup` subroutine called from every exit path, not just the happy path.
- If the script is meant to run unattended (scheduled task, CI step), confirm no command can block on interactive input.
