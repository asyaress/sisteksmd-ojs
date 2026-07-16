# Restore SISTEK-SMD ke Komputer Lokal

Snapshot terenkripsi berisi:

- source OJS lengkap dari `public_html`
- `config.inc.php` produksi
- database MariaDB
- direktori `ojs-files`
- aset jurnal dan tema
- cache produksi

## Proses dasar

1. Gabungkan seluruh file `.part-*`.
2. Dekripsi menggunakan GPG dan password snapshot.
3. Ekstrak arsip.
4. Impor database ke MariaDB/MySQL lokal.
5. Salin `public_html` ke document root lokal.
6. Salin `ojs-files` ke folder di luar document root.
7. Sesuaikan `config.inc.php` untuk URL, database, dan files directory lokal.
8. Kosongkan `cache/t_cache`, `cache/t_compile`, dan `cache/_db`.
