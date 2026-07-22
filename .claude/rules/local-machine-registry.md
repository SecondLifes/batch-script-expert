# Local Machine Registry (`.rad/settings.json`) — Rules

A per-machine, per-user registry of installed tooling and local library
source locations — lives **outside every repo**, at
`%USERPROFILE%\.rad\settings.json` (Windows) / `$HOME/.rad/settings.json`
(Linux/macOS). It is never part of any kit's git history, never
published, never shared between machines — it exists so an AI working on
*this specific machine* can ground itself in what is actually installed
here instead of guessing or reaching for the web first.

## Schema

```json
{
  "delphi": {
    "installs": ["37", "14"],
    "sources": {
      "global": ["c:\\01\\git\\opensource", "c:\\01\\FastReport"],
      "TMS": "c:\\01\\TMS",
      "devexpress": "c:\\01\\DevExpress"
    }
  }
}
```

- **Top-level keys** — one per stack/kit identity (`delphi` today;
  `dotnet`, `python`, etc. could join later as other kits need this).
  A kit only reads its own key; a missing key means "nothing registered
  for this stack on this machine" — not an error, just skip this step.
- **`installs`** — an **opaque list**, informational only. Do not
  attempt to interpret these values as specific product versions unless
  the user has explicitly told you what they mean in that conversation —
  guessing a wrong version mapping is worse than not using the field at
  all. Treat it as "these are the installs registered here" and nothing
  more until told otherwise.
- **`sources`** — local directories that actually contain installed
  library/framework source code. `"global"` is a list of general-purpose
  source roots (open-source checkouts, misc vendor SDKs); any other key
  is a named vendor/product with its own dedicated path (a single string
  or a list).

## How to use it

Before treating a third-party library/component topic as "nothing local,
go external," check whether this machine has a relevant entry:

1. Read `%USERPROFILE%\.rad\settings.json` (or the platform equivalent).
   If the file doesn't exist or the current kit's stack key is absent,
   skip this step entirely — it's optional infrastructure, not a
   requirement.
2. If a relevant vendor key or `"global"` path matches the topic, search
   those directories for the actual unit/class/topic (e.g. `grep`/`find`
   for the type name across the registered paths).
3. **Read the real, installed source directly** when found — this is
   ground truth for the exact version installed on this machine, more
   reliable than a web search or a generic doc page written for a
   different version. Cite the actual file path read, same as any other
   evidence-based finding.
4. If nothing matches in the registered sources, fall back to the normal
   discovery order (`rad-skill-finder`'s search ladder, then
   `rad-web-scraping`) — this registry is a fast, high-trust first look,
   not a replacement for the rest of the discovery discipline.

This is the natural companion to `rad-skill-finder`'s "If nothing found
anywhere" fallback: for a compiled-library ecosystem like Delphi's, the
single best source of truth is often already sitting on disk, registered
here, rather than out on the web.

## What this is not

- Not a substitute for compiling/running verification — reading source
  confirms the API surface exists and its exact signature; it does not
  replace actually exercising the code.
- Not committed, not synced, not part of any kit's distribution — every
  machine maintains its own copy independently.
- Not a place for secrets/credentials — it holds paths and opaque
  version markers only.
