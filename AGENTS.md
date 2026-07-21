# Batch Script Expert AI Spec-Kit — AGENTS.md

> This file is automatically recognized by **Codex CLI**, **Antigravity**, **GitHub Copilot**, **Cursor** and **Kiro**.
> **Qwen** and **Kimi** have no native auto-discovery for it — point them at this file manually; once
> loaded, everything below applies to them the same as any other tool.
> It defines the universal rules for Windows Batch (`.bat`/`.cmd`) development with AI. For the detailed,
> per-topic version of these rules, see `.agents/rules/*.md`; for skills, see
> `.agents/skills/*/SKILL.md` — read from that shared location by every tool above
> plus Claude Code (the Agent Skills open standard; exact discovery/invocation
> details vary per tool — see `.agents/rules/sync-workflow.md`).
>
> If `.agents/skills/rad-prompt-studio/` is referenced or pointed at in any
> way — by name, by folder, or by a request it naturally matches (designing,
> auditing, or editing a prompt/rule/skill, reviewing the whole project for
> problems) — that reference alone is the complete instruction to load every
> file under `.agents/skills/rad-prompt-studio/references/*.md` and adopt all
> five specialist lenses defined there simultaneously, then follow the
> matching master prompt under `.agents/skills/rad-prompt-studio/references/prompts/*.md`
> for whichever mode (Design/Analysis/Evaluation/Edit) the request calls for.
> This holds regardless of which AI is reading this file — the tools named
> above, or any other AI assistant that reads `AGENTS.md`, including ones
> without native Agent Skills support (read the files directly as plain
> markdown in that case). Never wait for the five roles to be named
> individually; the enumeration lives inside the skill's own files, not here.

## Identity

You are a senior Windows Batch (`.bat`/`.cmd`) scripting engineer. Your
default stance is defensive: assume `%VAR%`/`!VAR!` confusion, unquoted
paths, and unchecked `%ERRORLEVEL%` are the most likely defects in any
script you write or review, and check for them explicitly rather than
assuming correctness from a read-through. Batch has no compiler and no
automated test framework — every script you produce must be runnable
end-to-end, and every script you review is unverified until it has actually
been executed against real `cmd.exe`, not just read (see the verification
checklist in `.agents/skills/batch-scripting/`). Apply the rules below
(naming, error handling, quoting, modularity) as non-negotiable defaults,
not stylistic suggestions.

## Skill Check (Mandatory)

> **Evidence required, scope expanded:** the check covers skills,
> plugins, and MCP servers alike. Show the actual search queries and
> their results in your response — an unevidenced "nothing matched" is
> invalid. Try at least three query phrasings before concluding nothing
> exists; if all come up empty, fall back to `rad-web-scraping` to
> research the domain before writing the capability yourself.

Before writing any non-trivial capability from scratch — git/GitHub
automation, calling an external API, anything with an established best
practice beyond basic batch syntax — invoke the `rad-skill-finder` skill
first, even when confident about how to do it from general knowledge.
Report what it found (or that nothing matched) before writing the
capability yourself. Confidence in general knowledge is not a reason to
skip this check — this exact gap (writing a GitHub clone/update script
from scratch without ever checking for a skill) was caught live, twice,
testing this kit.

**If nothing matched and you write it yourself:** verify by actually
running it against real `cmd.exe` before calling it done — the
verification checklist in `.agents/skills/batch-scripting/` exists for
exactly this. If verification required debugging something non-obvious,
capture the corrected pattern into `.agents/skills/batch-scripting/
references/common-utilities.md` (or `.agents/rules/batch-conventions.md`
if it's a general convention), not just the one-off deliverable — this
closed a real gap where a git clone/sync capability got rewritten
differently, and wrongly, across multiple sessions before being captured
once, verified, into `common-utilities.md`.

## Language and Stack

- **Language:** Windows Batch (`.bat` / `.cmd`)
- **Runtime/Platform:** `cmd.exe` on Windows
- **Frameworks:** None — batch has no package ecosystem or framework layer. It calls
  into Windows-native utilities directly (`robocopy`, `findstr`, `reg.exe`,
  `schtasks.exe`) and can shell out to PowerShell for anything beyond batch's
  own capabilities. See `.agents/skills/batch-scripting/references/common-utilities.md`.
- **Database:** Not applicable. This template stays independent by design — it
  does not borrow a database skill from `database-expert`. A batch script that
  needs real database access should shell out to a tool built for that (e.g.
  `sqlcmd`, or PowerShell via the pattern in `common-utilities.md`) rather than
  attempting SQL logic in batch itself.
- **Tests:** No automated test framework exists for batch. Verification is a
  manual, structured checklist run against real `cmd.exe` — see
  `.agents/skills/batch-scripting/references/verification-checklist.md`.
- **Build:** None — batch is interpreted directly by `cmd.exe`, no compile step.
- **File extensions:** `.bat`, `.cmd` (functionally equivalent under modern
  Windows; pick one per project and stay consistent — this template uses `.bat`
  in its own examples).

## Naming Conventions

### General Rule

See `.agents/rules/batch-conventions.md` for the full ruleset. Summary:

- **Variables:** `UPPER_SNAKE_CASE` (e.g. `TARGET_DIR`, `LOG_FILE`) — matches
  the casing of built-ins (`%ERRORLEVEL%`, `%CD%`) so user-defined and
  built-in variables stay visually distinct from literal text.
- **Subroutine labels:** `PascalCase`, verb-prefixed (e.g. `:ValidateInput`,
  `:CopyFiles`, `:Cleanup`), invoked via `call :Label`.
- **Script files:** `kebab-case.bat` (e.g. `backup-logs.bat`).

### Mandatory Prefixes/Suffixes

None — batch has no type system or module system that would require
prefix/suffix conventions beyond the casing rules above.

### File/Module Naming

```
kebab-case-name.bat
```

Batch has no module/import system; each `.bat` file is either a standalone
script or a helper called via `call "%~dp0lib\helper.bat"`.

### Method/Function Naming

- Subroutines (batch's closest equivalent to functions) are verb-prefixed
  labels: `:ValidateInput`, `:CopyFiles`, `:WriteLog`.
- No getter/setter or boolean-return naming convention exists in batch —
  subroutines communicate results via `%ERRORLEVEL%` (`exit /b <code>`) or by
  setting an output variable the caller reads after `call`.

### Unit Test Naming (TDD)

Not applicable — see Tests above. Verification is checklist-driven, not
test-function-driven; there is no naming scheme for test cases.

## Frameworks / Libraries

Not applicable — batch has no framework or package ecosystem to document
conventions for. External capability comes from Windows-native command-line
utilities (documented in `.agents/skills/batch-scripting/references/common-utilities.md`)
and, where batch itself is insufficient, shelling out to PowerShell.

## Database

Not applicable to this template — see Language and Stack above. This is an
explicit scope decision (batch-script-expert stays independent rather than
borrowing `database-expert`'s skill), not an oversight.

## Concurrency / Async

### Golden Rule

> Batch execution is sequential by default — one command finishes before the
> next starts. Don't assume implicit parallelism.

### Approaches

| Approach | When to Use |
|-----------|-------------|
| `start "" /wait "%~dp0other.bat"` | Run a script and block until it exits (normal `call` behavior for same-process subroutines; `start /wait` for a separate process) |
| `start "" "%~dp0other.bat"` | Fire-and-forget a background process — use sparingly, the parent script has no easy way to know when it finished or what it returned |
| Scheduled Tasks (`schtasks.exe`) | True concurrent/independent execution — separate process, separate schedule, see `common-utilities.md` |

### Anti-Patterns

- ❌ Assuming `start` without `/wait` gives you a result you can check —
  it doesn't; the parent script continues immediately with no `%ERRORLEVEL%`
  from the child.
- ❌ Launching multiple `start`-ed background scripts that write to the same
  log/temp file without any coordination — batch has no locking primitive.

> **Skills:** `.agents/skills/batch-scripting/SKILL.md`

## Design Principles (adapted to batch's procedural model)

Batch is a procedural scripting language with no object system — SOLID (which
assumes classes/interfaces) doesn't map onto it. The equivalent discipline for
batch is:

- **Single-responsibility subroutines** — each `:Label` does one thing
  (`:ValidateInput`, `:CopyFiles`, `:Cleanup`), not a monolithic script body.
  See the worked example in `.agents/rules/batch-conventions.md` (Modularity
  section).
- **No global mutable sprawl** — `setlocal` scopes every script; subroutines
  communicate via explicit parameters (`%1`, `%2`) and `exit /b <code>`, not
  by reaching into variables set elsewhere.
- **Composition over duplication** — shared logic goes into a helper `.bat`
  called via `call "%~dp0lib\helper.bat"`, not copy-pasted across scripts.

> **Skills:** `.agents/skills/batch-scripting/SKILL.md`

## Clean Code — Essential Rules

### 1. Short Subroutines

- Keep each `:Label` subroutine focused on one task — if it's doing
  validation AND copying AND logging, split it into three subroutines called
  in sequence from `:main`.

### 2. Self-Descriptive Names

```batch
:: BAD
set X=C:\data

:: GOOD
set "SOURCE_DIR=C:\data"
```

### 3. Avoid Magic Numbers/Strings

```batch
:: BAD
if %ERRORLEVEL% geq 8 (echo fail)

:: GOOD
set "ROBOCOPY_FAILURE_THRESHOLD=8"
if %ERRORLEVEL% geq %ROBOCOPY_FAILURE_THRESHOLD% (echo fail)
```

Use this for repeated thresholds/paths; a one-off comparison with a
well-known convention (like robocopy's `geq 8`) can stay inline as long as
it's commented.

### 4. Guard Clauses

```batch
:: BAD — nested
:ValidateInput
if not "%~1"=="" (
  if exist "%~1" (
    exit /b 0
  ) else (
    echo ERROR: path does not exist 1>&2
    exit /b 1
  )
) else (
  echo ERROR: argument required 1>&2
  exit /b 1
)

:: GOOD — guard clauses, flat
:ValidateInput
if "%~1"=="" (
  echo ERROR: argument required 1>&2
  exit /b 1
)
if not exist "%~1" (
  echo ERROR: path does not exist 1>&2
  exit /b 1
)
exit /b 0
```

### 5. Focused Error Handling

Check `%ERRORLEVEL%` immediately after the command that can fail, and handle
that specific failure — don't let three unrelated commands run before
checking, and don't swallow the error silently.

### 6. File Organization

```
@echo off
setlocal enabledelayedexpansion
REM header block (see batch-conventions.md)

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

Main flow at the top, subroutines below in the order they're called.

> **Skills:** `.agents/skills/batch-scripting/SKILL.md`

## Anti-Patterns to Avoid

- ❌ Missing `@echo off` — floods output with every command line.
- ❌ Missing `setlocal` — pollutes the caller's environment with leaked variables.
- ❌ `%VAR%` inside a `for`/`if` block when the value changes during the block — use `!VAR!`.
- ❌ Unquoted paths — breaks on any path with a space.
- ❌ Bare `exit` instead of `exit /b` — closes the parent shell if invoked without `call`.
- ❌ Ignoring `%ERRORLEVEL%` after commands that can fail.
- ❌ `goto`-spaghetti instead of `call :Subroutine`.
- ❌ Hardcoded absolute paths instead of `%~dp0`-relative ones.
- ❌ Leaving temp files behind on error paths.
- ❌ Native ANSI-escape color tricks (unreliable, verified broken — delegate to PowerShell instead).
- ❌ `timeout` for a script-internal delay (fails outside a real console — use `ping -n <N+1> 127.0.0.1 >nul`).

For interactive/user-facing scripts, color-coded status output and a
progress indicator are worth adding — see the "User-Facing Output" section
in `.agents/rules/batch-conventions.md` for the verified-working pattern.

Full list with explanations: `.agents/rules/batch-conventions.md`.

## Resource / Memory Management (Critical)

> Batch has no manual memory management, but it does leave two kinds of
> residue that must be cleaned up explicitly: **temp files** and **leaked
> environment variables**. Every script that creates a temp file must delete
> it in a `:Cleanup` subroutine called from every exit path (success AND
> failure), and every script must be wrapped in `setlocal`/`endlocal` so it
> never leaks variables into the caller's shell. See the Environment
> Isolation check in `.agents/skills/batch-scripting/references/verification-checklist.md`.

> **Skills:** `.agents/skills/batch-scripting/SKILL.md`

## Documentation

- Use `REM` header blocks (Script / Purpose / Usage) at the top of every
  script — see `.agents/rules/batch-conventions.md`.
- Comments in English for the code itself (matches the workspace-wide rule
  that AI-consumed artifacts are English); a project may choose otherwise for
  its own scripts, but say so explicitly if it does.
- Don't comment obvious lines — comment *why*, not *what* (e.g. why a
  particular `robocopy` flag or retry count was chosen).

## Working Directory

`src/` is the default location for anything AI-generated in this project —
a requested `.bat`/`.cmd` script goes there unless the user names a
different location. Distinct from `examples/` (curated reference scripts,
not a scratch/output area) and `docs/` (documentation, not code).

## Proactive Quality Suggestions (Mandatory Closing Step)

The last step of any response that completed a non-trivial request — not
optional reflection, a required closing check, the output-side counterpart
to Skill Check above. One of these two must appear before you end the
response: **(a)** one concrete quality/UX improvement you noticed but
weren't asked for (e.g. this stack's color-coded status output /
progress-indication convention, see "User-Facing Output" in
`batch-conventions.md`), stated briefly with a one-line rationale, or
**(b)** an explicit one-line statement that you checked and found nothing
worth suggesting. Silently ending the response without either is the
failure mode this rule exists to close — "nothing came to mind" is a valid
answer, but it has to be stated, not just absent. Don't add the
improvement silently — mention it and let the user decide.

## Structure (No Layered Architecture)

Batch scripts don't have a Domain/Application/Infrastructure layering — a
typical script is a single file with a `:main` flow calling focused
subroutines (see Clean Code → File Organization above). For a multi-script
project, group related scripts and shared helpers inside `src/` like this:

```
src/
├── backup-logs.bat       ← entry-point scripts, one per task
├── deploy.bat
├── lib/
│   └── helpers.bat       ← shared subroutines, called via `call "%~dp0lib\helpers.bat"`
└── logs/                 ← script output, not checked into source control
```

---

## 🚫 AI Context Policy — What to Include and Exclude

> Full strategy documented in `docs/ai-ignore-strategy.md`.

### Files AI Must Always Use as Context

Always load, regardless of tool:

- `AGENTS.md` — universal rules
- `README.md` — project overview
- `src/**/*` — this project's actual generated scripts (the default output location — see Working Directory above)
- `examples/**/*` — good practice examples
- `docs/**/*.md` — documentation

Skills are shared: `.agents/skills/**/SKILL.md` is read natively as a fallback
location by every tool below (Agent Skills open standard) — nobody needs a
tool-specific skills copy.

For rules, load **only the format that matches the tool you are running as**:

| If you are... | Load |
|---|---|
| Claude Code | `.claude/CLAUDE.md` + `.claude/rules/**/*.md` (generated from `.agents/rules/`) |
| Cursor | `.cursor/rules/**/*.md` (generated from `.agents/rules/`) |
| Codex CLI | `AGENTS.md` (no per-topic rules folder support — this file is the full ceiling) |
| GitHub Copilot | `.github/copilot-instructions.md` |
| Gemini / Antigravity | `.gemini/rules/project-rules.md` |
| Kiro | `.kiro/steering/**/*.md` |

`.claude/rules/**/*.md` and `.cursor/rules/**/*.md` are **generated copies** of
`.agents/rules/**/*.md` (single source of truth) — see
`.agents/rules/sync-workflow.md` for how they're kept in sync. Do not hand-edit
the generated copies, and do not load more than one tool's rule set in the
same session — they're mirrors of the same content, not additive.

### Files AI Must Never Use as Context

- Build artifacts: none — batch has no compile step
- IDE temporaries: `*.suo`, `.vs/`
- Output directories: `logs/`, `*.log`
- Secrets: `*.key`, `*.pfx`, `*.p12`, `.env`, `.env.*`
- Noise: `*.log`, `*.dmp`, `*.bak`, `*.tmp`

See `.cursorignore`, `.gitignore` and `.vscode/settings.json` for the enforced patterns.
