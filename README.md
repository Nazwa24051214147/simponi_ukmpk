# SIMPONI UKMPK

**Sistem Informasi Manajemen Program dan Organisasi UKM Peduli
Kemanusiaan UNESA**

SIMPONI UKMPK adalah aplikasi mobile untuk membantu pengelolaan
aktivitas organisasi UKM Peduli Kemanusiaan (UKMPK) Universitas Negeri
Surabaya. Aplikasi dirancang sebagai pusat informasi dan pengelolaan
organisasi, mulai dari akun anggota, divisi, program kerja, kepanitiaan,
kegiatan, jadwal, dokumen, hingga presensi.

Dokumen ini menjadi gambaran umum proyek sekaligus acuan kerja bagi
pengembang dan AI coding agent (termasuk Antigravity IDE). Implementasi
harus mengikuti kebutuhan yang tertulis di sini dan struktur kode yang
sudah tersedia di repository.

## 1. Latar Belakang

Pengelolaan organisasi mahasiswa melibatkan banyak anggota, divisi,
program kerja, kepanitiaan, kegiatan, jadwal, dokumen, serta data
kehadiran. Jika informasi tersebar di banyak media, pengurus dapat
mengalami kesulitan dalam memantau perkembangan program kerja,
membagikan informasi, mengelola keanggotaan panitia, dan
mendokumentasikan kegiatan.

SIMPONI dikembangkan sebagai aplikasi terpusat agar informasi organisasi
lebih tertata, mudah diakses sesuai kewenangan, dan dapat digunakan oleh
Admin, Pengurus, maupun Anggota.

## 2. Tujuan

1.  Memusatkan informasi organisasi UKMPK dalam satu aplikasi.
2.  Mempermudah pengelolaan akun dan data anggota.
3.  Menyediakan informasi divisi dan struktur kepengurusan.
4.  Membantu perencanaan dan pemantauan program kerja.
5.  Memfasilitasi pengelolaan kepanitiaan dan kegiatan.
6.  Menyediakan informasi jadwal kegiatan.
7.  Memudahkan distribusi materi dan dokumen organisasi.
8.  Mendukung pencatatan presensi kegiatan.
9.  Menyediakan akses berdasarkan peran dan kewenangan pengguna.

## 3. Pengguna dan Hak Akses

SIMPONI memiliki tiga role utama:

### Admin

Admin merepresentasikan Ketua Umum dan Wakil Ketua Umum. Admin memiliki
kewenangan pengelolaan sistem dan data organisasi, antara lain: -
Mengelola akun pengguna. - Mengelola data anggota. - Mengelola data
divisi. - Memantau dan mengelola program kerja. - Mengakses informasi
organisasi sesuai kebutuhan pengelolaan.

### Pengurus

Pengurus merepresentasikan Kepala Divisi dan Wakil Kepala Divisi.
Pengurus memiliki kewenangan pengelolaan sesuai divisi dan tanggung
jawabnya, antara lain: - Melihat informasi organisasi. - Mengelola
program kerja dan kegiatan divisinya sesuai aturan aplikasi. - Mengelola
informasi kepanitiaan pada program kerja yang menjadi tanggung
jawabnya. - Mengakses dokumen sesuai kewenangan.

Pengurus tidak otomatis memiliki akses untuk mengubah data seluruh
divisi. Pembatasan berdasarkan divisi harus diterapkan pada backend,
bukan hanya menyembunyikan tombol di frontend.

### Anggota

Anggota merupakan anggota UKMPK yang menggunakan aplikasi untuk: -
Melihat informasi organisasi dan divisi. - Melihat program kerja dan
kegiatan. - Mendaftar kegiatan atau kepanitiaan apabila pendaftaran
dibuka. - Melihat jadwal. - Mengakses materi atau dokumen yang diberikan
kepadanya. - Melakukan presensi kegiatan.

## 4. Ruang Lingkup Fitur

  -----------------------------------------------------------------------
  Fitur                               Ringkasan
  ----------------------------------- -----------------------------------
  Autentikasi dan Pengelolaan Akun    Login, logout, profil, ganti
                                      password, pengelolaan akun oleh
                                      Admin, dan hak akses

  Divisi                              Informasi divisi, struktur
                                      pengurus, dan anggota

  Program Kerja                       Data program kerja, penanggung
                                      jawab, status, periode, dan
                                      pemantauan

  Kepanitiaan                         Susunan panitia, SC, ketua
                                      pelaksana, koordinator, sie, dan
                                      anggota panitia

  Kegiatan dan Pendaftaran            Informasi kegiatan, pendaftaran
                                      peserta/panitia, kuota, dan status
                                      pendaftaran

  Jadwal                              Agenda kegiatan dan tampilan
                                      kalender/daftar agenda

  Materi dan Dokumen                  Unggah, pengelompokan, dan akses
                                      dokumen sesuai kewenangan

  Presensi                            Pencatatan kehadiran menggunakan
                                      QR/kode dan alternatif manual

  Dashboard                           Ringkasan informasi sesuai role
                                      pengguna
  -----------------------------------------------------------------------

Rincian setiap fitur tersedia di folder [`features/`](features/).

## 5. Teknologi

  Bagian            Teknologi
  ----------------- ----------------------------------------
  Mobile frontend   Flutter
  Backend           Laravel 12
  Bahasa backend    PHP
  Database          PostgreSQL
  Autentikasi API   Laravel Sanctum
  Pengujian API     Postman
  IDE               Visual Studio Code dan Antigravity IDE
  Version control   Git dan GitHub

Versi paket dan dependensi harus mengikuti konfigurasi aktual pada
repository (`composer.json`, `pubspec.yaml`, dan file konfigurasi lain).
Jangan mengganti versi atau stack tanpa alasan teknis dan persetujuan.

## 6. Gambaran Arsitektur

Aplikasi menggunakan arsitektur client-server:

1.  Pengguna berinteraksi dengan aplikasi Flutter.
2.  Flutter mengirim HTTP request ke REST API Laravel.
3.  Laravel memvalidasi input, autentikasi, otorisasi, dan aturan
    bisnis.
4.  Laravel membaca atau mengubah data pada PostgreSQL.
5.  Laravel mengirim response JSON kepada Flutter.
6.  Flutter menampilkan hasil kepada pengguna.

**Prinsip penting:** aturan bisnis dan otorisasi harus ditegakkan di
backend. Validasi frontend hanya membantu pengalaman pengguna dan tidak
menggantikan validasi backend.

## 7. Struktur Repository yang Diharapkan

Struktur aktual repository harus dipertahankan. Gambaran direktori
proyek:

``` text
SIMPONI/
├── README.md
├── features/
│   ├── README-AUTENTIKASI-AKUN.md
│   ├── README-DIVISI.md
│   ├── README-PROGRAM-KERJA.md
│   ├── README-KEPANITIAAN.md
│   ├── README-KEGIATAN-PENDAFTARAN.md
│   ├── README-JADWAL.md
│   ├── README-MATERI-DOKUMEN.md
│   ├── README-PRESENSI.md
│   └── README-DASHBOARD.md
├── backend/
│   └── Laravel project
└── simponi_ukmpk/
    └── Flutter project
```

Jika repository sudah memiliki struktur berbeda, jangan memindahkan atau
membuat ulang proyek. Tempatkan dokumentasi pada lokasi yang sesuai.

## 8. Prinsip Pengembangan

-   Pertahankan Laravel sebagai backend dan Flutter sebagai mobile
    frontend.
-   Gunakan PostgreSQL yang sudah dikonfigurasi.
-   Gunakan Laravel Sanctum untuk autentikasi API.
-   Ikuti pola penamaan, struktur folder, model, migration, controller,
    request, middleware, route, dan widget yang sudah ada.
-   Gunakan relasi database yang konsisten dan foreign key.
-   Hindari duplikasi data anggota, program kerja, pendaftaran, dan
    presensi.
-   Terapkan validasi pada backend.
-   Terapkan otorisasi berdasarkan role dan ruang lingkup kewenangan.
-   Jangan membuat registrasi akun publik. Akun dibuat oleh Admin.
-   Jangan menimpa atau menghapus implementasi yang sudah berjalan.
-   Jangan membuat tabel, model, route, atau halaman duplikat sebelum
    memeriksa struktur yang tersedia.
-   Buat implementasi yang sederhana, realistis, dan dapat diselesaikan
    untuk proyek akademik.
-   Prioritaskan alur utama aplikasi agar semua fitur inti terbentuk
    sebelum penyempurnaan kosmetik.
-   Gunakan bahasa antarmuka Indonesia, kecuali istilah teknis yang
    lebih lazim digunakan.

## 9. Panduan untuk Antigravity IDE / AI Coding Agent

Dokumentasi ini adalah acuan kebutuhan. Saat mengerjakan repository:

1.  Baca README utama dan README fitur yang sedang dikerjakan.
2.  Periksa struktur kode yang relevan secukupnya sebelum mengubahnya.
3.  Lanjutkan implementasi dari kode yang sudah ada; jangan memulai
    ulang proyek.
4.  Kerjakan backend dan Flutter untuk fitur yang sama secara terarah.
5.  Buat migration/model/controller/request/route serta
    halaman/widget/service/provider sesuai pola proyek.
6.  Hubungkan frontend ke endpoint backend yang benar-benar dibuat.
7.  Jangan membuat data dummy sebagai pengganti API permanen. Data dummy
    boleh digunakan sementara untuk kerangka UI jika integrasi API belum
    tersedia, dan harus mudah diganti.
8.  Jangan menghabiskan proses dengan laporan panjang, pengecekan
    berulang, atau refactor yang tidak diperlukan.
9.  Fokus membangun kerangka dan alur utama fitur terlebih dahulu.
    Pengujian menyeluruh dan cross-check dilakukan setelah beberapa
    fitur utama terbentuk.
10. Jika menemukan konflik kebutuhan atau struktur database yang belum
    jelas, jangan mengarang aturan penting. Pilih solusi paling
    sederhana yang konsisten dan catat asumsi tersebut.

**Output yang diharapkan dari coding agent:** implementasi kode yang
langsung tersimpan di workspace, bukan hanya rencana atau penjelasan.

## 10. Status Implementasi Berdasarkan Catatan Proyek

Status ini merupakan catatan awal berdasarkan pekerjaan yang telah
dibahas. Status aktual harus disesuaikan dengan isi repository terbaru.

  -----------------------------------------------------------------------
  Area                                Catatan status
  ----------------------------------- -----------------------------------
  Laravel dan koneksi PostgreSQL      Fondasi proyek sudah dibuat dan
                                      koneksi lokal pernah berhasil

  Sanctum dan login                   Sudah diimplementasikan

  Logout dan endpoint profil pengguna Sudah diimplementasikan

  Pengelolaan akun Admin              Endpoint daftar, detail, tambah,
                                      ubah, dan aktif/nonaktif akun sudah
                                      dibuat

  Akun anggota dan relasi data        Sudah memiliki model/relasi users
  anggota                             dan members

  Password sementara                  Akun baru dibuat dengan kewajiban
                                      mengganti password

  Middleware password pertama kali    Sudah dibuat dan route dilindungi;
                                      perlu cross-check final pada
                                      repository

  Role Admin/Pengurus/Anggota         Role dasar sudah tersedia;
                                      penerapan kewenangan per fitur
                                      masih perlu dilanjutkan

  Divisi                              Model dan relasi dasar sudah ada;
                                      fitur API dan UI divisi menjadi
                                      tahap berikutnya

  Fitur lain                          Direncanakan dalam dokumen fitur
                                      dan perlu diimplementasikan
  -----------------------------------------------------------------------

Jangan menganggap fitur selesai hanya karena route atau tampilan sudah
dibuat. Fitur dianggap selesai setelah alur utama frontend-backend
terhubung dan dapat digunakan.

## 11. Alur Pengembangan yang Disarankan

1.  Autentikasi, pengelolaan akun, dan hak akses.
2.  Divisi.
3.  Program kerja.
4.  Kepanitiaan.
5.  Kegiatan dan pendaftaran.
6.  Jadwal.
7.  Materi dan dokumen.
8.  Presensi.
9.  Dashboard dan penyempurnaan ringkasan tiap role.
10. Integrasi menyeluruh, pengujian, perbaikan, dan dokumentasi akhir.

Urutan dapat disesuaikan jika ada dependensi teknis, tetapi relasi inti
seperti akun, anggota, dan divisi harus dijaga konsistensinya.

## 12. Aturan Data dan Keamanan

-   Password harus disimpan dalam bentuk hash, bukan plaintext.
-   Token autentikasi tidak boleh ditulis ke log atau repository.
-   Akun nonaktif tidak boleh mengakses endpoint yang dilindungi.
-   Akun baru wajib mengganti password sementara sebelum menggunakan
    fitur normal.
-   Email dan NIM harus unik.
-   Satu akun anggota terhubung dengan data anggota yang sesuai.
-   Penghapusan data yang masih memiliki relasi harus ditangani dengan
    aturan foreign key dan kebijakan aplikasi.
-   Dokumen internal atau sensitif hanya boleh diakses oleh pengguna
    yang berwenang.
-   Endpoint admin harus dilindungi middleware autentikasi dan
    otorisasi.
-   Validasi dan pemeriksaan kepemilikan data dilakukan di backend.

## 13. Batasan dan Asumsi

-   SIMPONI berfokus pada kebutuhan internal UKMPK, bukan aplikasi
    organisasi umum multi-tenant.
-   Tidak tersedia pendaftaran akun mandiri untuk publik.
-   Akun anggota dibuat dan dikelola Admin.
-   Role utama sistem adalah Admin, Pengurus, dan Anggota.
-   Kewenangan Pengurus mengikuti divisi dan penugasan program kerja.
-   Detail kebijakan seperti kuota pendaftaran, masa pendaftaran,
    kategori dokumen, dan aturan presensi dapat disesuaikan pada
    implementasi fitur terkait.
-   Fitur yang belum dirinci secara eksplisit harus dibuat sederhana dan
    konsisten dengan tujuan aplikasi.

## 14. Cara Menjalankan Proyek

Perintah berikut merupakan gambaran umum. Sesuaikan dengan konfigurasi
lokal dan isi file proyek.

### Backend Laravel

``` bash
cd backend
composer install
cp .env.example .env
php artisan key:generate
```

Atur koneksi PostgreSQL pada `.env`, lalu jalankan migration sesuai
kondisi database:

``` bash
php artisan migrate
php artisan serve
```

Jangan menjalankan migration reset/fresh pada database yang berisi data
penting tanpa memastikan backup dan persetujuan.

### Flutter

``` bash
cd simponi_ukmpk
flutter pub get
flutter run
```

Konfigurasi base URL API harus menyesuaikan target perangkat/emulator.
Jangan mengasumsikan `localhost` pada emulator Android sama dengan
localhost komputer.

## 15. Dokumentasi Fitur

-   [Autentikasi, Akun, dan Hak
    Akses](features/README-AUTENTIKASI-AKUN.md)
-   [Divisi](features/README-DIVISI.md)
-   [Program Kerja](features/README-PROGRAM-KERJA.md)
-   [Kepanitiaan](features/README-KEPANITIAAN.md)
-   [Kegiatan dan Pendaftaran](features/README-KEGIATAN-PENDAFTARAN.md)
-   [Jadwal](features/README-JADWAL.md)
-   [Materi dan Dokumen](features/README-MATERI-DOKUMEN.md)
-   [Presensi](features/README-PRESENSI.md)
-   [Dashboard](features/README-DASHBOARD.md)

------------------------------------------------------------------------

**SIMPONI UKMPK --- Together We Care**
