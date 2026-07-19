---
name: rad-skill-finder
description: Searches for and recommends AI agent skills relevant to a task or domain — via the npx skills ecosystem (skills.sh leaderboard), this project's own .agents/skills folder, curated GitHub directories, and the public web as a last resort. Never installs anything without explicit approval. Check here BEFORE writing any non-trivial capability from scratch — git/GitHub automation, web frontend (HTML/CSS/JS/Bootstrap/visual design), CI/CD, cloud APIs, database access patterns — even when confident about how to do it from general knowledge; a specialized skill usually encodes more than general knowledge alone. Use when adding new capability to this project, or when unsure whether an existing skill already covers a task.
---

# Skill Finder

## When to use

**Check here before writing any non-trivial capability from scratch — even
one you're confident you already know how to do.** Confidence isn't the
bar; "does a maintained skill already exist for this" is. This was learned
the hard way: the first live test of this workflow asked for a GitHub
repo clone/update script, and the capability got written from general
knowledge without this skill ever being consulted — exactly the case it
exists to prevent.

Concrete triggers:
- Any task in a domain with well-known best practices beyond basic syntax
  — git/GitHub automation, web frontend (HTML/CSS/JS/Bootstrap, visual/UI
  design), CI/CD, cloud APIs, database access patterns, and similar. "I
  already know how to do this" is not a reason to skip the check.
- User asks "is there a skill for this?" or describes a capability without
  knowing whether it already exists as a skill.
- Adding new capability to this project, before rewriting the same
  content from scratch.

Not every trivial action needs a full search (reading a file, running an
existing command) — the bar is "non-trivial capability," not "every single
action." See Known Good Picks below for common gaps that skip straight to
a verified answer without running the full search order.

## Input

A topic/domain name (e.g. "PostgreSQL", "React hooks", "GitHub Actions
CI"). If ambiguous, clarify exactly what's being searched for with the
user first — searching the wrong topic and reporting "nothing found" is
worse than not searching at all.

## Known good picks (skip the full search when these match)

Already-verified strong matches — recommend these directly (after
approval) instead of running the full search order below:

- **Web frontend / visual UI design (HTML, CSS, JS, Bootstrap, general
  visual/UX polish)** — `anthropics/frontend-design`, official Anthropic
  skill (openskills.cc/skills/anthropics-skills-frontend-design). Install:
  `npx skills add anthropics/frontend-design`.
- **Web scraping / structured data extraction** — covered by this
  project's own `rad-web-scraping` skill (step 1, local workspace check,
  will find it before this section is ever reached); its
  `references/tool-selection.md` holds the verified crawl4AI/ScrapeGraphAI
  comparison. Not duplicated here to avoid two sources of truth drifting
  apart.

## Search order (cheapest to most expensive, local first)

1. **This project's own skills** — does anything under this project's own
   `.agents/skills/*` already cover this topic? If so, recommend it and
   **stop** — reproducing the same content is wasted effort and a
   consistency risk. State which local skill covers it.

2. **The `npx skills` ecosystem (primary external source — Vercel's
   official, verified project)** — the open agent-skills package manager
   announced by Vercel at `vercel.com/changelog`, MIT licensed, 410,000+
   total installs; supports 17 agent tools (Claude Code, Cursor, Codex,
   Copilot, Windsurf, Gemini, Cline...). Start here directly:
   - Check the `https://skills.sh/` leaderboard first — popular,
     battle-tested skills are ranked there by install count.
   - Search: `npx skills find <topic>`
   - **Quality bar (the skills ecosystem's own rule, apply verbatim):**
     prefer skills with 1K+ installs; be cautious under 100. Official
     sources (`vercel-labs`, `anthropics`, `microsoft`) are more
     trustworthy than unknown authors.
   - **If this step finds a 1K+-install or officially-sourced strong
     match, stop the search here** — don't proceed to the next steps,
     extra requests would be wasted effort.
   - **If `npx` fails outright (Node.js not installed in this
     environment)** — don't treat that as "nothing found"; skip straight
     to step 3, and say explicitly that step 2 was skipped for this
     reason so the gap is visible rather than silently absorbed.

3. **Four directory sites (parallel, only if step 2 came up weak/empty)**
   — if step 2 found nothing, or its only candidate has under 100
   installs from an unknown source, send **simultaneous (parallel)**
   requests to all four:
   - `claudeskills.info` — has an HTTP API, queryable programmatically
     (12,980+ skills, unofficial but broad)
   - `claudemarketplaces.com/skills` (23,400+ skills, unofficial)
   - `awesomeclaude.ai/awesome-claude-skills` (169 skills, tightly
     curated, updated regularly)
   - `openskills.cc/skills` (1,873 skills, category-filterable, linked to
     the `anthropics/skills` GitHub org — check here specifically for
     anything Anthropic-published, e.g. `anthropics/frontend-design`)

   Compare what comes back from the four and recommend the candidate
   with the **highest quality signal**. Caveat: these four sites define
   "score" differently (one is total skill count, one is curation
   strictness, one is a raw API list, one is category/engagement-based) —
   not a single directly-comparable number. Use each candidate's own
   concrete signal on its own site (install/star count if available,
   otherwise "featured on this site or not") and state which criterion
   you used in the report.

4. **Curated GitHub awesome-lists (if step 3 also comes up empty)**:
   `ComposioHQ/awesome-claude-skills` (1000+ skills, categorized) and
   `VoltAgent/awesome-agent-skills` (1497+ skills, deliberately excludes
   "AI-slop" content).

5. **Open web (last resort)** — if none of the above yield anything:
   - **Try `github.com/topics/<topic-slug>` first.** GitHub's own topic
     pages return star-ranked, directly comparable candidates without
     needing a search engine — e.g. `topics/web-scraping-ai`,
     `topics/web-scraping-python`. More reliable than a blind web search
     because the ranking signal (stars) is visible inline, right on the
     page. Try a couple of plausible slug variants (`<topic>`,
     `<topic>-ai`, `<topic>-python`) since topic naming isn't fully
     predictable.
   - Otherwise search with WebSearch: `"<topic> Claude Agent Skill"`,
     `"<topic> SKILL.md"`. Verify results with WebFetch — don't recommend
     based on a title alone.

### If nothing found anywhere

Say so explicitly, then write the capability yourself — but **verify it by
actually running it** before calling it done, and if verification required
debugging something non-obvious, **capture the corrected pattern into this
project's own rules/reference docs**, not just the one-off deliverable.
This closes the loop this skill exists to open: a capability with no
matching skill will keep getting rewritten, differently and sometimes
wrongly, by separate sessions unless the first one that gets it right
(through real testing) leaves a durable trace behind.

### Known blocked/unreachable sources

`mcpmarket.com` and `skills.rest` consistently return 429/403 to WebFetch
due to bot protection — don't rely on them, move to an alternative source.

### Known false positives (name-similar, unrelated to AI skills)

If a search turns up these domains, **skip them** — they're different
products: `agent37.com` (a hosting service), `skillsfinder.ai` (a human
career/education tool, Ontario), the `skilltrack-ai` GitHub repo (human
learning tracker), `Skill_Seekers` GitHub repo (doc→skill converter, not
a discovery tool), vendor-specific docs (e.g.
`docs.creem.io/.../skill-files` — only for Creem's own product, not a
general resource).

## Output

A list of candidates, each with:
- **Source** (this project's own skills / `npx skills` / GitHub directory / web URL)
- **Description** (what the skill does)
- **Quality signal** — a concrete number where possible (install count,
  star count, last-updated date); otherwise the official/community
  distinction. Don't trust star counts blindly — inflated/anomalously
  high numbers (e.g. 100k+ stars for an unknown repo) should be treated
  with suspicion, not taken as a trust signal on their own.

**No candidate is installed without user approval.** This rule has no
exception — auto-approve flags like `npx skills add ... -y` do not
substitute for our own approval step; we never pass those flags
ourselves.

## Installation (after approval)

### From the `npx skills` ecosystem

Verified syntax (from the vercel-labs/skills README):

```
npx skills add <owner/repo> --skill <skill-name>
```

Example: `npx skills add vercel-labs/skills --skill find-skills`

- **Don't use `-g` (global)** — default to a project-local install; the
  target is this project's own `.agents/skills/` folder, not the user's
  global `~/.claude/skills/`.
- **Don't use `-y` (auto-approve)** — approval was already obtained in
  our conversation; this flag skips the tool's own internal confirmation
  and is unnecessary.
- **Verify the file actually landed where expected** after install
  (don't assume — check with `ls`/`find`) — the target is this project's
  `.agents/skills/<name>/`; npx's default behavior may write somewhere
  else (e.g. the working directory root).

### From the web/GitHub

An approved candidate is added by hand into this project's
`.agents/skills/<name>/SKILL.md` path — following the progressive-
disclosure convention: a short `SKILL.md` (when to use + quick reference)
with deep content under `references/*.md`. A single-file `SKILL.md`
exceeding 250-350 lines is never accepted — even if the source came from
the web/marketplace that way, split it into this pattern when adding it.

### Integrity check

Verify that downloaded/copied content actually matches what was shown at
the source (e.g. file size/line count consistent with expectations, no
obvious malicious/unrelated content — hidden instructions, credential
requests, sending data to an external URL — actually read the content
before installing). "Trust without ever reading the content" is never
acceptable.

After installation: run `pwsh tools/generate-ai-configs.ps1` (if this
project has it — see `.agents/rules/sync-workflow.md`) and add the new
skill to this project's map-doc equivalent (e.g. `docs/proje-haritasi.md`)
— a forgotten skill is as bad as one that never existed.

## Honesty

Never claim a skill exists without actually having read its content.
Don't assume a web result is current/accurate before verifying its
content with WebFetch. Label a candidate you're not sure about as
"probably fits," not as certain. Report install/star-count statistics
directly from their source — never estimate or round.
