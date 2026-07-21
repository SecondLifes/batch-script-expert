# AI Görsel Prompt'ları — README Banner'ları

Bu kit'in `README.md` / `README.tr-TR.md`'si için üç banner görseli.
Herhangi bir yetenekli görsel modeliyle (Nano Banana Pro, Midjourney v7,
Flux, GPT-Image vb.) **geniş 16:9 banner oranında** üret, PNG olarak
`docs/images/` altına kaydet (`overview.png`, `core-features.png`,
`design-philosophy.png` — aşırı büyük çıktıyı önce
`tools/resize-images.bat` ile küçült). `README.md`/`README.tr-TR.md`'deki
görsel etiketleri zaten açık; dosyalar yerine iner inmez resimler görünür.

Bu dosya **kendi başına yeterlidir** — artık paylaşılan bir temel prompt
yok. Her spec-kit tamamen kendine ait bir görsel dünyaya sahiptir; bu kit
başka bir kitin paletini, merkez nesnesini veya metaforunu asla yeniden
kullanmaz.

> **Not:** Prompt metinlerinin kendisi bilinçli olarak İngilizce
> bırakıldı — görsel üretim modelleri İngilizce'de daha tutarlı sonuç
> veriyor.

## Sanat yönetimi — "Gece Vardiyası"

Batch script'ler bilişimin gece vardiyası işçileridir: sabahın 3'ünde,
kimsenin izlemediği odalarda, gözetimsiz çalışırlar — ve bu kitin bütün
felsefesi *"gerçekten çalıştırılmamış script'e asla güvenme"*dir.
Görsel dil: **karanlıkta kusursuz iş çıkaran retro bir terminal
dünyası**, sinematik minyatür diorama olarak.

- **Dünya:** vintage bilişim — CRT terminaller, delikli kartlar, bakalit
  kontrol panelleri, gece server rack'leri. İnsan yok, robot yok, maskot
  yok: karakter, makinelerin kendisi.
- **Palet:** koyu kömür karanlığına karşı fosfor amber ve sıcak CRT
  yeşili parıltılar, ince soğuk ay-mavisi vurgular.
- **Stil:** sinematik retro-teknoloji illüstrasyonu, minyatür-diorama
  hissi, hacimsel ışıma, yüksek prodüksiyon kalitesi.
- **Tutarlılık:** üç görsel de aynı dünyayı ve paleti paylaşır; her biri
  farklı çekim tipi ve kamera açısı kullanır.

## Negatif Prompt (her üretime aynen yapıştır)

```
text, letters, readable words, logos, watermark, low quality, blurry,
humans, faces, robots, mascots, cartoon characters, modern flat design,
bright daylight, sci-fi neon city, different art style between images
```

## Görsel 1 — Overview (`docs/images/overview.png`)

**Yeri:** README'nin en üstü, başlık/rozetlerin altı.
**Çekim:** geniş tanıtım planı, hafif yüksek açı.

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

## Görsel 2 — Core Features (`docs/images/core-features.png`)

**Yeri:** "Temel İlkeler" bölümünün başı.
**Çekim:** tepeden makro flat-lay, kamera tam üstte.

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

## Görsel 3 — Design & Philosophy (`docs/images/design-philosophy.png`)

**Yeri:** "Tasarım & Felsefe" bölümünün başı.
**Çekim:** dramatik alçak açılı geniş plan, fırtınalı atmosfer.

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
