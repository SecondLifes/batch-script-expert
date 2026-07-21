# Edit Base Prompt

The standard prompt for applying an **approved** change to any `.md` file
or skill folder — a prompt, a rule, a `SKILL.md`, a whole
`references/*.md` set. This is the last step of Edit Mode (see
`SKILL.md`), reached only after `analysis-base-prompt.md` (and, when prior
analyses existed, `evaluation-base-prompt.md`) have already run and the
user has explicitly approved a specific change list. This file governs
*how* the edit itself is carried out and reported — it does not re-run
analysis or evaluation, and it never originates its own findings.

Load this after the five-lens identity (see `SKILL.md`) is already
adopted, and only once an approved change list exists.

## Golden rules

1. **No edit without a prior approved change list.** If you find yourself
   about to modify a file without a change list the user explicitly signed
   off on (from Edit Mode's approval step), stop — that's a process
   violation, not a shortcut. Go back and get approval first.
2. **Scope discipline.** Apply exactly the approved items — no
   opportunistic extra cleanup, no unrelated "while I'm in here" changes.
   If you notice something else worth fixing while editing, surface it as
   a new candidate for a *future* approval round, don't fold it in
   silently.
3. **Preserve intent, not just syntax.** An edit that technically resolves
   a finding but changes the file's meaning, tone, or scope in a way the
   finding didn't call for is a new defect, not a fix.
4. **Minimal diff.** Change only what the approved item requires. A
   one-line fix should produce a one-line diff, not a rewritten section.
5. **Verify after editing, not just before.** A `.md` file renders
   correctly and a skill folder's cross-references (paths, filenames
   mentioned in prose) still resolve — check both after the edit, not just
   assume the change was clean because it was small.
6. **Bidirectional propagation for shared system files.** Some files
   exist as deliberate copies on both sides of the kit ↔ workspace
   boundary: bundled `rad-*` skills under a kit's `.agents/skills/`, and
   the shared master prompts under `Prompts/system/`. An approved edit to
   one side must reach the other side in the same run — both sides stay
   current, always:
   - **Editing inside a kit** (the working directory is a kit that is its
     own git repo): after applying the edit, check whether the parent
     workspace exists at `../../` — the marker is a `CLAUDE.md` charter
     there plus a matching canonical copy (`../../.claude/skills/<name>/`
     or `../../Prompts/system/<file>`). If found, apply the identical
     change to the canonical copy too, and run the parent's
     `tools/sync-hardlinks.ps1` if the canonical file is hardlinked. If
     no parent exists (a standalone clone), state that explicitly in the
     edit report's Verification field — never silently skip it.
   - **Editing at the workspace root**: if the edited file is a canonical
     `rad-*` skill or a `Prompts/system/` master, propagate to
     `blank-scaffold/` and to every `spec-kits/*` kit that actually
     bundles a copy — this is exactly `rad-template-builder`'s "Bundled
     `rad-*` skill drift" maintenance (see that skill), run as part of
     the same edit, not deferred to someday.
   - Kit-side copies live in separate git repos — commit the kit-side
     change in the kit's own repo (and note that the parent's submodule
     pointer needs bumping) rather than leaving the kit dirty.

## Mandatory report header

```
# Edit — `{target_name}` v{n}
**Editor:** {ai_name} ({model}, if known) · **Run:** v{n} · **Date:** {ISO date}
**Target:** `{path}`
**Approved from:** `analysis/result/{target_name}/{ai_name}_v{n}.md`
  {and, if applicable} `analysis/result/{target_name}/evaluation_{ai_name}_v{n}.md`
**Approved items:** {list the exact finding IDs/titles the user signed off on}
```

### Mandatory short Turkish summary

```
## Kısa Özet (Türkçe — bilgilendirme amaçlı, değerlendirilmez)

{2-4 cümlelik sade özet: ne değiştirildi, hangi onaylı maddeler uygulandı,
doğrulama nasıl yapıldı.}
```

## Standard edit entry format

One entry per approved item applied:

```
### [{ORIGINAL-CATEGORY-ID}] Short finding title (as approved)

- Source finding: `analysis/result/{target_name}/{ai_name}_v{n}.md#{finding-id}`
  {or the evaluation file, if the item came from there}
- Change applied: precise description of what was edited — file, section,
  before → after in one line, or a short diff excerpt
- Verification: how it was confirmed the file/folder is still valid after
  the change (re-opened and read; cross-references checked; rendered/
  syntax-checked) — never "should be fine," state what was actually done
- Deviation from approval: NONE | {if the actual edit differs from what was
  approved in any way, state exactly how and why — this must never happen
  silently}
```

## Process

1. **Confirm the approval list is current.** If time has passed or the
   target changed since approval, re-verify the finding still applies
   before editing — don't apply a stale approval to a file that has since
   moved on.
2. **Apply items one at a time**, in the order listed, writing the Edit
   report entry for each immediately after applying it — not batched at
   the end from memory.
3. **Re-open the edited file/folder** after all approved items are applied
   and confirm: the change is present, nothing outside the approved scope
   changed, and any cross-references (other files' mentions of this
   target's paths, filenames, or section headers) still resolve.
4. **Flag any approved item that could not be applied as approved** —
   because the file changed underneath, the approval was ambiguous, or
   applying it as literally stated would break something the finding
   didn't anticipate. Don't silently apply a different version of it;
   stop and ask.

## Output

Write the edit report to
`analysis/result/{target_name}/edit_{ai_name}_v{n}.md` — see
`.agents/rules/analysis-output.md` for the full naming convention this
extends. The actual file/folder edit itself lands at its real path in the
workspace, per normal editing — this report is the audit trail of what
changed and why, not a copy of the changed content.
