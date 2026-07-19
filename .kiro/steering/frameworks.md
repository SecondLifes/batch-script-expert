# Frameworks — Batch Script Expert Spec-Kit

## Supported "Frameworks"

Batch has no package ecosystem or framework layer. Capability beyond core
batch commands comes from Windows-native command-line utilities and
PowerShell interop — documented as a skill rather than a framework section:

### Windows-Native Utilities

- **When to use:** file copying (`robocopy`), text search (`findstr`), parsing
  file/command output (`for /f`), registry access (`reg.exe`), scheduled
  tasks (`schtasks.exe`).
- **Skills:** `.agents/skills/batch-scripting/references/common-utilities.md`
- **Rules:** `.cursor/rules/batch-conventions.md` (generated)

### PowerShell Interop

- **When to use:** anything batch can't do natively — JSON parsing, REST
  calls, real object manipulation.
- **Pattern:** `powershell -NoProfile -ExecutionPolicy Bypass -Command "..."`,
  checking `%ERRORLEVEL%` afterward.
- **Skills:** `.agents/skills/batch-scripting/references/common-utilities.md` → "Calling PowerShell from Batch"

## Database

Not applicable — see `AGENTS.md` → Database. This template stays independent
by design.

## Framework Decision

```
Need to copy files reliably?        → robocopy (never xcopy/copy for anything beyond a single file)
Need to search text?                → findstr
Need to parse a file or command output line-by-line? → for /f
Need registry read/write?           → reg.exe
Need a recurring/scheduled run?     → schtasks.exe
Need JSON, REST, or real objects?   → shell out to PowerShell
```

## Common Combinations

| Task | Utility | Notes |
|------|---------|-------|
| Log rotation / backup | `robocopy` + `forfiles` or date arithmetic | Always set `/R:3 /W:5` for unattended runs |
| Config read at startup | `reg.exe query` or a `for /f` over a `.ini`-style file | Escape redirection inside backtick commands with `^` |
| Health check on a schedule | `schtasks.exe` + a script that logs to file | Never rely on console output for a scheduled run |

## Transversal Golden Rule (Error Handling)

Regardless of which utility is used:
1. **Check `%ERRORLEVEL%` immediately after the command, using the right success threshold for that command** (e.g. `robocopy`'s `geq 8`, not any-nonzero).
2. **Transparent errors:** don't silently swallow a failure with `2>nul` unless you are specifically using it as a boolean existence check with a follow-up `%ERRORLEVEL%` check — never suppress and ignore.

## General Rules

- Naming conventions (`.agents/rules/batch-conventions.md`) always apply
- Modularity via `call :Subroutine` always applies
- Manual verification (`.agents/skills/batch-scripting/references/verification-checklist.md`) is mandatory before considering any script done
