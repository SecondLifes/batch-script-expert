# 🚀 Batch Script Expert AI Spec-Kit

<div align="center">

**An opinionated ecosystem of rules, *skills* and *steerings* to elevate Windows Batch (`.bat`/`.cmd`) scripting to state-of-the-art with Artificial Intelligence.**

[![🇹🇷 Türkçe ](https://img.shields.io/badge/Turkish-Türkiye-red)](README.tr-TR.md)
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache--2.0-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)
[![GitHub Copilot](https://img.shields.io/badge/GitHub%20Copilot-Ready-blue?logo=github)](https://github.com/features/copilot)
[![Cursor](https://img.shields.io/badge/Cursor-Rules-purple)](https://cursor.sh)
[![Claude](https://img.shields.io/badge/Claude-Code-brown?logo=anthropic)](https://claude.ai)
[![Gemini](https://img.shields.io/badge/Gemini-Skills-orange?logo=google)](https://gemini.google.com)
[![Kiro](https://img.shields.io/badge/Kiro-Steering-teal)](https://kiro.dev)
[![Qwen](https://img.shields.io/badge/Qwen-AGENTS.md-purple)](https://chat.qwen.ai)
[![Kimi](https://img.shields.io/badge/Kimi-AGENTS.md-lightgrey)](https://kimi.moonshot.cn)

*[🇹🇷 Türkçe](README.tr-TR.md) · [Contributing](CONTRIBUTING.md) · [Code of Conduct](CODE_OF_CONDUCT.md) · [Security](SECURITY.md) · [Acknowledgments](ACKNOWLEDGMENTS.md)*

<!-- ![Overview](docs/images/overview.png) -->
<!-- Generate this image using the "Image 1 — Overview" prompt in Prompts/image-prompts.md, save it to docs/images/overview.png, then uncomment the line above. -->

</div>

## 📋 Index

- [Turkish-](README.tr-TR.md)Türkçe
- [What is this project?](#-what-is-this-project)
- [Why use?](#-why-use)
- [Supported AI-Tools](#-supported-ai-tools)
- [Main Guidelines](#-main-guidelines-taught-to-ai)
- [Kit Structure](#-kit-structure)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Code Examples](#-examples-of-good-practices)
- [Design & Philosophy](#-design--philosophy)
- [Acknowledgments](#-acknowledgments)
- [Contributions](#-contributions)

---

## 💡 What is this project?

The **Batch Script Expert AI Spec-Kit** is not a code framework — it's a set of **behavior guidelines** for your favorite AI. It "teaches" the assistant to write Windows Batch (`.bat`/`.cmd`) scripts that are:

- ✅ **Clean** — modular subroutines (`call :Label`) instead of `goto`-spaghetti, short focused blocks, guard clauses
- ✅ **Safe** — correct `%VAR%` vs `!VAR!` expansion, quoted paths, `%ERRORLEVEL%` checked after every command that can fail, no environment leakage into the caller's shell
- ✅ **Verifiable** — a manual checklist covering the failure modes static reading can't catch (paths with spaces, missing inputs, error paths actually exercised), since batch has no formal test framework
- ✅ **Unattended-ready** — no interactive prompts left in scripts meant to run scheduled or in CI, logging to file rather than console-only

> Without this kit, AI-generated batch scripts routinely mix up `%VAR%`/`!VAR!` inside loops (silently wrong output, not a crash), leave paths unquoted (breaks the moment someone's username has a space in it), and never check `%ERRORLEVEL%` — three bug classes that are invisible until the script runs somewhere slightly different from where it was written.

---

## 🤔 Why use it?

| Without Spec-Kit | With the Spec-Kit |
|---|---|
| `%VAR%` used inside a `for`/`if` block — silently stale value | `!VAR!` with `setlocal enabledelayedexpansion` — correct live value |
| Unquoted paths — breaks on `Program Files`/`OneDrive` | Every path quoted, `%~dp0` used for script-relative paths |
| `%ERRORLEVEL%` ignored after risky commands | Checked after every command that can fail, `robocopy`'s 0-7-success nuance respected |
| Bare `exit` closing the caller's shell | `exit /b <code>` everywhere |
| "It ran once, ship it" | Structured manual verification checklist before sign-off |

---

## 🤖 Supported AI Tools

| Tool | Configuration File | How It Works |
|---|---|---|
| **GitHub Copilot** | `.github/copilot-instructions.md` | Pre-prompt injected into Workspace/Chat |
| **Cursor** | `.cursor/rules/*.md` (generated) | Rules loaded by context |
| **Claude Code** | `.claude/` (rules generated, skills shared) | Rules by context and skills in the terminal |
| **Codex CLI** | `AGENTS.md` | Reads it directly, no dedicated folder needed |
| **Google Gemini / Antigravity** | `.gemini/rules/project-rules.md` | Summary rules, condensed like `AGENTS.md` |
| **Kiro AI** | `.kiro/steering/*.md` | Stack and architectural constraints |
| **Qwen / Kimi** | `AGENTS.md` (manual) | No native auto-discovery — point the tool at `AGENTS.md` explicitly; unlike the tools above, it is not read automatically |
| **Any AI** | `AGENTS.md` | Universal rules (project root) |
| **All of the above** | `.agents/skills/*/SKILL.md` | Shared skills — Agent Skills open standard, one copy for every tool |

> Rules and commands have a single canonical source at `.agents/rules/` and
> `.agents/commands/`; `.claude/rules`, `.cursor/rules` and `.claude/commands`
> are generated from it by `tools/generate-ai-configs.ps1` — see
> `.agents/rules/sync-workflow.md`.

---

## 🌟 Main Guidelines Taught to AI

<!-- ![Core Features](docs/images/core-features.png) -->
<!-- Generate this image using the "Image 2 — Core Features" prompt in Prompts/image-prompts.md, save it to docs/images/core-features.png, then uncomment the line above. -->

### Variable Expansion — the #1 Source of Bugs

```batch
:: WRONG — %COUNT% is frozen at the pre-loop value
for %%F in (*.txt) do (
  set /a COUNT+=1
  echo %COUNT%
)

:: RIGHT — delayed expansion reads the live value
setlocal enabledelayedexpansion
for %%F in (*.txt) do (
  set /a COUNT+=1
  echo !COUNT!
)
```

### Error Handling

```batch
robocopy "%SOURCE%" "%DEST%" /E
if %ERRORLEVEL% geq 8 (
  echo ERROR: robocopy failed with code %ERRORLEVEL% 1>&2
  exit /b 1
)
```

### Modularity — Subroutines over GOTO Spaghetti

```batch
call :ValidateInput "%~1"
if errorlevel 1 exit /b 1
call :CopyFiles "%~1" "%~2"
call :Cleanup
exit /b 0
```

Full rules and worked examples: `.agents/rules/batch-conventions.md`.

---

## 📂 Kit Structure

```
batch-script-expert/
│
├── AGENTS.md                        # 🌐 Universal rules (Codex, Copilot, Kiro, Antigravity, Gemini)
│
├── .agents/                         # 📦 SINGLE SOURCE OF TRUTH — edit here, nowhere else
│   ├── rules/
│   │   ├── sync-workflow.md         # How this whole multi-tool setup is kept in sync — read first
│   │   └── batch-conventions.md     # Windows Batch conventions — naming, expansion, error handling, quoting
│   ├── commands/
│   │   └── review.md                # Slash-command source: /review
│   └── skills/
│       ├── batch-scripting/
│       │   ├── SKILL.md             # Entry point — golden rules, when to use
│       │   └── references/
│       │       ├── common-utilities.md        # robocopy, findstr, for /f, reg.exe, schtasks.exe, PowerShell interop
│       │       └── verification-checklist.md  # Manual verification checklist (no test framework exists for batch)
│       ├── rad-skill-finder/        # Bundled — finds existing skills before writing one from scratch
│       ├── rad-python/              # Bundled — for ad-hoc helper scripts the AI writes while working here
│       ├── rad-prompt-studio/       # Bundled — five-lens prompt design/audit/edit, used to write this file's Identity section
│       └── rad-web-scraping/        # Bundled — web scraping / structured data extraction (tool selection, discovery priority)
│
├── tools/
│   └── generate-ai-configs.ps1      # Regenerates .claude/rules, .cursor/rules, .claude/commands
│
├── .claude/
│   ├── CLAUDE.md                    # 🧠 Master system prompt for Claude
│   ├── settings.json                # Permission settings
│   ├── commands/                    # ⚙️ GENERATED from .agents/commands — do not hand-edit
│   └── rules/                       # ⚙️ GENERATED from .agents/rules — do not hand-edit
│
├── .github/
│   └── copilot-instructions.md      # 🤖 Pre-prompt for GitHub Copilot
│
├── .cursor/
│   └── rules/                       # ⚙️ GENERATED from .agents/rules — do not hand-edit
│
├── .gemini/
│   └── rules/
│       └── project-rules.md         # Hand-authored summary, same role as AGENTS.md but Gemini-specific
│
├── .kiro/
│   └── steering/
│       ├── product.md               # Product vision
│       ├── tech.md                  # Technology stack
│       ├── structure.md             # Script/subroutine organization
│       └── frameworks.md            # External utilities (robocopy, reg.exe, etc.)
│
├── .specify/                        # AI-assisted spec templates
│   ├── constitution.md
│   ├── plan-template.md
│   ├── spec-template.md
│   └── tasks-template.md
│
├── docs/
│   ├── proje-haritasi.md            # "What does every file do" map (human-facing, Turkish)
│   ├── ai-ignore-strategy.md        # AI context inclusion/exclusion strategy
│   └── batch-script-expert-analysis.md  # Five-lens self-audit of this kit
│
├── examples/                        # Complete example .bat scripts
│
└── src/                             # 🎯 Default working/output root — scripts
    └── README.md                    # you ask for land here unless told otherwise
```

---

## 🔧 Prerequisites

- **Windows + `cmd.exe`** — the whole point of this kit.
- **PowerShell 7+ (`pwsh`)** — required to run `tools/generate-ai-configs.ps1`.
- **Node.js / `npx`** — required only for the bundled `rad-skill-finder` skill's
  primary search path (`npx skills find <topic>`). Not required to use the
  kit itself; without it, `rad-skill-finder` falls back to its web-based
  search steps (GitHub directories, `github.com/topics/*`, WebSearch) — see
  `.agents/skills/rad-skill-finder/SKILL.md`.

---

## ⚡ Quick Start

### 1. Copy the kit to the root of your project

```
YourProject/
├── build.bat                 ← your own scripts
├── AGENTS.md                 ← copy from the root
├── .agents/                  ← copy the folder (single source of truth: rules, commands, skills)
├── tools/                    ← copy the folder (generate-ai-configs.ps1)
├── .claude/                  ← copy the folder (generated rules/commands already included)
├── .github/                  ← copy the folder
├── .cursor/                  ← copy the folder (generated rules already included)
├── .gemini/                  ← copy the folder
├── .kiro/                    ← copy the folder
└── .specify/                 ← copy the folder (optional — spec templates)
```

If you later add or edit a file under `.agents/rules/` or `.agents/commands/`,
re-run `pwsh tools/generate-ai-configs.ps1` from the project root to refresh
`.claude/rules`, `.cursor/rules` and `.claude/commands`.

### 2. AI automatically takes over the rules

- **Claude Code** — Applies `.claude/CLAUDE.md`, reads `.claude/rules/*.md` (generated) and `.agents/skills/batch-scripting/SKILL.md` directly
- **Cursor** — Reads `.cursor/rules/*.md` (generated) automatically by context
- **Codex CLI** — Reads `AGENTS.md` at the project root, plus the skill
- **GitHub Copilot** — Reads `.github/copilot-instructions.md` in workspace, plus the skill
- **Antigravity / Gemini** — Reads `.gemini/rules/project-rules.md`, plus the skill
- **Kiro** — Reads `.kiro/steering/*.md` as fixed product context

> **No additional configuration required.** Open the project, use your preferred AI and notice the difference.

---

## 💡 Examples of Good Practices

```batch
@echo off
setlocal enabledelayedexpansion

call :ValidateInput "%~1"
if errorlevel 1 exit /b 1

call :CopyFiles "%~1" "%~2"
call :Cleanup
exit /b 0

:ValidateInput
if "%~1"=="" (
  echo ERROR: source path required 1>&2
  exit /b 1
)
exit /b 0

:CopyFiles
robocopy "%~1" "%~2" /E /R:3 /W:5
if %ERRORLEVEL% geq 8 exit /b 1
exit /b 0

:Cleanup
del /q "%TEMP%\myapp_*.tmp" 2>nul
exit /b 0
```

Guard clauses, quoted paths, focused subroutines, `robocopy`'s success-range
respected, cleanup on every exit path — see `.agents/rules/batch-conventions.md`
for the full ruleset behind this example.

---

## 🎯 Design & Philosophy

<!-- ![Design & Philosophy](docs/images/design-philosophy.png) -->
<!-- Generate this image using the "Image 3 — Design & Philosophy" prompt in Prompts/image-prompts.md, save it to docs/images/design-philosophy.png, then uncomment the line above. -->

**Never trust a script until it's actually been run.**

Batch has no compiler, no type system, and no test framework — a script
that reads correctly can still be silently wrong (a `%VAR%`/`!VAR!` mixup,
a line-ending problem invisible in a text editor) or catastrophically
wrong (a bare `exit` closing the caller's shell, an unquoted path breaking
on the first `Program Files` install it meets). This kit's central design
tradeoff is favoring **manual, structured verification** over the false
confidence of a clean read-through: every rule it teaches exists to
either prevent a specific failure mode outright (quoting, `exit /b`,
`errorlevel` checks) or to force that failure mode to be exercised before
sign-off (the verification checklist's space-in-path, missing-input, and
error-path tests). The payoff is scripts that are boring in the best
sense — unattended-ready, logging to file instead of a console nobody is
watching, and safe to trust the day they're deployed rather than the day
someone happens to notice a bug.

---

## 🚫 AI Ignore / Context Checklist

This project enforces a multi-layer strategy to control what AI agents index and use as context. Before submitting a PR:

- [ ] `.cursorignore` includes any new heavy or binary paths
- [ ] Essential instruction files (`AGENTS.md`, rules, skills, examples) are **NOT** excluded
- [ ] `.vscode/settings.json` excludes are up to date for new artifact types
- [ ] No secrets (`*.key`, `*.pfx`, `.env`) are committed or referenced

> See [docs/ai-ignore-strategy.md](docs/ai-ignore-strategy.md) for the full rationale and maintenance guide.

---

## 🙏 Acknowledgments

See [ACKNOWLEDGMENTS.md](ACKNOWLEDGMENTS.md) for the documentation and
built-in Windows tooling this kit's conventions were derived from.

---

## 🤝 Contributions

Pull Requests are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for the
full guide (bug reports, PR process, technical standards) and
[CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) for community expectations.
Found a security issue instead? See [SECURITY.md](SECURITY.md) — don't
open a public issue for it.

Quick version — if a new external utility or pattern needs a guide for AI, add:

1. **Rule** → `.agents/rules/batch-conventions.md` (extend it) or a new topic file, then run `pwsh tools/generate-ai-configs.ps1` to regenerate `.claude/rules/` and `.cursor/rules/` — do **not** hand-edit those two folders directly.
2. **Skill reference** → `.agents/skills/batch-scripting/references/`, then update the pointer table in `.agents/skills/batch-scripting/SKILL.md`.
3. **Example** → a complete, runnable `.bat` script in `examples/`.

### How to contribute

```bash
# Fork and clone, create a descriptive branch
git checkout -b feat/add-something

# Commit and Pull Request
git commit -m "feat: add something"
git push origin feat/add-something
```

---

## 🗣️ AI Commands You Can Use

Open **this kit itself** as the working folder in any supported AI CLI (Claude Code, Codex, Gemini/Antigravity, Cursor) — the commands below run locally, driven by the bundled `rad-prompt-studio` skill and this kit's own `AGENTS.md`:

| You say | What happens |
|---|---|
| `Sistemi analiz et` / `Analyze the system` | Analyzes this kit's own system layer (`.agents/skills/`, `.agents/rules/`, `.agents/commands/`, `AGENTS.md`, `.claude/CLAUDE.md`) — `examples/`, `docs/`, `src/`, `tools/` stay out unless you ask. The report lands in this kit's own `analysis/result/{ai}_v{n}.md` — a local working artifact, gitignored by design; the permanent record of applied fixes is git history + issues + CHANGELOG. |
| `Değerlendir` / `Evaluate the findings` | Grades the existing reports in `analysis/result/` against current content (`STILL_VALID`/`STALE`/`REFUTED`...), presents a correction list, and waits for your approval. |
| `Düzelt: <hedef>` / `Fix <target>` | Approval-gated edit: analysis → evaluation of priors → your explicit approval → the edit. If the edited file is a bundled shared skill (`rad-*`) or a `Prompts/system/` master and this kit sits inside its parent AI-Spec-Kits-Maker workspace, the same fix is applied to the parent's master copy too — both sides stay current. |
| `<konu> için skill var mı?` / `Is there a skill for <topic>?` | The bundled `rad-skill-finder` searches local → `npx skills` ecosystem → directories → MCP/plugin registries → web with visible evidence (≥3 query phrasings); finds go through quarantine + a security scan, then a single install approval. |

---

<div align="center">

Made with ❤️ for Windows automation and scripting.

*[🇹🇷 Türkçe](README.tr-TR.md) · [Contributing](CONTRIBUTING.md) · [Code of Conduct](CODE_OF_CONDUCT.md) · [Security](SECURITY.md) · [Acknowledgments](ACKNOWLEDGMENTS.md) · [License](LICENSE)*

*If this kit helped you, leave a ⭐ in the repository!*

</div>
