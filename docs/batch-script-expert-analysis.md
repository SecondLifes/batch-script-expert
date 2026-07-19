# Five-Lens Self-Audit — batch-script-expert

> Performed by `rad-template-builder` step 11, combining the Prompt Engineer &
> Analyst, Repo Auditor, DevOps/Config Engineer, Systems Forensics Analyst,
> and Context Engineer lenses. Nine rounds: an initial static review, a
> second round driven by the user's own read-through plus actual execution
> of every example script against real `cmd.exe`, a third round adding two
> new bundled skills and a per-kit Identity section, a fourth round
> triggered by a live cross-session test that exposed a real skill-
> triggering gap, a fifth round (a second live re-test, in a genuinely
> fresh session, confirming the fourth round's fix hadn't actually reached
> the file the tool reads) that found the real root cause, a sixth round
> (a third live re-test) that found the skill-check fix working correctly
> and surfaced two remaining gaps, a seventh round prompted by the user
> asking why this loop needed a human in it at all, an eighth round that
> strengthened the five lenses themselves via parallel research and proved
> the improvement live against this kit's own generator script, and a
> ninth round (a fourth live re-test) that found the Proactive Quality
> Suggestions rule still wasn't firing — the last surviving gap.

## Round 9 — Fourth Live Re-Test: Why "Mention a Suggestion" Kept Getting Skipped

The user re-tested a fourth time. Everything from Round 6-8 held: `rad-skill-finder`
correctly reported no matching skill, the script worked correctly. The one
remaining gap repeated exactly: no proactive suggestion, and no explicit
"nothing to suggest" either — the same absence as Round 6, despite the
Round 6 fix having genuinely landed in all four primary files (confirmed
by grep before this round started).

**Root cause, this time structural rather than a missing-file bug:** Skill
Check is a *start-of-task* gate — the model naturally pauses before writing
non-trivial code, and the rule intercepts that pause. Proactive Quality
Suggestions was an *end-of-task* reflection — there's no equivalent natural
pause after generation finishes; the model simply stops. Worse, the
original wording ("if there's an obvious improvement, mention it") made
silence a valid outcome in both the "checked, found nothing" case and the
"never checked" case — nothing distinguished them, so there was no
observable pressure to actually run the check.

**Fix:** reworded as a mandatory dual-branch closing step: the response
must end with either a stated suggestion *or* an explicit "checked, nothing
to suggest" line — removing the silent-and-compliant third option. Applied
to all four primary files, `blank-scaffold` first then this kit, matching
Round 5's discipline.

**Not yet re-tested live** — same Honesty caveat as every prior round; a
wording fix is a hypothesis about *why* the model skips a step, not a
guarantee it will stop. If a fifth live test still shows silent endings,
the next escalation is making the check a required part of some other
already-reliable mechanism (e.g. tying it to Skill Check's own completion)
rather than trusting a standalone end-of-task rule at all.

## Round 8 — Strengthening the Five Lenses via Research, Then Proving It

The user asked for the underlying `rad-prompt-studio` lenses (not this
kit specifically) to be improved using external research, and for the
result to be tested. Five parallel research agents each read up to ~14-20
existing AI-agent skills/guides for one lens's domain (prompt engineering,
context engineering, DevOps/config-sync, code-review/verification,
incident forensics), then proposed sourced, concrete additions. All five
reference files (`prompt-engineer-analyst.md`, `context-engineer.md`,
`devops-config-engineer.md`, `repo-auditor.md`,
`systems-forensics-analyst.md` — v1 → v2) and the portable condensed copy
(`five-lenses.md`, both `blank-scaffold` and this kit) were updated with
the sourced additions: a context-degradation taxonomy, a STALE verdict
category and cross-claim pass, a risk-tiered delete-preview pattern and
atomic-write ordering, a reflog/dangling-commit recoverability layer and
hypothesis-revision limit, and several more (see the workspace's
`rad-prompt-studio` skill for the full list).

**Proof, not just claim:** the improved DevOps/Config Engineer lens was
then used live to re-audit this kit's own `tools/generate-ai-configs.ps1`
— a script already audited once before (Lens 3, Round 1 of this document).
The strengthened checks caught two real, previously-unflagged Important
findings:

1. **No preview/anomaly-threshold guard before stale-file deletion** — if
   `$AgentsRules` ever resolved to an empty/wrong path, every existing
   target file would be silently deleted as "no matching source," with no
   warning.
2. **Delete ran before copy**, not after — an interrupted run between the
   two steps left the target with files removed but not yet replaced,
   worse than the alternative order. The script's own newer skill-command
   generator block already did copy-then-delete correctly; the older
   `Sync-GeneratedDirectory` function didn't — an internal inconsistency.

Both were fixed in `tools/generate-ai-configs.ps1` (source-first:
`blank-scaffold`, then this kit) — reordered to copy-then-delete, and a
guard added that throws instead of deleting when the source yields zero
files while the target already has content. **Both fixes were verified by
actually running the function** in isolation (not just read): a legitimate
stale-file deletion still works correctly, and an empty-source scenario
now throws and leaves the target untouched instead of silently wiping it.
This is the same execution-verification discipline the kit's own
`batch-conventions.md` demands of batch scripts, applied here to the
generator script that builds every future template.

## Round 7 — Closing the Loop: Self-Verify and Contribute Back

The user asked, in effect: why does capturing a verified pattern into
`common-utilities.md` require this session to do it by hand each time —
shouldn't a capable AI just do this itself? The honest answer: the
individual bugs (CRLF, ANSI-escape capture, `timeout` under redirected
stdin, `tokens=2` grabbing the wrong segment) aren't reasoning failures —
they're empirical facts about `cmd.exe`/`git.exe` runtime behavior that
only surface by execution, regardless of model capability. What *was*
missing is a standing rule telling any session to close that loop itself
instead of shipping a one-off, unverified deliverable.

**Fix:** extended the `Skill Check (Mandatory)` section in all four
primary files, plus `rad-skill-finder` itself (workspace, portable, and
this kit's copy), with an explicit continuation: if no skill matches and
the capability gets written from scratch, verify it by actual execution
before calling it done, and if verification required debugging something
non-obvious, capture the corrected pattern into the project's own
rules/reference docs rather than letting it live only in that one
deliverable. Root-cause-first, same as every prior round.

## Round 6 — Third Live Re-Test: Partial Success, Two Remaining Gaps

The user re-tested a third time. Results, per the user's own report:

**Working correctly:** `rad-skill-finder` was invoked and correctly
reported no matching skill exists (a generic "clone or update any repo"
skill isn't a sensible thing to expect in a marketplace — the user agreed
this was the right outcome, not a failure). The color-coded status output
convention from Round 4's `batch-conventions.md` addition was applied
without being explicitly asked for.

**Still broken:**
1. **No proactive quality suggestion offered.** Root cause: the
   "surface proactive suggestions" instruction only existed in
   `rad-template-builder`'s Step 9 — a *template-building-time* workflow
   step, never triggered during *normal use* of the finished kit. Fixed by
   adding a `## Proactive Quality Suggestions` section as literal content
   to all four primary files (source-first: `blank-scaffold`, then this
   kit) — the same "must be physically present, not just referenced"
   discipline from Round 5.
2. **The branch handling was inconsistent/regressed** between test runs
   (dropped entirely in the latest one) — because no skill exists for this
   task, the AI reinvents the implementation from scratch each time with
   no stable reference to converge on. Fixed by adding a fully
   **verified-by-execution** "git.exe — Clone-If-Missing / Sync-If-Present"
   pattern to `common-utilities.md`. Testing it for real (cloning
   `octocat/Hello-World`, deleting a tracked file, re-syncing) caught two
   more real bugs before they could ship: a literal-parenthesis syntax
   error in a one-line `if/else`, and a `for /f "tokens=2 delims=/"`
   token-count mistake that resolved the wrong path segment as the branch
   name (fixed via prefix string-replacement instead of tokenizing).

**Not yet re-tested live** — same Honesty caveat as prior rounds.

## Round 5 — Second Live Re-Test: the Fix Was in the Wrong File

Round 4's fix (stronger `rad-skill-finder` trigger language) was applied,
and the user re-tested in a **confirmed genuinely new** Claude Code
session — ruling out stale session context. Result: identical script,
identical bugs, saved into `examples/` again, `rad-skill-finder` still
never invoked.

**Root cause, found by checking what Claude Code actually reads:**
`.claude/CLAUDE.md` — not `AGENTS.md` — is Claude Code's primary
instruction file (per `.agents/rules/sync-workflow.md`'s own per-tool
table). The `src/` Working Directory rule added in Round 4 was written
into `AGENTS.md` only. `.claude/CLAUDE.md` never mentioned `src/` at all —
so a Claude Code session had no way to know it existed, regardless of what
was on disk. The same applied to `.gemini/rules/project-rules.md`: also
missing.

This is exactly the class of bug the Round 3 Identity work was supposed to
have taught: **a rule that lives in `AGENTS.md` alone and merely gets
pointed at from the other three primary files is invisible to those
tools' sessions** — each tool reads only its own file. Round 3 correctly
replicated the Identity paragraph across all four files. Round 4 did not
apply the same discipline to the `src/` rule, or to the (previously
skill-internal-only) "check `rad-skill-finder` before writing" rule.

**Fix:** added explicit `## Skill Check (Mandatory)` and `## Working
Directory` sections — literal content, not `[FILL IN]` placeholders — to
**all four** primary files (`AGENTS.md`, `.claude/CLAUDE.md`,
`.gemini/rules/project-rules.md`, `.github/copilot-instructions.md`), at
both the source (`blank-scaffold/`) and this kit. `rad-template-builder`'s
Step 6 was updated to state this as a hard rule for any future rule that
every tool needs to obey, not just Identity.

**Still not re-tested live** — same Honesty caveat as Round 4: this is
believed correct because it addresses the actual confirmed root cause
(the file gap), but the only real confirmation is a third live test.

## Round 4 — Live Cross-Session Test: rad-skill-finder Never Triggered

The user opened a **separate** Claude Code session in this kit and asked
for a script that clones a GitHub repo if missing / pulls updates if
present — the exact scenario `rad-skill-finder`'s own docs used as an
example. `rad-skill-finder` was never invoked; the script got written from
general knowledge and saved into `examples/` (a curated-reference folder,
not an output location — see the `src/` addition below).

**Root cause:** `rad-skill-finder`'s trigger language was reactive ("use
when unsure whether a skill covers this"). A model confident in its own
git knowledge never hits "unsure," so the skill never got a chance to run.

**Fix:** rewrote the "When to Use" section (workspace copy, portable
`blank-scaffold` copy, and this kit's copy — all three, source-first) to
be assertive: check *before* writing any non-trivial capability from
scratch, explicitly naming confidence as insufficient reason to skip the
check. Added a "Known good picks" section (`anthropics/frontend-design`
for web/HTML/CSS/JS/Bootstrap/visual-design work, per the user's own
pointer) that skips straight to a verified answer for common gaps.

**Not yet re-tested live** — the trigger-language fix is a prediction, not
a confirmed-working result, per this skill's own Honesty section. The next
cross-session test should re-run the same GitHub-script request and
confirm `rad-skill-finder` actually fires this time.

**Supporting evidence for why the check matters:** the user actually ran
the naively-written script (`https://github.com/abdullah-erturk/RDS-Gen`,
branch `master`) and found three real correctness bugs a dedicated,
tested skill likely wouldn't have: (1) no default branch when one isn't
given, (2) the destination folder was named after the branch (`master`)
instead of the repo (`RDS-Gen`), (3) "update" used merge semantics that
didn't restore files the user had deleted locally — a repo-mirror script
should force-sync to match remote exactly (`git fetch` + `git reset --hard`
+ `git clean -fd`), not merge. These bugs live only in that other session's
throwaway script, not in this kit — recorded here as the concrete case for
"general knowledge missed details a real skill would have gotten right,"
not as a fix applied to this repo.

**Fourth search source added:** `rad-skill-finder`'s parallel directory
search (step 3) gained `openskills.cc/skills` (1,873 skills, linked to the
`anthropics/skills` GitHub org) as a fourth source alongside
`claudeskills.info`, `claudemarketplaces.com`, and `awesomeclaude.ai` — all
three copies (workspace, portable, this kit), source-first.

### Related additions from the same round

- **`src/`** — added as the default working/output root (`blank-scaffold`
  and this kit), since the test above also revealed there was no defined
  place for AI-generated deliverables to land; the script ended up in
  `examples/` for lack of a better option. `AGENTS.md` gained a "Working
  Directory" section; `examples/` stays reference-only.
- **`rad-template-builder` Step 9** strengthened to surface proactive
  quality/UX suggestions (not just gaps), per the user's own pointer.
- **Verified-by-execution finding:** the classic ANSI-escape color capture
  trick (`for /f %%A in ('echo prompt $E^| cmd')`) is broken in this
  environment — the captured line comes back empty, so colors silently
  fail to render. Delegating colored output to
  `powershell -Command "Write-Host ... -ForegroundColor X"` is the
  verified-working replacement, added to `batch-conventions.md`.
- **Verified-by-execution finding:** `timeout` fails with "Input
  redirection is not supported" whenever stdin isn't a real interactive
  console (true for CI, automation, or an AI agent testing the script) —
  `/nobreak` does not fix this. `ping -n <N+1> 127.0.0.1 >nul` is the
  verified-working delay alternative, also added to `batch-conventions.md`.
  Both findings came from actually running test scripts, not from reading
  — the same discipline that caught the CRLF bug in Round 2.

## Round 3 — Additional Bundled Skills + Identity Section

Following the user's own review, two more workspace skills were bundled
here (matching the `rad-skill-finder` pattern already established): `.agents/skills/rad-python/`
(copied as-is — never had workspace-specific content) and
`.agents/skills/rad-prompt-studio/` (portable variant — condenses the
five role-prompts (now living at the workspace's own
`.claude/skills/rad-prompt-studio/references/*.md`, their own former
top-level `prompts/` folder was merged into that skill after this round)
into a self-contained `references/five-lenses.md`, no
external path dependency).

A new `## Identity` section was added to `AGENTS.md`, `.claude/CLAUDE.md`,
`.gemini/rules/project-rules.md`, and `.github/copilot-instructions.md` —
authored once via `rad-prompt-studio`'s Prompt Engineer & Analyst lens,
then reworded (not re-derived) into each file's format. This is a genuine
role/identity statement, distinct from the stack-facts table that follows
it in each file. `tools/generate-ai-configs.ps1` re-run after the skill
additions; `docs/proje-haritasi.md` coverage check reported OK.

The same two additions (plus the Identity-section pattern) were made at the
source — `blank-scaffold/` and `rad-template-builder/SKILL.md`'s Step 5/6 —
so every future template gets all three bundled skills and the Identity
section by default, not just this one.

## Scope

- **Language/stack:** Windows Batch (`.bat`/`.cmd`) only — no database, no
  framework, deliberately independent of the other planned templates.
- **AI tools:** all six (Claude Code, Cursor, Codex CLI, GitHub Copilot,
  Gemini/Antigravity, Kiro).
- **Testing approach:** manual verification checklist (no automated framework
  exists for batch).
- **Skill sharing:** none — this template does not borrow from or lend to
  `database-expert` or any sibling template.

## Findings and Fixes Applied During This Audit

Two real content bugs were found and fixed — both were leftover residue from
this kit's Delphi-derived origin that survived the earlier blanking pass on
`E:\system\dev\Delphi\libs`, and were carried into `blank-scaffold/` when it
was copied from there. Both were fixed **at the source** (`blank-scaffold/`)
as well as in this instance, so no future template inherits them.

| # | File(s) | Issue | Fix |
|---|---|---|---|
| 1 | `LICENSE` (this kit + `blank-scaffold/LICENSE`) | Copyright line read `Copyright (c) 2026 Delphi Clean Code` — a leftover project name from the kit's Delphi origin, factually wrong for a generic/batch kit. | Replaced with `[Your Name / Organization]` placeholder in both locations. |
| 2 | `.claude/settings.json` (this kit + `blank-scaffold/.claude/settings.json`) | `allowCommands` included `"boss *"` (Delphi's package manager) and `"msbuild *"` — neither is relevant to batch scripting or to a language-agnostic blank scaffold. | Removed both; this kit's version now also allow-lists `cmd /c *.bat` / `cmd /c *.cmd` for running scripts directly. |

No other Delphi-specific residue was found (a broader case-insensitive scan
for "Delphi", "boss \*", "msbuild", "RAD Studio", "Object Pascal" turned up
only false positives from the string `PascalCase`, which is the legitimate,
correct naming convention for batch subroutine labels).

## Round 2 — User Review + Real Execution

The user read through the finished kit and flagged several items; a
follow-up pass (grep, content review, and — critically — actually running
every example script against `cmd.exe`) turned up one more real correctness
bug that no amount of reading would have caught.

| # | File(s) | Issue | Fix |
|---|---|---|---|
| 3 | `.agents/rules/batch-conventions.md`, `AGENTS.md`, `README.md` (×2), `.kiro/steering/structure.md` | The Modularity worked example called `robocopy %1 %2 /E` and `call :ValidateInput %1` — **unquoted**, directly contradicting this same kit's own "always quote paths" rule stated a few paragraphs earlier in the same file. | Changed to `robocopy "%~1" "%~2" /E` and `call :ValidateInput "%~1"` everywhere it appeared; regenerated `.claude/rules`/`.cursor/rules` and verified sync. |
| 4 | `AGENTS.md`, `.kiro/steering/tech.md`, `.agents/skills/batch-scripting/SKILL.md`, `references/verification-checklist.md` | Wording for "no test framework" named `pytest`/`DUnitX` as comparison points — `DUnitX` is literally the previous Delphi kit's test tool, so even as a negative comparison it read as uncleaned residue. | Reworded to "no automated test framework exists" without naming unrelated stacks' tools. |
| 5 | `examples/backup-logs.bat` | **The example had never actually been executed before this round.** It was saved with LF-only (Unix) line endings. Read top-to-bottom it looked completely correct — but running it via real `cmd.exe` failed with exit code 1 and garbled "X is not recognized" errors, because `cmd.exe`'s parser can misparse multi-line `if (...)` blocks when the file lacks CRLF endings. | Converted to CRLF; re-ran, exit code 0, correct output. Added a new mandatory "CRLF, Not LF" rule to `.agents/rules/batch-conventions.md`, `.agents/skills/batch-scripting/SKILL.md`'s Golden Rules, and the verification checklist's Pre-Flight section — this is now a first-class rule, not an implicit assumption. |
| 6 | `LICENSE` (this kit + `blank-scaffold/LICENSE`) | The `[Your Name / Organization]` placeholder from Round 1 had no mechanism behind it — every future template would need the same manual fix. | Root-caused: created a shared `template-vars.json` at the workspace root (author/org/license fields for all future templates) and token-ized `LICENSE` as `Copyright (c) {{YEAR}} {{COPYRIGHT_HOLDER}}` in both this kit and `blank-scaffold/`. The user supplied real values; both `LICENSE` files now have final content. |

### Additions (not bug fixes, new standing capability)

- **`README_tr-TR.md`** — full Turkish translation of `README.md`, added as
  a permanent `blank-scaffold/` standard (every future template gets the
  bilingual pair from Step 12 onward), not just a one-off for this kit.
- **`.agents/skills/rad-skill-finder/`** — a portable variant of the
  workspace's own `rad-skill-finder` skill (absolute workspace-path
  references replaced with "this project's own `.agents/skills/`",
  since a distributed template has no access to the workspace that built
  it) is now bundled into every template via `blank-scaffold/`. It's a
  static snapshot — `rad-template-builder` Step 11 now checks it against
  the workspace source for staleness on every future audit.
- **`examples/`** grew from 1 to 5 scripts (`backup-logs.bat`,
  `check-disk-space.bat`, `read-registry-value.bat`,
  `process-multiple-args.bat`, `ensure-scheduled-task.bat`), each covering a
  distinct pattern (robocopy+logging, PowerShell interop, registry reads,
  `shift`-based variable-argument handling, idempotent `schtasks.exe`
  setup) and **each actually executed** against real `cmd.exe` — happy
  path, a missing/invalid-argument path, and (where relevant) a
  path-with-a-space case per the kit's own verification checklist. The
  scheduled-task example's test task was created, verified idempotent on a
  second run, then deleted — no residue left on the host.

## Lens 1 — Prompt Engineer & Analyst

- `AGENTS.md`, `.claude/CLAUDE.md`, `.gemini/rules/project-rules.md`,
  `.github/copilot-instructions.md`, all four `.kiro/steering/*.md` files, and
  `.agents/skills/batch-scripting/SKILL.md` are internally consistent: they
  state the same golden rules (delayed expansion, `%ERRORLEVEL%` checks,
  `exit /b`, quoting) without contradiction, and every one correctly states
  "not applicable" for database/frameworks/SOLID/layered-architecture rather
  than fabricating content for sections that don't map onto a procedural
  scripting language.
- No instruction conflicts found between the per-tool adapters — each
  legitimately restates the same rules in that tool's expected shape rather
  than diverging in substance.
- `SKILL.md` (36 lines) and each `references/*.md` file stay well under the
  250-350 line split threshold; no file needs further splitting.

## Lens 2 — Repo Auditor

- Verified every claim in `docs/proje-haritasi.md` against the actual
  directory tree (`Glob` of the full kit) — all listed files exist, no listed
  file is missing, and the `examples/` row now correctly describes all 5
  scripts (Round 2), each confirmed executable rather than just present.
- Verified `.claude/rules/`, `.cursor/rules/` and `.claude/commands/review.md`
  are byte-identical to their `.agents/` source via `diff -rq` — confirmed
  zero differences after running `tools/generate-ai-configs.ps1`.
- No stack claims without backing content: `AGENTS.md`'s Database section
  explicitly states "not applicable" rather than silently omitting it or
  claiming unbuilt support (the exact class of error caught earlier in the
  original Delphi kit's SQL Server/SQLite claim).

## Lens 3 — DevOps/Config Engineer

- `tools/generate-ai-configs.ps1` ran clean: synced 2 rule files to both
  `.claude/rules/` and `.cursor/rules/`, synced `review.md` to
  `.claude/commands/`, and generated the `batch-scripting.md` skill-command
  wrapper. The `docs/proje-haritasi.md` coverage check reported "OK" — every
  file under `.agents/` is mentioned by name.
- `.claude/settings.json` now allow-lists only what this kit actually needs
  (the generator script, running `.bat`/`.cmd` files directly) — see Finding
  #2 above for what was removed.
- `.gitignore` / `.cursorignore` / `docs/ai-ignore-strategy.md` correctly
  state "no build artifacts" (batch has no compile step) rather than leaving
  a stale placeholder or an irrelevant compiled-language pattern.

## Lens 4 — Systems Forensics Analyst

- Traced the two findings above to their root cause: they were never
  batch-specific content — they were pre-existing Delphi-origin strings that
  the earlier blanking pass on `E:\system\dev\Delphi\libs` missed because
  they lived in files that weren't flagged as "hybrid" at the time (`LICENSE`
  and `.claude/settings.json` don't contain the obvious `[FILL IN]` markers
  that drove most of that pass, so a content-based scan is what caught them
  here instead).
- No other unstructured/inconsistent content found — variable casing,
  subroutine-label casing, and file-naming conventions are applied
  consistently across every rule/skill/adapter file that states them.

## Lens 5 — Context Engineer

- Skill discovery: `.agents/skills/batch-scripting/SKILL.md` frontmatter
  (`name`, `description`) is specific enough to trigger on batch-related
  requests without over-matching unrelated ones.
- Progressive disclosure: golden rules live in `SKILL.md`; deep reference
  material (utility syntax, verification checklist) is correctly pushed to
  `references/`, keeping the entry point short.
- No trust/injection-relevant surface in this kit — it contains no code that
  executes untrusted external input, and the "AI Context Policy" sections in
  `AGENTS.md` and `.github/copilot-instructions.md` correctly scope which
  rule-set a given tool should load (no double-loading of mirrored rule
  content across tools).

## Verdict

**Production-ready** for its stated scope (Windows Batch scripting, all six
AI tools, manual verification, no database/skill-sharing), **with one open
item**: `template-vars.json`'s `copyright_holder` field needs a real value
from the user before `LICENSE`'s `{{COPYRIGHT_HOLDER}}`/`{{YEAR}}` tokens can
be substituted with actual text — everything else found across both rounds
was fixed at both the instance and the shared `blank-scaffold/`/
`rad-template-builder/SKILL.md` source, so no future template inherits it.
The Round 2 CRLF finding is the strongest validation yet of this kit's own
core thesis: the bug was invisible on read and immediate on execution,
exactly the failure mode the verification-checklist skill exists to catch.
