# Fitur Program Kerja

## 1. Tujuan

Mengelola daftar program kerja UKMPK sebagai pusat informasi dan
pemantauan pelaksanaan program organisasi. Program kerja dapat dimiliki
atau dikoordinasikan oleh divisi tertentu dan memiliki penanggung jawab.

## 2. Data Program Kerja

Informasi yang disarankan: - Nama program kerja. - Deskripsi. - Divisi
penyelenggara/penanggung jawab. - Periode atau tahun kepengurusan. -
Tanggal rencana mulai dan selesai. - Status program kerja. - Ketua
Pelaksana (Ketupel) yang ditetapkan saat Rapat Kerja jika sudah
tersedia. - Informasi tambahan/catatan.

Status dapat menggunakan tahapan sederhana, misalnya: - Perencanaan. -
Persiapan. - Berlangsung. - Selesai. - Ditunda atau dibatalkan.

Nilai status final perlu konsisten di backend dan Flutter.

## 3. Hak Akses

### Admin

-   Melihat seluruh program kerja.
-   Membuat dan mengubah data program kerja.
-   Mengatur divisi penyelenggara dan penanggung jawab.
-   Memantau status seluruh program kerja.

### Pengurus

-   Melihat program kerja.
-   Mengelola program kerja yang menjadi kewenangan divisinya.
-   Memperbarui informasi dan progres sesuai penugasan.
-   Tidak boleh mengubah program kerja divisi lain tanpa kewenangan.

### Anggota

-   Melihat informasi program kerja.
-   Melihat program kerja yang diikuti atau menjadi panitia.
-   Tidak mengubah data utama program kerja.

## 4. Kebutuhan Fungsional

-   Daftar program kerja.
-   Detail program kerja.
-   Pencarian dan filter berdasarkan divisi, periode, dan status.
-   Tambah/edit program kerja oleh pengguna berwenang.
-   Perubahan status dan progres.
-   Informasi divisi dan penanggung jawab.
-   Navigasi ke detail kepanitiaan dan kegiatan terkait.

## 5. Relasi dengan Fitur Lain

-   Program kerja terkait dengan satu divisi penanggung jawab utama.
-   Program kerja dapat memiliki satu ketua pelaksana yang ditetapkan
    dalam Raker.
-   Program kerja dapat memiliki susunan kepanitiaan.
-   Satu program kerja dapat terdiri dari beberapa kegiatan.
-   Kegiatan dapat memiliki jadwal, materi, dan presensi.
-   Hindari menyimpan ulang data anggota sebagai teks jika sudah ada
    relasi ke `members`/`users`.

## 6. Frontend Flutter

Halaman: - Daftar Program Kerja. - Detail Program Kerja. - Form Tambah
Program Kerja. - Form Edit Program Kerja. - Filter program kerja.

Detail program kerja menampilkan identitas, deskripsi, divisi,
penanggung jawab, status, rentang tanggal, serta tautan ke kepanitiaan
dan kegiatan.

## 7. Aturan Teknis

-   Validasi nama dan divisi wajib.
-   Tanggal selesai tidak boleh lebih awal daripada tanggal mulai.
-   Perubahan status dicatat secara konsisten.
-   Otorisasi berdasarkan role dan divisi dilakukan di backend.
-   Jika program kerja sudah memiliki kegiatan/presensi, penghapusan
    harus dibatasi atau menggunakan status arsip.
-   Gunakan transaksi untuk perubahan yang melibatkan beberapa tabel.

## 8. Gambaran Endpoint

Rancangan: - `GET /api/programs` - `GET /api/programs/{program}` -
`POST /api/programs` - `PUT /api/programs/{program}` -
`PATCH /api/programs/{program}/status`

Prefix admin/pengurus dan policy akses disesuaikan implementasi.

## 9. Kriteria Selesai

-   Program kerja dapat dibuat dan dilihat.
-   Pengguna hanya dapat mengubah program kerja sesuai kewenangannya.
-   Detail menampilkan relasi divisi dan penanggung jawab.
-   Program kerja terhubung ke kepanitiaan dan kegiatan.
-   Flutter menampilkan data dari API.
