# Fitur Jadwal

## 1. Tujuan

Menyediakan informasi agenda organisasi dan kegiatan secara terpusat
agar anggota dan pengurus dapat mengetahui waktu pelaksanaan kegiatan.

## 2. Sumber Jadwal

Jadwal sebaiknya berasal dari data kegiatan atau agenda yang dikelola,
bukan dibuat ulang sebagai entitas terpisah tanpa alasan. Satu kegiatan
dapat memiliki waktu mulai dan selesai serta lokasi.

Jika satu kegiatan memiliki beberapa sesi, struktur jadwal dapat
mendukung beberapa sesi yang masing-masing terhubung ke kegiatan.

## 3. Kebutuhan Fungsional

-   Melihat agenda dalam tampilan daftar.
-   Melihat agenda dalam tampilan kalender.
-   Melihat detail agenda.
-   Filter berdasarkan tanggal, program kerja, atau divisi.
-   Menampilkan nama kegiatan, waktu, lokasi, dan status.
-   Pengurus berwenang dapat menambah atau mengubah jadwal.
-   Menangani perubahan jadwal dengan memperbarui data sumber dan
    menampilkan informasi terbaru.

## 4. Hak Akses

-   Admin dapat melihat seluruh jadwal.
-   Pengurus dapat melihat jadwal organisasi dan mengelola jadwal yang
    menjadi kewenangannya.
-   Anggota dapat melihat jadwal kegiatan yang tersedia untuknya.
-   Hanya pengguna berwenang yang dapat membuat atau mengubah jadwal.

## 5. Frontend Flutter

Halaman: - Agenda/Jadwal. - Tampilan kalender bulanan atau mingguan. -
Daftar agenda mendatang. - Detail kegiatan dari agenda.

Tampilan perlu menyediakan empty state ketika tidak ada agenda pada
tanggal terpilih.

## 6. Aturan Teknis

-   Simpan tanggal dan waktu dengan tipe data yang sesuai.
-   Konsisten menggunakan zona waktu yang disepakati aplikasi.
-   Waktu selesai tidak boleh lebih awal daripada waktu mulai.
-   Urutkan agenda berdasarkan waktu mulai.
-   Jadwal yang dibatalkan atau diubah harus terlihat statusnya.
-   Hindari duplikasi data antara tabel kegiatan dan jadwal.

## 7. Kriteria Selesai

-   Jadwal kegiatan tampil dalam daftar dan/atau kalender.
-   Filter tanggal berfungsi.
-   Detail agenda terhubung ke detail kegiatan.
-   Pengguna hanya dapat mengubah jadwal sesuai kewenangan.
-   Flutter mengambil jadwal dari API.
