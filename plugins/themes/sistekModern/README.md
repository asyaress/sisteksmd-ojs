# SISTEK Modern Theme

## Tujuan Theme
Theme ini adalah fondasi modernisasi UI OJS untuk Jurnal Sistem Informasi dan Teknologi STMIK Samarinda dengan pendekatan aman, bertahap, dan tanpa modifikasi core OJS.

Fokus fase saat ini:
- Fase 3A: Design Tokens & Icon System.
- Fase 3B: Reusable UI Components.
- Fase 4: Header & Navigation Modernization.
- Fase 5A: Homepage Trust & Hero Layout.

## Batasan No-Core-Modification
- Tidak mengubah core OJS pada folder: `lib/`, `classes/`, `pages/`, `controllers/`, `dbscripts/`, `vendor/`.
- Tidak menggunakan `cache/` sebagai sumber permanen perubahan.
- Tidak mengubah `config.inc.php`.
- Tidak mengubah workflow submission/review/publishing.

## Struktur Penting Theme
- `styles/index.less`: aggregator stylesheet theme.
- `styles/variables.less`: design tokens (warna, typo, spacing, radius, shadow, layout, transition).
- `styles/components.less`: komponen reusable (card, badge, button, panel, meta, thumbnail, skeleton).
- `styles/layout.less`: fondasi visual global layout.
- `styles/responsive.less`: aturan responsive mobile/tablet/desktop.
- `assets/icons/*.svg`: icon system lokal.
- `assets/images/article-placeholder.svg`: fallback thumbnail placeholder.

## Design Tokens
Token utama tersedia di `styles/variables.less`:
- Colors: primary, secondary, background, surface, text, muted, border, success/info/warning/error.
- Typography: body font stack, heading font stack, ukuran heading/body/small.
- Spacing: `xs`, `sm`, `md`, `lg`, `xl`, `2xl`.
- Radius: `sm`, `md`, `lg`, `xl`, `pill`.
- Elevation: subtle/card/hover shadow.
- Layout: container width, sidebar width, breakpoints.
- Motion: transition fast/normal.

## Icon System
Lokasi icon lokal:
- `assets/icons/doi.svg`
- `assets/icons/pdf.svg`
- `assets/icons/xml.svg`
- `assets/icons/abstract.svg`
- `assets/icons/views.svg`
- `assets/icons/downloads.svg`
- `assets/icons/calendar.svg`
- `assets/icons/authors.svg`
- `assets/icons/issue.svg`
- `assets/icons/search.svg`
- `assets/icons/submission.svg`
- `assets/icons/indexing.svg`
- `assets/icons/ethics.svg`
- `assets/icons/license.svg`

Aturan icon:
- Semua ikon lokal, tanpa CDN/library eksternal.
- Ikon berbasis `currentColor` agar mudah mewarisi warna teks.
- Gunakan ikon untuk membantu scanning, bukan mengganti label teks.
- Untuk ikon dekoratif, gunakan `aria-hidden="true"` saat implementasi template.

## Reusable Components
Class reusable yang tersedia di `styles/components.less`:
- Card: `.jkc-card`, `.jkc-card--hover`, `.jkc-card__title`, `.jkc-card__meta`.
- Badge: `.jkc-badge`, `.jkc-badge--doi`, `.jkc-badge--pdf`, `.jkc-badge--xml`, `.jkc-badge--abstract`.
- Button: `.jkc-button`, `.jkc-button--primary`, `.jkc-button--outline`, `.jkc-button--ghost`.
- Panel/meta: `.jkc-panel`, `.jkc-panel__title`, `.jkc-meta-row`, `.jkc-meta-item`.
- Utility: `.jkc-icon`, `.jkc-skeleton`, `.jkc-thumbnail`, `.jkc-thumbnail--placeholder`.

## Contoh Penggunaan Cepat
### Card
```html
<article class="jkc-card jkc-card--hover">
  <h3 class="jkc-card__title">Article title</h3>
  <div class="jkc-card__meta">Author, Date, DOI</div>
</article>
```

### Badge + Button
```html
<span class="jkc-badge jkc-badge--doi">DOI</span>
<a class="jkc-button jkc-button--outline" href="#">PDF</a>
```

### Thumbnail Placeholder
```html
<div class="jkc-thumbnail jkc-thumbnail--placeholder"></div>
```

## Editorial Pick Manual
Homepage mendukung `Editorial Pick` manual lewat setting theme.

Lokasi:
1. `Settings -> Website -> Appearance`
2. Pilih `SISTEK Modern Theme`
3. Isi field `Editorial Pick Articles`

Format input:
- satu article path atau submission ID per baris
- contoh:
```text
1
algoritma-evolusi-untuk-masalah-optimasi
3
```

Perilaku:
- jika field diisi, homepage akan mencoba menampilkan artikel sesuai urutan input.
- jika field kosong atau item tidak valid, homepage fallback ke artikel terbit terbaru.

Catatan:
- OJS 3.4 standar tidak punya tombol native `Mark as Editorial Pick`.
- implementasi ini sengaja memakai theme setting agar aman tanpa modifikasi core/database schema.

## Announcement Homepage
Announcement homepage mengikuti data native OJS.

Status implementasi:
- `enableAnnouncements` aktif untuk jurnal `jkc`
- `numAnnouncementsHomepage` diset ke `2`

Yang masih perlu dilakukan editor:
- menambahkan data announcement melalui dashboard OJS
- setelah ada item announcement, section `Announcements` di homepage akan otomatis terisi

## Guardrails
- Jangan edit core OJS.
- Jangan hardcode URL localhost/production.
- Jangan edit `cache/` untuk perubahan permanen.
- Jangan membuat statistik palsu.
- Jangan hotlink asset internet.
- Jangan menambah dependency besar tanpa persetujuan.

## Cara Aktivasi Theme di OJS Dashboard
1. Login sebagai `Journal Manager` atau `Site Admin`.
2. Buka: `Settings -> Website -> Appearance`.
3. Pilih `SISTEK Modern Theme`.
4. Simpan perubahan.
5. Jika style belum berubah, clear cache OJS.

## Cara Rollback ke Default Theme
1. Buka: `Settings -> Website -> Appearance`.
2. Pilih `Default Theme`.
3. Simpan.
4. Clear cache jika perlu.

## Next Phase Recommendation
Setelah fondasi 5A stabil:
1. Lanjut ke Fase 5B (Editorial Pick and Latest Articles).
2. Lanjut ke Fase 6 (Sidebar Modernization).
3. Lanjut ke Fase 7A (thumbnail fallback integration ke article cards).
4. Lanjut ke Fase 8A/8B (article metrics and metadata readability).
5. Lakukan regression test tiap fase sebelum lanjut.

## Homepage Prototype Direction
- Referensi visual saat ini adalah `references/jkc-home-prototype.html` sebagai acuan struktur/layout.
- Implementasi theme hanya mengadopsi information architecture dan proporsi, bukan menyalin aset/konten mentah.
- Palet prototipe gold/cream diterjemahkan ke identitas JKC (deep green/sage + putih/off-white).
- Data yang tidak tervalidasi (klaim indexing, statistik, profil editor dummy) tidak ditampilkan.
