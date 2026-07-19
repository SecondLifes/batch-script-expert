# Technical Plan: [Script Name]

## Overview

<!-- Summary of how the script will be structured and what it does -->

## Subroutine Breakdown

```
:main
  ├── call :ValidateInput   ← argument/precondition checks, exits 1 on failure
  ├── call :DoWork          ← the script's actual purpose
  └── call :Cleanup         ← always runs, even on failure paths
```

## Execution Sequence

```
[main] → :ValidateInput → :DoWork (→ external utility, e.g. robocopy/reg/schtasks) → :Cleanup → exit /b N
```

## Subroutines to Create

| Label | Responsibility |
|---------|-----------|
| `:ValidateInput` | Argument presence/validity checks — exits 1 with a clear stderr message on failure |
| `:DoWork` | The script's core task |
| `:Cleanup` | Removes temp files, called from every exit path |

## External Utilities Used

| Utility | Purpose |
|---------|---------|
| [FILL IN: e.g. `robocopy`] | [FILL IN: e.g. file sync with retry] |

See `.agents/skills/batch-scripting/references/common-utilities.md` for usage patterns.

## Risks and Considerations

- [Risk 1 and how to mitigate — e.g. locked file during robocopy, mitigated by `/R:3 /W:5`]
- [Risk 2 and how to mitigate]

## Compliance Checklist

- [ ] Correct `%VAR%`/`!VAR!` usage throughout
- [ ] `%ERRORLEVEL%` checked after every command that can fail
- [ ] All paths quoted, `%~dp0` used for script-relative paths
- [ ] `exit /b <code>` used everywhere, no bare `exit`
- [ ] `:Cleanup` called from every exit path
- [ ] No interactive prompts if this script runs unattended
- [ ] Manual verification checklist run against real `cmd.exe` before sign-off
