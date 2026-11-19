# Fitur Dashboard

## 1. Tujuan

Menyediakan halaman utama yang menampilkan ringkasan informasi paling
relevan bagi pengguna setelah login. Isi dashboard menyesuaikan role dan
kewenangan pengguna.

## 2. Dashboard Admin

Informasi yang disarankan: - Jumlah anggota aktif. - Jumlah divisi. -
Jumlah program kerja. - Ringkasan status program kerja. - Agenda
terdekat. - Kegiatan yang sedang berlangsung atau akan datang. -
Informasi atau notifikasi penting.

Admin dapat mengakses ringkasan organisasi secara menyeluruh.

## 3. Dashboard Pengurus

Informasi yang disarankan: - Program kerja divisi. - Progres program
kerja yang menjadi tanggung jawabnya. - Agenda dan kegiatan terdekat. -
Informasi kepanitiaan. - Dokumen atau tugas yang perlu ditindaklanjuti.

Dashboard Pengurus harus memprioritaskan data divisi dan penugasan yang
menjadi kewenangannya.

## 4. Dashboard Anggota

Informasi yang disarankan: - Sapaan dan identitas pengguna. - Agenda
terdekat. - Kegiatan yang dapat diikuti. - Program kerja yang diikuti
sebagai panitia/peserta. - Jadwal pribadi atau kegiatan yang relevan. -
Notifikasi/informasi terbaru. - Akses cepat ke presensi, materi, divisi,
dan profil.

## 5. Navigasi Utama

Contoh menu utama: - Beranda. - Agenda. - Notifikasi. - Profil.

Menu fitur dapat ditampilkan sebagai pintasan: - Program Kerja. -
Kegiatan. - Jadwal. - Materi. - Presensi. - Divisi.

Menu yang ditampilkan dapat disesuaikan dengan role.

## 6. Kebutuhan Fungsional

-   Mengambil data ringkasan dari API.
-   Menampilkan loading state.
-   Menampilkan empty state jika belum ada data.
-   Menampilkan error state jika API gagal.
-   Menyediakan navigasi ke halaman detail.
-   Menyesuaikan ringkasan dengan role.
-   Memuat ulang data saat diperlukan.

## 7. Desain Antarmuka

Arah visual aplikasi menggunakan konsep Humanitarian Trust: - Deep Navy
`#173B50`. - Teal `#176A78`. - Warm Yellow `#E8B94F`. - Warm Ivory
`#F4F1E8`. - Soft Terracotta `#D96B45`.

Warna dapat digunakan secara proporsional: - Deep Navy untuk elemen
utama dan teks/komponen penting. - Teal untuk elemen pendamping. - Warm
Yellow untuk identitas UKMPK dan aksen. - Warm Ivory untuk background. -
Soft Terracotta untuk aksen kemanusiaan atau penanda tertentu.

Palet Earth & Humanity dapat menjadi inspirasi aksen tambahan, tetapi
jangan mengubah identitas utama tanpa keputusan desain.

## 8. Aturan Teknis

-   Jangan mengambil seluruh data organisasi tanpa kebutuhan.
-   Buat endpoint ringkasan yang efisien jika dibutuhkan.
-   Terapkan filter berdasarkan role dan kewenangan di backend.
-   Hindari query berulang yang tidak perlu.
-   Data dashboard harus berasal dari data aktual aplikasi, bukan angka
    hardcode.
-   Jika data belum tersedia, tampilkan nilai kosong atau empty state
    yang wajar.

## 9. Kriteria Selesai

-   Setiap role mendapatkan dashboard yang sesuai.
-   Data ringkasan berasal dari backend.
-   Pintasan menu bekerja.
-   Loading, empty, dan error state tersedia.
-   Dashboard tidak menampilkan informasi yang tidak boleh diakses
    pengguna.
