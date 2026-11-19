# Fitur Materi dan Dokumen

## 1. Tujuan

Menyediakan tempat terpusat untuk menyimpan, membagikan, dan mengakses
materi serta dokumen yang berkaitan dengan program kerja, kepanitiaan,
dan kegiatan UKMPK.

## 2. Jenis Dokumen

Contoh kategori: - Materi kegiatan. - Surat dan persuratan. -
Proposal. - Laporan pertanggungjawaban. - Notulensi. - Dokumentasi
pendukung. - Dokumen internal organisasi.

Kategori dapat disesuaikan dengan kebutuhan organisasi. Hindari membuat
daftar kategori yang terlalu rumit untuk versi awal.

## 3. Kebutuhan Fungsional

-   Mengunggah dokumen oleh pengguna berwenang.
-   Menambahkan nama, deskripsi, kategori, dan relasi dokumen.
-   Melihat daftar dokumen.
-   Mengunduh atau membuka dokumen.
-   Mengubah metadata dokumen.
-   Menghapus atau mengarsipkan dokumen sesuai izin.
-   Mengelompokkan dokumen berdasarkan program kerja/kegiatan.
-   Menampilkan siapa yang mengunggah dan kapan dokumen dibuat.

## 4. Hak Akses dan Kerahasiaan

-   Admin dapat mengakses dokumen organisasi sesuai kewenangannya.
-   Ketupel, SC, dan Pengurus terkait dapat mengakses dokumen program
    kerja yang menjadi tanggung jawabnya.
-   Anggota dapat mengakses materi yang dibagikan kepadanya.
-   Dokumen sie atau dokumen sensitif dapat dibatasi hanya untuk pihak
    tertentu.
-   Dokumen keuangan/internal tidak boleh otomatis tersedia untuk
    seluruh anggota.

Akses file harus diperiksa di backend setiap kali file dilihat atau
diunduh. Menyembunyikan tombol di Flutter bukan mekanisme keamanan yang
cukup.

## 5. Data yang Disarankan

Metadata dokumen: - Nama dokumen. - Deskripsi. - Kategori. - Lokasi/path
penyimpanan. - Tipe dan ukuran file. - Pengunggah. - Relasi program
kerja/kegiatan/divisi jika ada. - Tingkat akses. - Timestamp.

Simpan file pada storage yang sesuai dan simpan metadata/path di
database. Jangan menyimpan file biner besar langsung ke kolom database
kecuali ada alasan khusus.

## 6. Frontend Flutter

Halaman: - Daftar Dokumen. - Detail Dokumen. - Form Upload. - Filter
kategori/program kerja. - Preview atau unduh dokumen jika tipe file
didukung.

Tampilkan nama file, tipe, ukuran, tanggal unggah, dan status akses
secara jelas.

## 7. Aturan Teknis

-   Validasi tipe file dan ukuran maksimal.
-   Nama file harus ditangani dengan aman.
-   Hindari path traversal dan akses file tanpa otorisasi.
-   File privat tidak boleh disimpan pada lokasi publik tanpa
    perlindungan.
-   Penghapusan metadata dan file fisik harus konsisten.
-   Tangani kegagalan upload dan unduh.
-   Batasi akses berdasarkan relasi dan kewenangan pengguna.

## 8. Kriteria Selesai

-   Pengguna berwenang dapat mengunggah dokumen.
-   Dokumen tersimpan dan metadata tercatat.
-   Pengguna dapat melihat/mengunduh dokumen sesuai izin.
-   Dokumen sensitif terlindungi.
-   Flutter terhubung dengan API dokumen.
