# 🚀 Batch Script Expert AI Spec-Kit

<div align="center">

**Windows Batch (`.bat`/`.cmd`) betik yazımını Yapay Zeka ile state-of-the-art seviyeye taşıyan; kurallar, *skill*'ler ve *steering*'lerden oluşan bir ekosistem.**

[![🇬🇧 English](https://img.shields.io/badge/English-blue)](README.md)
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache--2.0-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)
[![GitHub Copilot](https://img.shields.io/badge/GitHub%20Copilot-Ready-blue?logo=github)](https://github.com/features/copilot)
[![Cursor](https://img.shields.io/badge/Cursor-Rules-purple)](https://cursor.sh)
[![Claude](https://img.shields.io/badge/Claude-Code-brown?logo=anthropic)](https://claude.ai)
[![Gemini](https://img.shields.io/badge/Gemini-Skills-orange?logo=google)](https://gemini.google.com)
[![Kiro](https://img.shields.io/badge/Kiro-Steering-teal)](https://kiro.dev)
[![Qwen](https://img.shields.io/badge/Qwen-AGENTS.md-purple)](https://chat.qwen.ai)
[![Kimi](https://img.shields.io/badge/Kimi-AGENTS.md-lightgrey)](https://kimi.moonshot.cn)

*[🇬🇧 English](README.md)*

![Overview](docs/images/overview.png)

</div>

## 📋 İçindekiler

- [🇬🇧 English](README.md)
- [Bu proje nedir?](#-bu-proje-nedir)
- [Neden kullanmalı?](#-neden-kullanmali)
- [Desteklenen AI Araçları](#-desteklenen-ai-araçları)
- [Yapay Zekaya Öğretilen Ana Kurallar](#-yapay-zekaya-öğretilen-ana-kurallar)
- [Kit Yapısı](#-kit-yapisi)
- [Önkoşullar](#-önkoşullar)
- [Hızlı Başlangıç](#-hızlı-başlangıç)
- [İyi Uygulama Örnekleri](#-i̇yi-uygulama-örnekleri)
- [Tasarım ve Felsefe](#-tasarım-ve-felsefe)
- [Kullanabileceğiniz AI Komutları](#-kullanabileceğiniz-ai-komutları)

---

## 💡 Bu proje nedir?

**Batch Script Expert AI Spec-Kit**, bir kod framework'ü değil — favori yapay zekanız için bir **davranış kuralları** bütünüdür. Asistana Windows Batch (`.bat`/`.cmd`) betiklerini şu şekilde yazmayı "öğretir":

- ✅ **Temiz** — `goto`-spagettisi yerine modüler alt yordamlar (`call :Label`), kısa odaklı bloklar, guard clause'lar
- ✅ **Güvenli** — doğru `%VAR%` vs `!VAR!` genişletmesi, tırnaklı yollar, hata verebilecek her komuttan sonra kontrol edilen `%ERRORLEVEL%`, çağıranın shell'ine sızmayan ortam değişkenleri
- ✅ **Doğrulanabilir** — statik okumanın yakalayamadığı hata modlarını kapsayan manuel bir kontrol listesi (boşluklu yollar, eksik girdiler, gerçekten tetiklenen hata yolları) — batch'in resmi bir test framework'ü olmadığı için
- ✅ **Gözetimsiz-çalışmaya-hazır** — zamanlanmış veya CI'da çalışacak betiklerde bırakılmış etkileşimli prompt yok, yalnızca konsola değil dosyaya loglama

> Bu kit olmadan, yapay zeka tarafından üretilen batch betikleri döngüler içinde rutin olarak `%VAR%`/`!VAR!`'ı karıştırır (sessizce yanlış çıktı, çökme değil), yolları tırnaksız bırakır (kullanıcı adında boşluk olduğu an bozulur) ve `%ERRORLEVEL%`'i asla kontrol etmez — üçü de betik yazıldığı yerden biraz farklı bir yerde çalışana kadar görünmez olan hata sınıflarıdır.

---

## 🤔 Neden kullanmalı?

| Spec-Kit Olmadan | Spec-Kit İle |
|---|---|
| `for`/`if` bloğu içinde `%VAR%` kullanımı — sessizce bayat değer | `setlocal enabledelayedexpansion` ile `!VAR!` — doğru canlı değer |
| Tırnaksız yollar — `Program Files`/`OneDrive`'da bozulur | Her yol tırnaklı, script-göreli yollar için `%~dp0` kullanılır |
| Riskli komutlardan sonra `%ERRORLEVEL%` göz ardı edilir | Hata verebilecek her komuttan sonra kontrol edilir, `robocopy`'nin 0-7-başarı nüansına saygı gösterilir |
| Çağıranın shell'ini kapatan çıplak `exit` | Her yerde `exit /b <code>` |
| "Bir kere çalıştı, gönder" | Onaydan önce yapılandırılmış manuel doğrulama kontrol listesi |

---

## 🤖 Desteklenen AI Araçları

| Araç | Yapılandırma Dosyası | Nasıl Çalışır |
|---|---|---|
| **GitHub Copilot** | `.github/copilot-instructions.md` | Workspace/Chat'e enjekte edilen ön-prompt |
| **Cursor** | `.cursor/rules/*.md` (üretilmiş) | Bağlama göre yüklenen kurallar |
| **Claude Code** | `.claude/` (kurallar üretilmiş, skill'ler paylaşımlı) | Bağlama göre kurallar ve terminaldeki skill'ler |
| **Codex CLI** | `AGENTS.md` | Doğrudan okur, özel klasör gerekmez |
| **Google Gemini / Antigravity** | `.gemini/rules/project-rules.md` | `AGENTS.md` gibi özetlenmiş kurallar |
| **Kiro AI** | `.kiro/steering/*.md` | Stack ve mimari kısıtlar |
| **Qwen / Kimi** | `AGENTS.md` (manuel) | Otomatik keşif yok — aracı doğrudan `AGENTS.md`'ye yönlendirin; yukarıdaki araçların aksine otomatik okunmaz |
| **Herhangi bir AI** | `AGENTS.md` | Evrensel kurallar (proje kökü) |
| **Yukarıdakilerin hepsi** | `.agents/skills/*/SKILL.md` | Paylaşımlı skill'ler — Agent Skills açık standardı, her araç için tek kopya |

> Kurallar ve komutların tek kanonik kaynağı `.agents/rules/` ve
> `.agents/commands/`'dır; `.claude/rules`, `.cursor/rules` ve `.claude/commands`
> bundan `tools/generate-ai-configs.ps1` ile üretilir — bkz.
> `.agents/rules/sync-workflow.md`.

---

## 🌟 Yapay Zekaya Öğretilen Ana Kurallar

![Core Features](docs/images/core-features.png)

### Değişken Genişletme — Hataların #1 Kaynağı

```batch
:: YANLIŞ — %COUNT% döngü öncesi değerde donmuş
for %%F in (*.txt) do (
  set /a COUNT+=1
  echo %COUNT%
)

:: DOĞRU — gecikmeli genişletme canlı değeri okur
setlocal enabledelayedexpansion
for %%F in (*.txt) do (
  set /a COUNT+=1
  echo !COUNT!
)
```

### Hata Yönetimi

```batch
robocopy "%SOURCE%" "%DEST%" /E
if %ERRORLEVEL% geq 8 (
  echo ERROR: robocopy failed with code %ERRORLEVEL% 1>&2
  exit /b 1
)
```

### Modülerlik — GOTO Spagettisi Yerine Alt Yordamlar

```batch
call :ValidateInput "%~1"
if errorlevel 1 exit /b 1
call :CopyFiles "%~1" "%~2"
call :Cleanup
exit /b 0
```

Tam kurallar ve işlenmiş örnekler: `.agents/rules/batch-conventions.md`.

---

## 📂 Kit Yapısı

```
batch-script-expert/
│
├── AGENTS.md                        # 🌐 Evrensel kurallar (Codex, Copilot, Kiro, Antigravity, Gemini)
│
├── .agents/                         # 📦 TEK KAYNAK — burada düzenle, başka hiçbir yerde değil
│   ├── rules/
│   │   ├── sync-workflow.md         # Bu çok-araçlı kurulumun senkron tutulma şekli — önce bunu oku
│   │   └── batch-conventions.md     # Windows Batch kuralları — isimlendirme, genişletme, hata yönetimi, tırnaklama
│   ├── commands/
│   │   └── review.md                # Slash-komut kaynağı: /review
│   └── skills/
│       ├── batch-scripting/
│       │   ├── SKILL.md             # Giriş noktası — altın kurallar, ne zaman kullanılır
│       │   └── references/
│       │       ├── common-utilities.md        # robocopy, findstr, for /f, reg.exe, schtasks.exe, PowerShell etkileşimi
│       │       └── verification-checklist.md  # Manuel doğrulama kontrol listesi (batch için test framework'ü yok)
│       ├── rad-skill-finder/        # Paketlenmiş — sıfırdan yazmadan önce var olan skill'leri bulur
│       ├── rad-python/              # Paketlenmiş — burada çalışırken yazılan ad-hoc yardımcı betikler için
│       ├── rad-prompt-studio/       # Paketlenmiş — beş-mercek prompt tasarımı/denetimi/düzenlemesi, bu dosyanın Identity bölümünü yazmak için kullanıldı
│       └── rad-web-scraping/        # Paketlenmiş — web kazıma / yapılandırılmış veri çıkarma (araç seçimi, keşif önceliği)
│
├── tools/
│   └── generate-ai-configs.ps1      # .claude/rules, .cursor/rules, .claude/commands'i yeniden üretir
│
├── .claude/
│   ├── CLAUDE.md                    # 🧠 Claude için ana sistem prompt'u
│   ├── settings.json                # İzin ayarları
│   ├── commands/                    # ⚙️ .agents/commands'tan ÜRETİLMİŞ — elle düzenlenmez
│   └── rules/                       # ⚙️ .agents/rules'tan ÜRETİLMİŞ — elle düzenlenmez
│
├── .github/
│   └── copilot-instructions.md      # 🤖 GitHub Copilot için ön-prompt
│
├── .cursor/
│   └── rules/                       # ⚙️ .agents/rules'tan ÜRETİLMİŞ — elle düzenlenmez
│
├── .gemini/
│   └── rules/
│       └── project-rules.md         # Elle yazılmış özet, AGENTS.md ile aynı rol ama Gemini'ye özel
│
├── .kiro/
│   └── steering/
│       ├── product.md               # Ürün vizyonu
│       ├── tech.md                  # Teknoloji stack'i
│       ├── structure.md             # Betik/alt yordam organizasyonu
│       └── frameworks.md            # Harici yardımcı programlar (robocopy, reg.exe, vb.)
│
├── .specify/                        # AI-destekli spec şablonları
│   ├── constitution.md
│   ├── plan-template.md
│   ├── spec-template.md
│   └── tasks-template.md
│
├── docs/
│   ├── proje-haritasi.md            # "Her dosya ne yapar" haritası (insan-odaklı, Türkçe)
│   ├── ai-ignore-strategy.md        # AI bağlam dahil etme/hariç tutma stratejisi
│   └── batch-script-expert-analysis.md  # Bu kitin beş-mercek öz-denetimi
│
├── examples/                        # Eksiksiz örnek .bat betikleri
│
└── src/                             # 🎯 Varsayılan çalışma/çıktı kökü — betikler
    └── README.md                    # aksi söylenmedikçe istediğiniz dosyalar buraya iner
```

---

## 🔧 Önkoşullar

- **Windows + `cmd.exe`** — bu kitin bütün amacı.
- **PowerShell 7+ (`pwsh`)** — `tools/generate-ai-configs.ps1`'i çalıştırmak için gerekli.
- **Node.js / `npx`** — yalnızca paketlenmiş `rad-skill-finder` skill'inin
  birincil arama yolu (`npx skills find <topic>`) için gerekli. Kitin
  kendisini kullanmak için gerekli değil; olmadan `rad-skill-finder` web
  tabanlı arama adımlarına düşer (GitHub dizinleri, `github.com/topics/*`,
  WebSearch) — bkz. `.agents/skills/rad-skill-finder/SKILL.md`.

---

## ⚡ Hızlı Başlangıç

### 1. Kiti projenizin köküne kopyalayın

```
YourProject/
├── build.bat                 ← kendi betikleriniz
├── AGENTS.md                 ← kökten kopyala
├── .agents/                  ← klasörü kopyala (tek kaynak: kurallar, komutlar, skill'ler)
├── tools/                    ← klasörü kopyala (generate-ai-configs.ps1)
├── .claude/                  ← klasörü kopyala (üretilmiş kurallar/komutlar zaten dahil)
├── .github/                  ← klasörü kopyala
├── .cursor/                  ← klasörü kopyala (üretilmiş kurallar zaten dahil)
├── .gemini/                  ← klasörü kopyala
├── .kiro/                    ← klasörü kopyala
└── .specify/                 ← klasörü kopyala (opsiyonel — spec şablonları)
```

`.agents/rules/` veya `.agents/commands/` altında bir dosya ekler ya da
düzenlerseniz, `.claude/rules`, `.cursor/rules` ve `.claude/commands`'i
yenilemek için proje kökünden `pwsh tools/generate-ai-configs.ps1`'i
yeniden çalıştırın.

### 2. AI kuralları otomatik devralır

- **Claude Code** — `.claude/CLAUDE.md`'yi uygular, `.claude/rules/*.md`'yi (üretilmiş) ve `.agents/skills/batch-scripting/SKILL.md`'yi doğrudan okur
- **Cursor** — `.cursor/rules/*.md`'yi (üretilmiş) bağlama göre otomatik okur
- **Codex CLI** — proje kökünde `AGENTS.md`'yi, artı skill'i okur
- **GitHub Copilot** — workspace'te `.github/copilot-instructions.md`'yi, artı skill'i okur
- **Antigravity / Gemini** — `.gemini/rules/project-rules.md`'yi, artı skill'i okur
- **Kiro** — `.kiro/steering/*.md`'yi sabit ürün bağlamı olarak okur

> **Ek yapılandırma gerekmez.** Projeyi açın, tercih ettiğiniz AI'yı kullanın ve farkı görün.

---

## 💡 İyi Uygulama Örnekleri

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

Guard clause'lar, tırnaklı yollar, odaklı alt yordamlar, `robocopy`'nin
başarı-aralığına saygı, her çıkış yolunda temizlik — bu örneğin arkasındaki
tam kural seti için `.agents/rules/batch-conventions.md`'ye bakın.

---

## 🎯 Tasarım ve Felsefe

![Design & Philosophy](docs/images/design-philosophy.png)

**Gerçekten çalıştırılana kadar bir betiğe asla güvenme.**

Batch'in derleyicisi, tip sistemi ve test framework'ü yoktur — doğru
okunan bir betik yine de sessizce yanlış olabilir (`%VAR%`/`!VAR!`
karışıklığı, metin editöründe görünmeyen bir satır sonu sorunu) veya
felaket düzeyinde yanlış olabilir (çağıranın shell'ini kapatan çıplak
`exit`, karşılaştığı ilk `Program Files` kurulumunda bozulan tırnaksız
yol). Bu kitin merkezi tasarım tercihi, temiz bir okumanın sahte
güveni yerine **manuel, yapılandırılmış doğrulamayı** tercih etmektir:
öğrettiği her kural ya belirli bir hata modunu doğrudan önler
(tırnaklama, `exit /b`, `errorlevel` kontrolleri) ya da onayından önce
o hata modunun gerçekten tetiklenmesini zorunlu kılar (doğrulama kontrol
listesinin boşluklu-yol, eksik-girdi ve hata-yolu testleri). Kazanç, en
iyi anlamda sıkıcı olan betiklerdir — gözetimsiz-çalışmaya-hazır, kimsenin
izlemediği bir konsol yerine dosyaya loglayan ve birinin bir hatayı fark
ettiği gün değil, dağıtıldığı gün güvenilebilir olan.

---

## 🚫 AI Ignore / Bağlam Kontrol Listesi

Bu proje, yapay zeka ajanlarının neyi indeksleyip bağlam olarak kullandığını
kontrol eden çok katmanlı bir strateji uygular. PR göndermeden önce:

- [ ] `.cursorignore` yeni ağır veya ikili yolları içeriyor
- [ ] Temel talimat dosyaları (`AGENTS.md`, kurallar, skill'ler, örnekler) hariç tutul**muyor**
- [ ] `.vscode/settings.json` hariç tutmaları yeni yapı türleri için güncel
- [ ] Hiçbir sır (`*.key`, `*.pfx`, `.env`) commit'lenmemiş veya referans verilmemiş

> Tam gerekçe ve bakım rehberi için [docs/ai-ignore-strategy.md](docs/ai-ignore-strategy.md)'ye bakın.

---

## 🗣️ Kullanabileceğiniz AI Komutları

**Bu kitin kendisini** herhangi bir desteklenen AI CLI'de (Claude Code, Codex, Gemini/Antigravity, Cursor) çalışma klasörü olarak açın — aşağıdaki komutlar, paketlenmiş `rad-prompt-studio` skill'i ve bu kitin kendi `AGENTS.md`'si tarafından yürütülerek yerel olarak çalışır:

| Siz şunu söylerseniz | Ne olur |
|---|---|
| `Sistemi analiz et` / `Analyze the system` | Bu kitin kendi sistem katmanını analiz eder (`.agents/skills/`, `.agents/rules/`, `.agents/commands/`, `AGENTS.md`, `.claude/CLAUDE.md`) — `examples/`, `docs/`, `src/`, `tools/` siz istemedikçe dışarıda kalır. Rapor bu kitin kendi `analysis/result/{ai}_v{n}.md`'sine iner — yerel bir çalışma dosyasıdır, bilerek gitignore'lanmıştır; uygulanan düzeltmelerin kalıcı kaydı git geçmişi + issue'lar + CHANGELOG'dur. |
| `Değerlendir` / `Evaluate the findings` | `analysis/result/`'taki mevcut raporları güncel içeriğe karşı derecelendirir (`STILL_VALID`/`STALE`/`REFUTED`...), bir düzeltme listesi sunar ve onayınızı bekler. |
| `Düzelt: <hedef>` / `Fix <target>` | Onay-kapılı düzenleme: analiz → önceki bulguların değerlendirmesi → açık onayınız → düzenleme. Düzenlenen dosya paketlenmiş bir paylaşımlı skill (`rad-*`) ise ve bu kit üst AI-Spec-Kits-Maker çalışma alanının içindeyse, aynı düzeltme üst çalışma alanının ana kopyasına da uygulanır — her iki taraf da güncel kalır. |
| `<konu> için skill var mı?` / `Is there a skill for <topic>?` | Paketlenmiş `rad-skill-finder`, yerel → `npx skills` ekosistemi → dizinler → MCP/plugin kayıtları → web sırasıyla, görünür kanıtla (≥3 sorgu varyantı) arar; bulunanlar karantina + güvenlik taramasından geçer, sonra tek kurulum onayı sorulur. |

---

<div align="center">

Windows otomasyonu ve betik yazımı için ❤️ ile yapıldı.

*[🇬🇧 English](README.md) · [License](LICENSE)*

*Bu kit işinize yaradıysa, depoda bir ⭐ bırakın!*

</div>
