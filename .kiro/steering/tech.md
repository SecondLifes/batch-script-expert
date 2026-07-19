# Technical Stack — Batch Script Expert

## Language and Compiler/Runtime

- **Language:** Windows Batch (`.bat` / `.cmd`)
- **Compiler/Runtime:** None — interpreted directly by `cmd.exe`
- **Build System:** None
- **Native IDE:** Any text editor; VS Code with a batch syntax-highlighting extension is common

## Main Frameworks

None — batch has no package ecosystem or framework layer. See External Dependencies below.

## Supported Databases

None. This template stays independent by design and does not borrow
`database-expert`'s skill — see `AGENTS.md` → Database.

## Concurrency / Async — Critical Rules

- **Rule of Thumb:** batch execution is sequential by default; `start "" /wait` blocks until a launched process exits, `start ""` without `/wait` does not and gives no way to check the child's result.
- Scheduled/independent concurrency goes through `schtasks.exe`, not in-script parallelism — batch has no locking primitive for coordinating concurrent writers.
- **Skills:** `.agents/skills/batch-scripting/SKILL.md`
- **Rules:** `.cursor/rules/batch-conventions.md` (generated from `.agents/rules/batch-conventions.md`)

## External Dependencies

Zero third-party dependencies by design. Capability beyond core batch commands
comes from Windows-native command-line utilities (`robocopy`, `findstr`,
`reg.exe`, `schtasks.exe`) and, when batch itself is insufficient (JSON
parsing, REST calls), shelling out to PowerShell. See
`.agents/skills/batch-scripting/references/common-utilities.md`.

## Code Standards

### File Types

| Extension | Description |
|----------|-----------|
| `.bat` | Batch script — this template's default choice |
| `.cmd` | Functionally equivalent to `.bat` under modern Windows; use only if the target environment already standardizes on it |

### Delayed Expansion

```batch
setlocal enabledelayedexpansion
set COUNT=0
for %%F in (*.txt) do (
  set /a COUNT+=1
  echo !COUNT!
)
```

Required whenever a variable is set and read within the same `for`/`if` block — see `.agents/rules/batch-conventions.md`.

## Testing and Quality

- **No automated test framework** — there is no equivalent for batch, and mocking `cmd.exe` builtins isn't practical.
- **Verification approach:** manual, structured execution against real `cmd.exe`, covering happy path, paths with spaces, missing/invalid inputs, deliberately forced error paths, delayed-expansion sanity checks, environment isolation, and unattended-context checks. Full checklist: `.agents/skills/batch-scripting/references/verification-checklist.md`.
- **Sign-off discipline:** a script is "verified" only once every applicable checklist item has been checked by actually running it — a static read does not count.
