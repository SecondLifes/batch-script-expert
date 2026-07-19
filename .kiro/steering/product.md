# Product — Batch Script Expert Spec-Kit

## Purpose

This spec-kit provides the rules, conventions and standards for developing **Windows Batch (`.bat`/`.cmd`)** scripts with the help of AI assistants. It ensures that all generated code follows:

- Correct **variable expansion** (`%VAR%` vs `!VAR!`) — the single most common source of silent batch bugs
- **Defensive error handling** (`%ERRORLEVEL%` checked, `exit /b <code>`, never bare `exit`)
- **Quoted paths** and `%~dp0`-relative script paths
- **Modular structure** (`call :Subroutine`) instead of `goto`-spaghetti
- A **manual verification checklist** in place of a formal test framework, since none exists for batch

## Target Audience

- Windows administrators and developers writing automation, deployment or scheduled-task scripts
- Teams that want AI-generated batch scripts to avoid the classic expansion/quoting/error-handling bugs
- Anyone maintaining legacy `.bat`/`.cmd` scripts who wants AI assistance grounded in correct conventions

## References

- `AGENTS.md` in the project root contains the complete reference of all rules
- `.agents/skills/batch-scripting/SKILL.md` and its `references/` cover common utilities and verification
- Code examples in `examples/` demonstrate the applied patterns
