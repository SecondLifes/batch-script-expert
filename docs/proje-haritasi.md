# Proje Haritası — Batch Script Expert Spec-Kit

> Bu dosya, kitin altındaki her dosya/klasörün **ne işe yaradığını** açıklar. Amaç: yeni birinin (insan ya da AI) kaynağı tek tek açmadan, sadece bu haritadan yönünü bulabilmesi. Bu kit, `rad-template-builder`'ın boş scaffold'unu **Windows Batch (.bat/.cmd) scripting** için doldurarak ürettiği somut bir spec-kit'tir — kapsamı bilinçli olarak sadece Batch ile sınırlı tutulmuştur (veritabanı desteği yok, `database-expert`'ten bağımsız).
>
> **Güncel kalması nasıl sağlanıyor:** `.agents/rules/`, `.agents/commands/` veya `.agents/skills/` altına bir şey eklenip/çıkarılınca bu dosyanın kopyası da aynı turda elle güncellenmelidir (bkz. `.agents/rules/sync-workflow.md`). `tools/generate-ai-configs.ps1`, her çalıştığında `.agents/` altındaki her dosyanın burada adı geçip geçmediğini kontrol edip eksik olanları **uyarı olarak** yazdırır.

## Bu kit nedir, ne değildir

**Nedir:** Windows Batch (`.bat`/`.cmd`) script'leri yazarken/gözden geçirirken AI asistanlarına (Claude Code, Cursor, Codex CLI, GitHub Copilot, Gemini/Antigravity, Kiro) verilecek kural ve beceri (skill) seti. Değişken genişletme (`%VAR%` vs `!VAR!`), hata kontrolü (`%ERRORLEVEL%`), yol tırnaklama, modülerlik (`call :Label`) ve — test framework'ü olmadığı için — elle doğrulama disiplinini kapsar.

**Ne değildir:**
- Genel amaçlı bir "sistem yönetimi" veya "DevOps" kiti değildir — kapsam sadece `.bat`/`.cmd` script yazımıdır.
- Veritabanı desteği içermez — bilinçli bir kapsam kararı (bkz. `AGENTS.md` → Database bölümü).
- Çalıştırılabilir bir kütüphane değildir — herhangi bir gerçek projeye bağımlılığı yoktur.

## Mimari — tek cümlede

Kuralların, komutların ve becerilerin (skills) **gerçek içeriği sadece `.agents/` altında yaşar**; `.claude/`, `.cursor/` klasörlerindeki kural dosyaları oradan **otomatik üretilir** (elle düzenlenmez). Nedeni ve mekanizması: [.agents/rules/sync-workflow.md](../.agents/rules/sync-workflow.md).

---

## Kök dosyalar

| Dosya | Ne işe yarar |
|---|---|
| `AGENTS.md` | Codex CLI, Cursor, GitHub Copilot, Gemini/Antigravity ve Kiro'nun **doğrudan okuduğu** evrensel kural özeti — dil/stack (Windows Batch), naming, hata yönetimi, kaynak yönetimi, anti-pattern'ler dolu halde. |
| `README.md` | İnsan okuyucu için proje tanıtımı, kurulum (Quick Start), kit yapısının genel görünümü, örnek kod. |
| `README.tr-TR.md` | `README.md`'nin birebir Türkçe karşılığı — aynı bölüm sırası, aynı içerik, aynı "Batch Script Expert" başlığı (ayrı bir Türkçe başlık yok). Dosya adı nokta-ayraçlı (`_tr-TR` değil `.tr-TR`). |
| `LICENSE` | Apache License 2.0. Dosyanın sonundaki APPENDIX'te `Copyright 2026 Emrah BAŞPINAR - Recep Eymen BAŞPINAR` — `template-vars.json`'daki değerlerle dolduruldu, gövde metni (TERMS AND CONDITIONS) değiştirilmedi. |
| `CODE_OF_CONDUCT.md` | Contributor Covenant v1.4 — standart, dil-agnostik metin, Türkçe çevirisi kasıtlı olarak yok. |
| `CONTRIBUTING.md` / `CONTRIBUTING.tr-TR.md` | "Contributing to Batch Script Expert" — hata bildirimi, PR süreci, teknik standartlara (AGENTS.md'ye referansla) işaret. |
| `SECURITY.md` / `SECURITY.tr-TR.md` | Güvenlik açığı bildirme süreci — Supported Versions tablosu `:white_check_mark:`/`:x:` kullanır. |
| `ACKNOWLEDGMENTS.md` / `ACKNOWLEDGMENTS.tr-TR.md` | Açık kaynak/ticari bağımlılık ve referans/ilham kaynaklarının takdir edildiği sayfa. Bu kitin gerçek durumu dürüstçe yansıtılıyor: Açık Kaynak ve Ticari bölümleri gerçekten boş (batch scripting'in bağımlılığı yok, sadece Windows'a yerleşik araçlar kullanılıyor) — doldurma amaçlı uydurma girdi yok. Referanslar ve İlham Kaynakları bölümünde `robocopy`, `setlocal`, `for`, `findstr`, `reg`, `schtasks` için gerçek Microsoft Learn dokümantasyon linkleri var. README'nin rozet satırından, indeksinden ve footer'ından link verilir. |
| `.gitignore` | Git-ignore kuralları — batch'in derleme çıktısı olmadığı için build-artifact bölümü boş bırakıldı, script log/temp dosyaları ve genel (node_modules, .venv, .env vb.) desenler var. |
| `.cursorignore` | Cursor'un indekslemeyeceği yollar. |

## `.agents/` — Tek Kaynak (Single Source of Truth)

### `.agents/rules/`

| Dosya | Konu |
|---|---|
| `sync-workflow.md` | Bu çoklu-araç mimarisinin nasıl çalıştığı — önce bu okunur. |
| `batch-conventions.md` | Windows Batch konvansiyonları: CRLF zorunluluğu, header blok, naming (UPPER_SNAKE_CASE değişken, PascalCase label), `%VAR%` vs `!VAR!`, hata yönetimi, yol tırnaklama, modülerlik (`call :Label`), kullanıcıya-dönük script'lerde renkli çıktı/progress bar (PowerShell'e delege, `timeout` yerine `ping`), anti-pattern listesi. Glob: `**/*.bat`, `**/*.cmd`. |

### `.agents/commands/`

| Dosya | Ne işe yarar |
|---|---|
| `review.md` | `/review` slash-komutunun kaynağı — git diff'i batch konvansiyonlarına (naming, `%ERRORLEVEL%` kontrolü, quoting) göre incelet. |

### `.agents/skills/batch-scripting/`

| Dosya | Ne işe yarar |
|---|---|
| `SKILL.md` | Giriş noktası — ne zaman kullanılır, altın kurallar özeti, `references/` işaret tablosu. |
| `references/common-utilities.md` | `robocopy`, `findstr`, `for /f` (dosya/komut çıktısı parse), `reg.exe`, `schtasks.exe`, `git.exe` clone-if-missing/sync-if-present (üç kez gerçek testle doğrulanan desen — repo adından klasör, gerçek default branch çözümü, force-sync update), batch'ten PowerShell çağırma, `wmic` kullanımdan kaldırma notu. |
| `references/verification-checklist.md` | Elle doğrulama kontrol listesi — batch için otomatik test framework'ü olmadığından, "gerçekten çalıştırarak doğrula" disiplini: happy path, boşluklu yollar, eksik/geçersiz girdi, hata yollarının gerçekten tetiklenmesi, delayed expansion kontrolü, ortam izolasyonu, unattended-context kontrolleri. |

### `.agents/skills/rad-skill-finder/`

| Dosya | Ne işe yarar |
|---|---|
| `SKILL.md` | Workspace'in kendi `.claude/skills/rad-skill-finder/`'ının birebir kopyası — bu projenin kendi `.agents/skills/`'ını, `npx skills` ekosistemini, GitHub awesome-list'lerini ve web'i arar. "Bana bir GitHub repo otomasyon script'i yaz" gibi bir istek geldiğinde, sıfırdan yazmadan önce ilgili bir skill olup olmadığını kontrol eder. Workspace kaynağı güncellenirse bu kopyanın da tazelenmesi gerekir (statik snapshot, herhangi bir fark = bayatlamış). |

### `.agents/skills/rad-python/`

| Dosya | Ne işe yarar |
|---|---|
| `SKILL.md` + `references/{performance,testing,design-patterns}.md` | Workspace'in kendi `.claude/skills/rad-python/`'unun birebir kopyası (workspace'e özgü içerik hiç içermiyordu, taşınabilirlik düzenlemesi gerekmedi). Bu template'in stack'i batch olsa da, AI iş sırasında yardımcı bir Python script'i yazması gerektiğinde (veri işleme, tek seferlik otomasyon, doğrulama) bunu kullanır. |

### `.agents/skills/rad-prompt-studio/`

| Dosya | Ne işe yarar |
|---|---|
| `SKILL.md` + `references/{context-engineer,devops-config-engineer,prompt-engineer-analyst,repo-auditor,systems-forensics-analyst}.md` + `references/prompts/{analysis,evaluation,edit}-base-prompt.md` | Workspace'in kendi `.claude/skills/rad-prompt-studio/`'sunun birebir kopyası — beş uzmanlık merceğini (Prompt Engineer & Analyst, Repo Auditor, DevOps/Config Engineer, Systems Forensics Analyst, Context Engineer) aynı anda üstlenip yeni prompt tasarlama (Design), bu projenin kendi prompt/rule/skill/sync-mimarisini denetleme (Analysis — tek dosya, spec-kit sistem klasörü veya toplu tarama), eski analizleri güncel içeriğe karşı derecelendirme (Evaluation) ve onay-kapılı, analiz-önce düzenleme (Edit) modlarını sağlar. Her mod kendi `references/prompts/*.md` master prompt'unu kullanmak zorundadır. `AGENTS.md`'nin `## Identity` bölümü bu skill'in Prompt Engineer & Analyst merceğiyle yazıldı. Workspace kaynağı güncellenirse bu kopyanın da tazelenmesi gerekir (statik snapshot, herhangi bir fark = bayatlamış). |

### `.agents/skills/rad-web-scraping/`

| Dosya | Ne işe yarar |
|---|---|
| `SKILL.md` + `references/{tool-selection,discovery-and-extraction-patterns}.md` | Workspace'in kendi `.claude/skills/rad-web-scraping/`'inin birebir kopyası (workspace'e özgü içerik yok) — genel web scraping / yapılandırılmış veri çıkarma skill'i. Stack batch olsa da, AI'nin bir siteden veri çekecek yardımcı bir Python script'i yazması gerektiğinde (`common-utilities.md`'deki PowerShell interop desenine paralel) hangi kaynağı (API > gömülü JSON > DOM en son) ve hangi aracı (crawl4AI, ScrapeGraphAI, düz HTTP, Playwright) seçeceğine karar vermesini sağlar. Workspace kaynağı güncellenirse bu kopyanın da tazelenmesi gerekir (statik snapshot, herhangi bir fark = bayatlamış). |

---

## Araç-özel adaptörler

Bu klasörlerin çoğu **üretilmiş** (generated) içerik barındırır — kaynağı `.agents/`'tır, elle düzenlenmez.

| Klasör/Dosya | Durum | Ne işe yarar |
|---|---|---|
| `.claude/CLAUDE.md` | Elle yazılır | Claude Code'un otomatik okuduğu kök talimat — Identity, Skill Check (rad-skill-finder zorunlu kontrolü), Working Directory (`src/`), Proactive Quality Suggestions, batch stack özeti, kritik direktifler (`!VAR!`, `%ERRORLEVEL%`, `exit /b`), naming. Bu dört bölüm (Identity/Skill Check/Working Directory/Proactive Quality Suggestions) `AGENTS.md`'ye değil, doğrudan buraya yazılmalı — Claude Code `AGENTS.md`'yi okumuyor. |
| `.claude/settings.json` | Elle yazılır | İzin ayarları. |
| `.claude/rules/*.md` | ⚙️ **Üretilmiş** | `.agents/rules/`'ın birebir kopyası. |
| `.claude/commands/review.md` | ⚙️ **Üretilmiş** | `.agents/commands/review.md`'nin kopyası. |
| `.claude/commands/batch-scripting.md` | ⚙️ **Üretilmiş** | `.agents/skills/batch-scripting/` için otomatik üretilen `/batch-scripting` komut sarmalayıcısı. |
| `.cursor/rules/*.md` | ⚙️ **Üretilmiş** | `.agents/rules/`'ın Cursor formatındaki kopyası. |
| `.gemini/rules/project-rules.md` | Elle yazılır | Gemini/Antigravity için `AGENTS.md`'ye benzer, batch'e özel kısa özet — Identity/Skill Check/Working Directory dahil, kendi içinde (referans değil). |
| `.github/copilot-instructions.md` | Elle yazılır | GitHub Copilot'un workspace'e enjekte ettiği ön-prompt — Identity/Skill Check/Working Directory dahil, kendi içinde (referans değil). |
| `.kiro/steering/*.md` (4 dosya: `product.md`, `tech.md`, `structure.md`, `frameworks.md`) | Elle yazılır | Kiro AI'nin "steering" dokümanları — batch stack'inin ürün amacı, teknoloji, dosya yapısı, dış araçlar (robocopy vb.). |
| `.specify/*.md` (4 şablon) | Elle yazılır | Spec-driven geliştirme şablonları — batch script'leri genelde küçük olduğundan opsiyonel, büyük bir otomasyon projesi için kullanılabilir. |
| `.vscode/settings.json` | Elle yazılır | VS Code'un `files.exclude`/`search.exclude` ayarları. |

## `tools/`

| Dosya | Ne işe yarar |
|---|---|
| `generate-ai-configs.ps1` | `.agents/rules` ve `.agents/commands`'ı okuyup `.claude/rules`, `.cursor/rules`, `.claude/commands`'a kopyalayan PowerShell script. `.agents/rules`, `.agents/commands` altında bir dosya eklenip/silinip/değiştirildiğinde VEYA `.agents/skills` altına bir skill eklenip/kaldırıldığında çalıştırılması **zorunludur**. `rad-prompt-studio`'nun DevOps/Config Engineer merceğiyle denetlenip iki gerçek hatası (silme kopyalamadan önce çalışıyordu; kaynak yolu bozulursa hedefteki her şeyi sessizce silme riski) düzeltildi ve gerçek testle doğrulandı — bkz. `docs/batch-script-expert-analysis.md` Round 8. |

## `docs/`

| Dosya | Ne işe yarar |
|---|---|
| `proje-haritasi.md` | Bu dosya. |
| `ai-ignore-strategy.md` | Hangi dosyaların AI bağlamından hariç tutulacağı stratejisi. |
| `batch-script-expert-analysis.md` | Beş-mercekli (five-lens) öz-denetim raporu — kitin tamamlanmasından sonra üretildi. |
| `Prompts/image-prompts.md` / `.tr-TR.md` | README banner'ları için 3 AI-görsel-üretim prompt'u — kendi başına yeterli, kite özgü sanat yönetimi: **"Gece Vardiyası"** (sabah 3'te kimsesiz server odasında kusursuz çalışan retro CRT/delikli-kart dünyası; fosfor amber + kömür karanlığı + ay-mavisi; insan/robot/maskot yok — Image 3: CRT'lerden yapılmış deniz feneri = "çalıştırılmadan güvenme"). Eski paylaşılan `Prompts/system/` temel-prompt şeması emekliye ayrıldı. README'lerdeki (EN+TR) görsel etiketleri artık açık; PNG'ler üretilip `docs/images/`e inince görünürler. `tools/resize-images.bat` ve `docs/images/README.md` de bu turda kite eklendi. |

## `examples/`

Beşi de gerçek `cmd.exe` üzerinde çalıştırılarak doğrulandı (happy path +
en az bir hata yolu + gerektiğinde boşluklu yol testi) — okuyarak değil,
çalıştırarak onaylandı.

| Dosya | Ne işe yarar |
|---|---|
| `backup-logs.bat` | Header blok, `:main`/subroutine yapısı, guard clause'lar, doğru `%VAR%`/`!VAR!` kullanımı, `robocopy` ile hata kontrolü (`geq 8`), `%~dp0`/tırnaklı yollar, her çıkış yolundan çağrılan `:Cleanup`. |
| `check-disk-space.bat` | PowerShell interop — `for /f` ile bir PowerShell komutunun çıktısını batch değişkenine yakalama (bkz. `common-utilities.md`). |
| `read-registry-value.bat` | `reg.exe query` + `findstr` ile registry okuma, eksik anahtar/değeri ham `reg.exe` hatası yerine temiz bir "NOT FOUND" mesajıyla ele alma. |
| `process-multiple-args.bat` | `shift` ile değişken sayıda argüman işleme — sabit `%1`/`%2`/`%3` varsaymadan bir dosya listesini döngüyle gezme. |
| `ensure-scheduled-task.bat` | `schtasks.exe` ile idempotent kurulum — görev zaten varsa hata vermeden/tekrar oluşturmadan atlar. |

**Kritik bulgu (bu örnekleri test ederken keşfedildi):** `backup-logs.bat`
ilk yazıldığında LF (Unix) satır sonlarıyla kaydedilmişti — okunduğunda
tamamen doğru görünüyordu ama `cmd.exe` çok satırlı `if (...)` bloklarını
sessizce yanlış parse ediyordu. CRLF'e çevrilince exit code 0 ile doğru
çalıştı. Bu yüzden `.agents/rules/batch-conventions.md`'ye zorunlu bir
"CRLF, Not LF" kuralı eklendi — okuyarak asla yakalanamayacak, sadece
gerçek çalıştırmayla ortaya çıkan bir hata sınıfıydı.

## `src/`

Bu projenin **varsayılan çalışma/çıktı kökü** — kullanıcı başka bir yer
belirtmedikçe, istenen `.bat`/`.cmd` script'leri buraya yazılır. `examples/`
küratörlü referans içerikken, `src/` gerçek üretilen iş. Şu an sadece
kendi amacını açıklayan bir `README.md` içeriyor. `AGENTS.md`'nin "Working
Directory" bölümüne bakın.
