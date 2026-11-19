# Fitur Kegiatan dan Pendaftaran

## 1. Tujuan

Mengelola kegiatan yang menjadi bagian dari program kerja serta
menyediakan proses pendaftaran peserta atau anggota yang ingin mengikuti
kegiatan.

## 2. Data Kegiatan

Data kegiatan yang disarankan: - Nama kegiatan. - Deskripsi. - Program
kerja terkait. - Tanggal dan waktu mulai/selesai. - Lokasi atau media
pelaksanaan. - Kuota peserta jika dibatasi. - Periode pendaftaran. -
Status kegiatan. - Informasi tambahan.

## 3. Kebutuhan Fungsional Kegiatan

-   Melihat daftar kegiatan.
-   Melihat detail kegiatan.
-   Membuat dan mengubah kegiatan oleh pengguna berwenang.
-   Menautkan kegiatan ke program kerja.
-   Menampilkan waktu, lokasi, kuota, dan status.
-   Menampilkan daftar peserta/panitia sesuai izin.
-   Mengubah status kegiatan.

## 4. Pendaftaran

-   Anggota dapat melihat kegiatan yang membuka pendaftaran.
-   Anggota dapat mendaftar.
-   Sistem mencegah anggota mendaftar dua kali pada kegiatan yang sama.
-   Sistem memeriksa apakah periode pendaftaran masih dibuka.
-   Sistem memeriksa kuota jika kegiatan memiliki batas peserta.
-   Sistem menampilkan status pendaftaran kepada anggota.
-   Pengurus/Ketupel dapat melihat daftar pendaftar sesuai kewenangan.

Rancangan awal yang pernah dibahas adalah penerimaan otomatis
berdasarkan urutan pendaftaran selama kuota tersedia. Jika mekanisme ini
digunakan, backend harus menangani proses secara aman agar dua
pendaftaran bersamaan tidak membuat kuota terlampaui. Jika kegiatan
memerlukan seleksi, status pendaftaran dapat dibuat menunggu
persetujuan.

## 5. Status Pendaftaran

Status sederhana yang dapat digunakan: - Menunggu (jika ada proses
persetujuan). - Diterima. - Ditolak. - Dibatalkan.

Gunakan hanya status yang diperlukan oleh alur kegiatan yang dipilih.

## 6. Aturan Bisnis

-   Pendaftaran hanya dapat dilakukan oleh akun aktif.
-   Anggota hanya dapat mendaftar satu kali untuk kegiatan yang sama.
-   Pendaftaran ditolak jika periode sudah tutup.
-   Kuota tidak boleh terlampaui.
-   Pengguna tidak dapat mengubah pendaftaran milik orang lain.
-   Pembatalan pendaftaran mengikuti kebijakan kegiatan.
-   Data pendaftar menggunakan relasi ke member/user, bukan input nama
    bebas.

## 7. Frontend Flutter

Halaman: - Daftar Kegiatan. - Detail Kegiatan. - Form Pendaftaran. -
Daftar Kegiatan yang Diikuti. - Daftar Pendaftar untuk pengguna
berwenang.

Tampilkan status pendaftaran dengan jelas dan berikan konfirmasi sebelum
mengirim atau membatalkan pendaftaran.

## 8. Relasi

-   Kegiatan dimiliki oleh program kerja.
-   Kegiatan dapat memiliki jadwal.
-   Kegiatan dapat memiliki dokumen/materi.
-   Kegiatan dapat memiliki presensi.
-   Pendaftaran menghubungkan kegiatan dengan anggota.

## 9. Kriteria Selesai

-   Pengurus berwenang dapat membuat dan mengubah kegiatan.
-   Anggota dapat melihat dan mendaftar kegiatan.
-   Duplikasi pendaftaran dicegah.
-   Kuota dan periode pendaftaran diterapkan.
-   Pengguna dapat melihat status pendaftarannya.
-   Data Flutter berasal dari API.
