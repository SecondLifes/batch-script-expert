# Structure and Conventions — Batch Script Expert

## Script Structure (No Layered Architecture)

Batch scripts don't have a Domain/Application/Infrastructure layering. A
script is a single file with a short `:main` flow at the top calling focused,
single-purpose subroutines below it:

```batch
@echo off
setlocal enabledelayedexpansion
REM header block

:main
call :ValidateInput "%~1"
call :DoWork
call :Cleanup
exit /b 0

:ValidateInput
...
exit /b 0

:DoWork
...
exit /b 0

:Cleanup
...
exit /b 0
```

## Multi-Script Project Layout

```
project/
├── backup-logs.bat       ← entry-point scripts, one per task
├── deploy.bat
├── lib/
│   └── helpers.bat       ← shared subroutines, called via `call "%~dp0lib\helpers.bat"`
└── logs/                 ← script output, not checked into source control
```

## File/Module Naming

### Standard
```
kebab-case-name.bat
```

### Examples

| Element | Standard | Example |
|--------|--------|---------|
| Script file | `kebab-case.bat` | `backup-logs.bat` |
| Subroutine label | `PascalCase`, verb-prefixed | `:ValidateInput`, `:CopyFiles` |
| Variable | `UPPER_SNAKE_CASE` | `TARGET_DIR`, `LOG_FILE` |

## Component Naming

Not applicable — batch has no component-based UI or module system.

## File Sections

```
@echo off
setlocal enabledelayedexpansion
REM header (Script / Purpose / Usage)

:main                    ← short orchestration flow
:ValidateInput            ← subroutines below, in call order
:DoWork
:Cleanup
```
