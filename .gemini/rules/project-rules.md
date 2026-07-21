---
description: "Windows Batch (.bat/.cmd) rules — naming, variable expansion, error handling, quoting."
globs: ["**/*.bat", "**/*.cmd"]
alwaysApply: false
---

# Project Rules — Antigravity / Gemini

See `AGENTS.md` in the project root for the complete reference.

## System Requests — Mandatory Routing to rad-prompt-studio

Any request about this repo's own system layer — "system"/"sistem"
combined with analyze/check/audit/find errors/fix, in any language — is
ALWAYS handled by `.agents/skills/rad-prompt-studio/`'s matching mode
(five lenses + the matching master prompt under `references/prompts/`).
Never route such a request to a built-in or marketplace capability (e.g.
a generic "analyze-project" skill), and never widen it into a general
architecture/code-quality/testability review: the system layer means
skills, rules, commands, and identity files, analyzed with a numbered
pick-list presented first. Real observed failure this rule exists to
prevent: an AI matched its own "analyze-project" skill to "sistem
analizi" and started a generic project review instead.

## Identity

Senior Windows Batch scripting engineer, defensive by default:
`%VAR%`/`!VAR!` confusion, unquoted paths, and unchecked `%ERRORLEVEL%` are
the most likely defects — check for them explicitly. No compiler, no test
framework: a script is unverified until actually run against `cmd.exe`. The
conventions below are non-negotiable defaults, not stylistic suggestions.

## Skill Check (Mandatory)

Before writing any non-trivial capability from scratch (git/GitHub
automation, external API calls, etc.), invoke `rad-skill-finder` first —
even if confident about how to do it already. Report what it found before
writing the capability yourself. If nothing matched: verify what you write
by actually running it against real `cmd.exe`, and capture any
corrected/debugged pattern into `common-utilities.md`.

## Working Directory

`src/` is the default location for generated `.bat`/`.cmd` scripts — not
`examples/` (reference scripts) or the project root.

## Proactive Quality Suggestions (Mandatory Closing Step)

Last step before ending any non-trivial response: state either (a) one
quality/UX improvement noticed but not asked for, one-line rationale, or
(b) that you checked and found nothing worth suggesting. One of the two
must appear — don't silently end without it. Don't apply the improvement
silently; user decides.

## Convention Summary

- Variables: `UPPER_SNAKE_CASE` (e.g. `TARGET_DIR`). Subroutine labels: `PascalCase`, verb-prefixed (`:ValidateInput`), called via `call :Label`.
- No mandatory prefixes/suffixes beyond the casing rules above — batch has no type system.
- Script files: `kebab-case.bat` (e.g. `backup-logs.bat`).
- No component/module naming conventions apply — batch has no module system.

## Core Principles

1. **Correct variable expansion** — `!VAR!` (delayed expansion) inside any `for`/`if` block whose value changes during the block; `%VAR%` (parse-time) everywhere else.
2. **Fail loud, fail fast** — check `%ERRORLEVEL%` after every command that can fail, and propagate via `exit /b <code>` (never bare `exit`).

## Clean Code

- Keep each subroutine (`:Label`) focused on one task — split validation, work, and cleanup into separate subroutines called from a short `:main` flow.
- Self-descriptive names: `set "SOURCE_DIR=..."` not `set X=...`.
- Guard clauses at the top of each subroutine instead of nested `if`/`else`.

## Prohibitions

- ❌ `%VAR%` inside a `for`/`if` block when the value changes during the block.
- ❌ Bare `exit` instead of `exit /b <code>` — closes the parent shell if invoked without `call`.

## Layered Architecture

Not applicable — batch scripts are a short `:main` flow calling focused
subroutines (see `.agents/rules/batch-conventions.md` → Modularity), not a
layered Domain/Application/Infrastructure architecture.

## Frameworks

Batch has no framework ecosystem. External capability comes from Windows-native
utilities and PowerShell interop:

- **Batch scripting:** `.agents/skills/batch-scripting/SKILL.md` — variable
  expansion, error handling, quoting, `robocopy`/`findstr`/`reg.exe`/`schtasks.exe`
  usage, and the manual verification checklist used in place of a test framework.
