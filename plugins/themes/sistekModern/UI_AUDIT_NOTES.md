# UI Audit Notes - SISTEK Modern Theme (Fase 1)

## Halaman yang Perlu Dimodernisasi
- Homepage jurnal (`indexJournal`).
- Issue Table of Contents (`issue`, `issue_toc`).
- Article detail page (`article`, `article_details`).
- Search page (`search`).
- Archive page (`issueArchive`).
- Header/navigation/footer global.
- Sidebar blocks (template/tools/indexing/visitor/menu).

## Masalah Visual Saat Ini
- Tampilan masih mengikuti default OJS dengan pola lama.
- Spacing, hierarchy, dan konsistensi card belum modern.
- Sidebar masih padat dan dominan, mengurangi fokus konten ilmiah.
- Elemen CTA belum diprioritaskan secara visual.
- Gaya blok belum konsisten antar halaman prioritas.

## Potensi Hardcoded URL
- Item `Home` pada menu utama masih terindikasi remote URL ke domain production.
- Beberapa custom block memakai URL absolut domain production.
- Potensi mismatch saat berpindah local/staging/production jika URL tidak dinormalisasi.

## Sidebar/Block yang Perlu Dirapikan
- Block `Menu` (banyak inline style, struktur seperti tombol manual).
- Block `Template` (tabel + inline style).
- Block `Tools` (gambar/logo eksternal dengan inline style).
- Block `Indexing` (tabel dan tautan placeholder).
- Block `Visitor` (struktur lama berbasis tabel/noscript embed).

## Catatan Fase 3A/3B
- Fondasi design tokens dan reusable components telah ditambahkan pada theme.
- Icon system lokal SVG dan placeholder image lokal telah disiapkan.
- Belum ada perubahan konten block, navigasi database, atau template besar (sesuai batasan fase).

## Catatan Fase 4/5A
- Header telah dimodernisasi lewat override theme template, termasuk CTA `Submit Manuscript`.
- Homepage journal telah ditambah Hero, Trust Bar, Current Issue Highlight, dan Trust Quick Links.
- Ditemukan potensi hardcoded URL `Home` di konfigurasi navigation menu level database (bukan template); belum diubah pada fase ini.
- Beberapa quick link kebijakan (mis. `peer-review`, `ethics`, `apc`, `openaccesspolicy`, `plagiarismpolicy`, `focusnscope`) diasumsikan berasal dari Static Pages plugin. Jika salah satu belum tersedia, perlu validasi dan penyesuaian path melalui dashboard OJS.
- Pada homepage, blok `additionalHomeContent` masih memuat HTML tabel lama, karakter encoding bermasalah, placeholder ISSN `xxxx-xxxx`, dan URL absolut production; perlu dirapikan via dashboard OJS (bukan via core/cache).
- Sidebar custom blocks (`customblock-menu`, `customblock-template`, `customblock-indexing`, `customblock-tools`, `customblock-flagcounter`) masih berisi inline style + tautan/gambar eksternal absolut; fase ini hanya dipoles visual via CSS dan belum normalisasi kontennya.

## Catatan Debug Regression (Fase 4/5A refinement)
- Ditemukan regression layout desktop dari rule LESS `max-width: calc(100% - 300px)` pada `.pkp_page_index.pkp_op_index .pkp_structure_main`.
- Pada hasil kompilasi LESS, ekspresi tersebut berubah menjadi `max-width: calc(-200%)`, sehingga kolom utama homepage kolaps dan seluruh section terlihat sempit/tertekan.
- Perbaikan: hapus rule tersebut, tambah guard `min-width: 0`, `width: 100%`, `box-sizing: border-box`, serta normalisasi grid trust/current issue/quick links agar proporsi desktop kembali stabil.
- Stabilisasi lanjutan: homepage sekarang memakai layout grid aman (main + sidebar) khusus desktop melalui theme, sekaligus menonaktifkan render `homepage_image` dan `homepage_about` default karena sudah digantikan Hero/Trust sections.
- Catatan tersisa: `additionalHomeContent` dari dashboard masih berisi HTML tabel legacy + hardcoded URL production; sudah dibungkus card agar lebih rapi, tetapi konten sumber tetap perlu normalisasi via dashboard OJS.
- Untuk stabilisasi homepage, `additionalHomeContent` saat ini disembunyikan dari homepage theme karena sumber kontennya masih berisi markup tabel lama, placeholder `xxxx-xxxx`, dan URL production absolut yang memecah layout modern.

## Catatan Rombak Homepage (arah IA seperti KINETIK, tanpa menyalin aset/desain)
- Homepage dirombak menjadi struktur fungsional:
  - left rail informasi jurnal di area main,
  - center content untuk banner/about/recent articles,
  - sidebar OJS tetap asli di kanan.
- `additionalHomeContent` legacy tetap disembunyikan pada homepage modern untuk mencegah regresi layout dan duplikasi konten lama.
- Section `Recent Articles` sekarang mengambil data dari variabel OJS `publishedSubmissions` (current issue context) tanpa query database manual.
- Beberapa quick link (`peer-review`, `ethics`, `apc`, `openaccesspolicy`, `plagiarismpolicy`, `focusnscope`) tetap bergantung pada halaman statis/plugin; perlu validasi di dashboard jika ada route yang belum aktif.

## Catatan Fase 5R (Rollback & Stabilize Homepage)
- Homepage di-rollback ke struktur minimal dan aman untuk stabilisasi:
  - intro jurnal sederhana,
  - current issue sederhana,
  - quick links sederhana,
  - announcements (jika ada).
- Implementasi top-grid/slider/recent articles/editorial pick dari fase lanjutan tidak dirender pada tahap ini.
- `additionalHomeContent` legacy tetap disembunyikan di homepage sistekModern agar tidak memunculkan tabel/inline-style/hardcoded URL yang memicu regression layout.
- Struktur main/sidebar OJS tetap default: konten custom hanya di area main, sidebar tidak dirender manual.

## Catatan Fase 5U-A (Unify-Inspired Top Grid)
- Top area homepage sekarang menggunakan grid internal `.jkc-unify-top` di area main content (bukan override layout global OJS).
- Struktur top grid:
  - left rail: current issue + journal facts,
  - center: feature banner + CTA,
  - right action rail: make submission, quick links, author resources.
- Pada viewport desktop lebar, right action rail tampil sebagai kolom kanan internal.
- Pada viewport desktop menengah/tablet, right action rail fallback menjadi card row di bawah banner agar tidak memaksa 3 kolom.
- Pada mobile, urutan stack: banner, action rail, left rail.
- Quick links dengan route `focusnscope`, `peer-review`, `ethics`, `apc`, `openaccesspolicy` masih bergantung halaman statis/plugin dan perlu verifikasi di dashboard jika ada route yang belum aktif.
- Refinement lanjutan: sidebar OJS bawaan disembunyikan khusus homepage (`pkp_page_index pkp_op_index`) untuk memberi ruang top grid internal 3 zona. Sidebar halaman lain tidak diubah.
- Refinement visual lanjutan:
  - masthead identity ditambahkan sebelum top grid,
  - center banner diperbesar agar lebih dominan,
  - current issue dibuat lebih cover-like dengan pattern halus,
  - make submission card dibuat lebih menonjol dengan ikon lokal.

## Catatan Refinement Visual (Unify-inspired, clean white)
- Masthead dipindahkan ke area header homepage (sebelum navbar) agar identitas jurnal terlihat lebih kuat tanpa menambah hero ganda di main content.
- Banner center sekarang memakai aset lokal `assets/images/jkc-feature-banner.svg` (tanpa hotlink/CDN).
- Card `Meet Our Editorial Team` pada right rail saat ini menggunakan fallback aman (tautan ke halaman editorial team) karena data editor dinamis belum diambil untuk homepage.
- Route quick links non-standar (`focusnscope`, `peer-review`, `ethics`, `apc`, `openaccesspolicy`) tetap perlu validasi di dashboard OJS/Static Pages plugin.

## Catatan Refactor Berdasarkan Prototype `references/jkc-home-prototype.html`
- Struktur yang diadopsi:
  - topbar/brand area,
  - masthead di atas navbar,
  - grid 3 kolom homepage (left current issue, center feature+about, right actions/resources/editorial team),
  - section About Journal,
  - CTA Make Submission yang menonjol.
- Bagian prototype yang tidak diadopsi:
  - seluruh warna gold/cream,
  - metrik/klaim (`SINTA`, `CiteScore`, `Q1`, `Scopus`) karena tidak valid untuk ditampilkan saat ini,
  - data editorial dummy (nama/foto/ID) karena berisiko data palsu.
- Editorial Team pada homepage saat ini menggunakan fallback aman: card deskriptif + tautan ke halaman editorial team.
- `additionalHomeContent` legacy tetap tidak dirender di homepage modern karena masih memuat tabel/inline-style/hardcoded URL production.

## Catatan Refactor Berdasarkan Prototype `references/proto-v2.html`
- Layout homepage diterjemahkan mendekati prototype v2:
  - topbar brand rendah,
  - masthead penuh di atas navbar,
  - navbar centered,
  - grid 3 kolom `300px / minmax(0, 1fr) / 320px`,
  - current issue di kiri,
  - feature banner dan About Journal di tengah,
  - Make Submission, Author Resources, dan Editorial Team fallback di kanan.
- Bagian prototype yang tetap tidak dipakai:
  - metrik/journal ranking dummy (`SINTA`, `CiteScore`, `Q1`, `Scopus`),
  - data editor dummy,
  - Google Fonts/CDN,
  - URL absolut production.
- Sidebar OJS bawaan tetap tidak dirender pada homepage modern melalui `isFullWidth`, sedangkan halaman lain tetap memakai mekanisme sidebar OJS.

## Prioritas Halaman untuk Fase Berikutnya
1. Header/navigation/footer (global impact).
2. Homepage jurnal (first impression).
3. Sidebar blocks (keterbacaan dan struktur informasi).
4. Issue TOC (discoverability artikel).
5. Article detail page (readability konten ilmiah).
6. Search dan archive (navigasi konten lama).

## Homepage Primary Menu + Indexing Section
- Added homepage section using OJS primary menu data via theme template, styled as policy/navigation cards.
- Indexed In labels are visual text badges and should be kept aligned with verified indexing records from the OJS dashboard/block content.
- Analytics card remains informational; no visitor/statistic numbers are generated by the theme.

## Homepage Menu and Indexing Refinement
- Homepage information strip now uses static OJS-internal route links that mirror the journal Primary Menu items shown in the existing sidebar block.
- Indexed In rail is static and limited to currently visible journal indexing labels: Google Scholar, GARUDA, Crossref, WorldCat, Dimensions, plus More Indexing link.
- No external indexing logos or hotlinked assets were added; future phase can replace text marks with verified local logo assets if provided.

## Local Indexing PNG Assets
- Replaced homepage Indexed In text marks with local PNG assets in plugins/themes/sistekModern/assets/images/indexing/.
- Assets are stored locally to avoid hotlinking; they are logo-style visual marks for the currently listed indexing services.
- If official brand assets are provided later, replace these local placeholders with approved files.

## Indexing Logo Replacement
- Homepage Indexed In now uses the provided PNG files in plugins/themes/sistekModern/assets/images/indexing/: Logo-Google-Scholar, logo-garuda, logo-crossref, logo-world-cat, and logo-dimensions.
- CSS was adjusted for cleaner logo spacing and consistent max display size.

## Current Issue Cover Asset
- Added local fallback cover image copied from oto/cover.png to plugins/themes/sistekModern/assets/images/current-issue-cover.png.
- Homepage current issue card uses the OJS issue cover when available; otherwise it falls back to this local theme asset.

## Feature Slider + About Merge
- Homepage center feature now combines image slider and About Journal content in one unified card.
- Slider uses local theme assets only: current-issue-cover.png and feature-slide-2.png.
- No external carousel library or CDN was added; slide rotation is CSS-based.

## Three-Slide Homepage Banner
- Homepage hero slider now reads three local PNG assets: feature-slide-1.png, feature-slide-2.png, and feature-slide-3.png.
- Current slide 3 is temporarily duplicated from the latest uploaded cover until the user replaces it with a third distinct image.

## Homepage Article Discovery Section
- Homepage sekarang memiliki section artikel dinamis di bawah info strip dengan tiga lane: `Recent`, `Most Read`, dan `Most View`.
- `Recent` mengambil submission published terbaru dari jurnal secara native melalui collector OJS.
- `Most Read` dan `Most View` mengambil data dari statistik publikasi OJS (`publicationStats`), tanpa angka dummy.
- Jika statistik usage belum tersedia di local, lane statistik akan menampilkan fallback halus, bukan angka palsu.
- Refinement terbaru: section artikel diubah menjadi tab buttons + horizontal slider cards agar lebih dekat ke pola premium journal homepage.
- Thumbnail artikel pada card sekarang memakai format landscape di bagian atas card, bukan thumbnail sempit di samping.

## Skema Thumbnail Artikel yang Aman
- Skema thumbnail artikel untuk homepage mengikuti fallback aman:
  1. cover image publication/artikel di OJS,
  2. cover issue terkait,
  3. placeholder theme lokal.
- Rekomendasi operasional: unggah cover image pada level publication tiap artikel agar card artikel memiliki identitas visual yang konsisten tanpa perlu modifikasi database/core.
- Section homepage `Editorial Pick` saat ini paling aman menggunakan fallback artikel terbit terbaru. OJS 3.4 standar tidak menyediakan selector native "jadikan editorial pick" pada article/publication.
- Opsi aman fase lanjutan untuk editorial pick manual:
  1. theme setting/plugin setting khusus sistekModern untuk menyimpan daftar article path/ID pilihan editor;
  2. custom block dashboard yang berisi link artikel pilihan editor dan dibaca theme;
  3. fallback otomatis ke artikel terbaru/current issue jika daftar manual belum diisi.
- Implementasi saat ini:
  - theme setting `Editorial Pick Articles` sudah disiapkan untuk input manual daftar article path/submission ID;
  - jika kosong, homepage fallback ke artikel terbaru terbit.
- Announcement setting jurnal:
  - `enableAnnouncements` aktif;
  - `numAnnouncementsHomepage` diset ke `2`;
  - belum ada data announcement di tabel OJS saat catatan ini dibuat, sehingga editor perlu menambahkan item announcement dari dashboard.

## Footer Refactor
- Footer sistekModern direfaktor menjadi layout terang dan profesional dengan empat area utama: identitas jurnal, contact info, journal links, dan policy links.
- Link OJS internal dipertahankan melalui helper URL theme, tanpa hardcoded domain absolut.
- pageFooter legacy tidak dirender mentah karena masih mengandung URL production absolut dan markup eksternal yang berisiko mengganggu konsistensi footer modern.

