---
name: "Batch Scripting"
description: "Windows Batch (.bat/.cmd) scripting — variable expansion, error handling, quoting, common utilities (robocopy, findstr, reg, schtasks), and a manual verification checklist since there is no formal test framework for batch. Use when writing, reviewing, or debugging .bat/.cmd scripts."
---

# Batch Scripting — Skill

Use this skill when working with Windows Batch (`.bat`/`.cmd`) scripts run
via `cmd.exe`.

## When to Use

- Writing a new `.bat`/`.cmd` automation script
- Debugging a script that behaves differently than expected (usually a
  variable-expansion or quoting bug — see Golden Rules)
- Reviewing a batch script before it's relied on unattended (scheduled
  task, CI step, deployment script)
- Deciding how to verify a batch script actually works, since there's no
  automated test framework for this language

## Golden Rules

- **CRLF line endings, always** — a file saved with LF-only endings can make `cmd.exe` misparse multi-line `( )` blocks with confusing errors; see `.agents/rules/batch-conventions.md`.
- **`@echo off` + `setlocal enabledelayedexpansion`** at the top of every script.
- **`!VAR!` not `%VAR%`** inside any `for`/`if` block where the variable's value changes during the block.
- **Quote every path**: `set "VAR=value"` and `"%VAR%"` wherever it's used — an unquoted path with a space silently breaks.
- **`exit /b <code>`, never bare `exit`** — bare `exit` closes the calling shell too if the script wasn't invoked with `call`.
- **Check `%ERRORLEVEL%`** after any command that can fail; for `robocopy` specifically, only `geq 8` is a real failure (0-7 are success variants).
- **`%~dp0`** for script-relative paths — never assume the caller's working directory.
- **Colored output → delegate to PowerShell, never native ANSI-escape tricks** (verified unreliable); **delays → `ping -n <N+1> 127.0.0.1 >nul`, never `timeout`** (fails outside a real console) — see `.agents/rules/batch-conventions.md`'s "User-Facing Output" section.

Full conventions and code patterns are in `.agents/rules/batch-conventions.md`. This skill's `references/` covers what that rules file doesn't: common external utilities and how to verify a script actually works.

## references/

- `common-utilities.md` — `robocopy`, `findstr`, `for /f` parsing, `reg.exe`, `schtasks.exe`, `git.exe` clone-if-missing/sync-if-present (verified pattern — folder-from-repo-name, real default-branch resolution, force-sync update), calling PowerShell from batch for things batch can't do natively.
- `verification-checklist.md` — the manual verification process to run before trusting a batch script (no automated test framework exists for this language) — covers exit-code paths, space-in-path testing, missing-file scenarios, and cleanup-on-error verification.
