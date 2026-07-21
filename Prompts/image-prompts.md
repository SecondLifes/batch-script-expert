# AI Image Prompts — README Banners

Three banner images for this kit's `README.md` / `README.tr-TR.md`.
Generate with any capable image model (Nano Banana Pro, Midjourney v7,
Flux, GPT-Image, etc.) at a **wide 16:9 banner aspect ratio**, save as
PNG under `docs/images/` (`overview.png`, `core-features.png`,
`design-philosophy.png` — shrink oversized model output first with
`tools/resize-images.bat`). The `README.md`/`README.tr-TR.md` image tags
are already live; the pictures appear as soon as the files land.

This file is **self-contained** — no shared base prompt exists anymore.
Every spec-kit owns a completely distinct visual world; this kit must
never reuse another kit's palette, central object, or metaphor.

## Art direction — "The Night Shift"

Batch scripts are the night-shift workers of computing: they run at 3 AM,
unattended, in rooms nobody watches — and this kit's whole philosophy is
*"never trust a script until it's actually been run."* The imagery:
**a retro terminal world doing flawless work in the dark**, rendered as
cinematic miniature dioramas.

- **World:** vintage computing — CRT terminals, punch-cards, bakelite
  control panels, server racks at night. No people, no robots, no
  mascots: the machinery itself is the character.
- **Palette:** phosphor amber and warm CRT green glows against deep
  charcoal darkness, with thin cold moonlight-blue accents.
- **Style:** cinematic retro-tech illustration, miniature-diorama feel,
  volumetric glow, high production value.
- **Consistency:** all three images share this same world and palette;
  each uses a different shot type and camera angle.

## Negative Prompt (paste into every generation)

```
text, letters, readable words, logos, watermark, low quality, blurry,
humans, faces, robots, mascots, cartoon characters, modern flat design,
bright daylight, sci-fi neon city, different art style between images
```

## Image 1 — Overview (`docs/images/overview.png`)

**Slot:** top of the README, under the title/badges.
**Shot:** wide establishing shot, slightly elevated angle.

**Prompt:**
```
A wide cinematic establishing shot of a dark server room at 3 AM, empty
of people: in the foreground a vintage CRT terminal on a desk glows warm
phosphor amber, and out of its screen flows a luminous conveyor of small
glowing punch-cards, drifting in an orderly line through the dark aisles
of server racks, where small mechanical stamp-arms mounted on the racks
punch and sort each card as it passes — automated work happening
flawlessly with nobody watching. Thin cold moonlight-blue light falls
through a high window across the charcoal darkness; the only warm light
is the amber of the screen and the cards. Miniature-diorama feel,
volumetric glow, cinematic retro-tech illustration, wide 16:9 banner
composition, highly detailed.
```

## Image 2 — Core Features (`docs/images/core-features.png`)

**Slot:** top of the "Key Guidelines" / core-features section.
**Shot:** top-down macro flat-lay, camera directly above.

**Prompt:**
```
A top-down macro shot of a beautiful vintage bakelite-and-brass control
panel from a 1970s mainframe, filling the frame: four large illuminated
instruments in a row, each glowing phosphor amber from within — a heavy
armored toggle switch under a small protective glass cover (defensive
defaults), a round analog gauge whose needle rests exactly on a glowing
checkmark-shaped notch (checked exit codes), two thick interlocking
chain links cast in brass (robustly chained commands), and an hourglass
fused with a clockwork gear (scheduled unattended runs). Engraved
guide-lines connect the four instruments across the charcoal panel.
Warm amber glow against dark bakelite, thin moonlight-blue reflections
on the brass edges, cinematic retro-tech illustration, wide 16:9 banner
composition, highly detailed.
```

## Image 3 — Design & Philosophy (`docs/images/design-philosophy.png`)

**Slot:** top of the "Design & Philosophy" section.
**Shot:** dramatic low-angle wide shot, stormy atmosphere.

**Prompt:**
```
A dramatic low-angle shot of a small lighthouse standing on a dark rock,
its tower built from a stack of vintage CRT monitors, the topmost screen
housing the lamp: a rotating phosphor-amber beam sweeping across a
stormy midnight sea whose waves are made of tangled black cables and
loose glossy magnetic tape. In the beam's path, a line of small glowing
paper envelopes sails safely through the chaos, following the light
exactly. Cold moonlight-blue storm clouds above, warm amber beam below —
the single point of tested, trustworthy light in a hostile dark
environment. Cinematic retro-tech illustration, miniature-diorama feel,
wide 16:9 banner composition, highly detailed.
```
