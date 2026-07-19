# Constitution — Batch Script Expert Spec-Kit

> Fundamental principles that govern all development in this project.

## Language and Platform

This project uses **Windows Batch (`.bat`/`.cmd`)** run via **`cmd.exe`**, with no framework or data-access layer (batch has neither). All generated code MUST follow the conventions in `.agents/rules/batch-conventions.md`.

## Non-Negotiable Principles

### 1. Correct Variable Expansion Always

- **`%VAR%`** for parse-time expansion (default, outside loops/blocks whose values change).
- **`!VAR!`** (with `setlocal enabledelayedexpansion`) whenever a variable is set and read within the same `for`/`if` block. Mixing these up is the single most common batch bug and fails silently, not loudly.

### 2. Defensive Error Handling Always

- Check `%ERRORLEVEL%` after every command that can fail — batch does not stop on error by default.
- `exit /b <code>` to return a status, never bare `exit` (which closes the parent shell if the script wasn't invoked with `call`).
- Command-specific success ranges are respected (e.g. `robocopy`: 0-7 is success, only `geq 8` is failure).

### 3. Modular Structure

```
:main → call :ValidateInput → call :DoWork → call :Cleanup → exit /b 0
```

Each subroutine (`:Label`) has one responsibility. No `goto`-spaghetti — flow
is orchestrated from a short `:main` block calling named subroutines.

### 4. Batch Naming Conventions

- Variables: `UPPER_SNAKE_CASE`.
- Subroutine labels: `PascalCase`, verb-prefixed (`:ValidateInput`).
- Script files: `kebab-case.bat`.

### 5. Absolute Prohibitions

- ❌ `%VAR%` inside a `for`/`if` block whose value changes during the block.
- ❌ Unquoted paths.
- ❌ Bare `exit` instead of `exit /b <code>`.
- ❌ Ignoring `%ERRORLEVEL%` after a command that can fail.
- ❌ `goto`-spaghetti instead of `call :Subroutine`.
- ❌ Leaving temp files or leaked environment variables behind on any exit path.

## Development Process

1. **Specify** — Define what the script does, its inputs/arguments, and its expected exit codes (`.specify/spec-template.md`)
2. **Plan** — Sketch the subroutine breakdown before writing the full script (`.specify/plan-template.md`)
3. **Implement** — Following `.agents/rules/batch-conventions.md`
4. **Verify** — Run the manual checklist in `.agents/skills/batch-scripting/references/verification-checklist.md` against real `cmd.exe` — there is no automated test framework for batch
5. **Review** — `/review` against this constitution and `.agents/rules/batch-conventions.md`
