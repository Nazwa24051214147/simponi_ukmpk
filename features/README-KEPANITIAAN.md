# Fitur Kepanitiaan

## 1. Tujuan

Mengelola struktur panitia untuk setiap program kerja, termasuk Steering
Committee (SC), Ketua Pelaksana, koordinator, sie, dan anggota panitia.

## 2. Struktur Kepanitiaan

Ketentuan dasar yang telah dirancang: - Setiap program kerja memiliki
satu penyelenggara utama. - Satu Ketua Pelaksana ditetapkan saat Rapat
Kerja (Raker). - SC berasal dari Kepala Divisi dan Wakil Kepala Divisi
penyelenggara secara otomatis sesuai aturan organisasi. - Anggota dapat
ditambahkan sebagai panitia. - Sie dan koordinator sie bersifat
fleksibel mengikuti kebutuhan program kerja. - Sekretaris dan Bendahara
dari BPH dapat ditugaskan pada program kerja sesuai kebutuhan.

Jabatan panitia berbeda dari jabatan struktural organisasi. Seseorang
dapat memiliki posisi struktural di organisasi dan jabatan kepanitiaan
pada program kerja.

## 3. Hak Akses

-   Admin dapat melihat dan mengelola susunan panitia seluruh program
    kerja.
-   Pengurus dapat mengelola kepanitiaan program kerja yang berada dalam
    kewenangannya.
-   Ketupel dan SC memiliki akses pengelolaan sesuai tanggung jawab.
-   Anggota dapat melihat susunan panitia dan menerima penugasan yang
    relevan.
-   Pembatasan perubahan harus dilakukan backend.

## 4. Kebutuhan Fungsional

-   Membuat susunan panitia untuk program kerja.
-   Menetapkan SC.
-   Menetapkan Ketupel.
-   Menambahkan dan menghapus anggota panitia.
-   Membuat sie sesuai kebutuhan.
-   Menentukan koordinator sie.
-   Menambahkan anggota ke dalam sie.
-   Menampilkan struktur panitia dalam bentuk daftar atau kelompok.
-   Mencegah penugasan ganda yang tidak diizinkan.
-   Menampilkan riwayat atau daftar penugasan anggota jika diperlukan.

## 5. Data yang Disarankan

Struktur data dapat menggunakan entitas: - Panitia/program committee
yang terhubung ke program kerja. - Posisi panitia. - Sie. - Penugasan
anggota ke posisi/sie.

Nama tabel dan bentuk relasi harus menyesuaikan skema yang sudah ada.
Jangan membuat tabel duplikat jika struktur serupa telah tersedia.

## 6. Aturan Bisnis

-   Satu program kerja memiliki satu Ketupel utama.
-   SC diturunkan dari struktur Kadiv dan Wakadiv divisi penyelenggara
    sesuai ketentuan.
-   Satu anggota tidak boleh memperoleh penugasan struktural organisasi
    ganda yang dilarang oleh aturan organisasi.
-   Keanggotaan panitia dapat berbeda dengan keanggotaan divisi.
-   Sie dapat lebih dari satu dan nama/jumlahnya fleksibel.
-   Koordinator sie harus merupakan anggota panitia pada sie tersebut.
-   Perubahan struktur panitia harus dilakukan oleh pengguna berwenang.
-   Perubahan divisi atau struktur organisasi tidak boleh diam-diam
    merusak penugasan historis.

## 7. Frontend Flutter

Halaman: - Detail Kepanitiaan. - Struktur Panitia. - Form Tambah/Edit
Penugasan. - Form Tambah/Edit Sie. - Pemilihan anggota dari data anggota
yang sudah terdaftar.

Tampilan dapat dikelompokkan: 1. Steering Committee. 2. Ketua Pelaksana.
3. Sekretaris dan Bendahara. 4. Koordinator dan anggota per sie.

## 8. Kriteria Selesai

-   Panitia terhubung dengan program kerja.
-   SC dan Ketupel dapat ditampilkan.
-   Sie dapat dibuat secara fleksibel.
-   Anggota dapat ditugaskan ke panitia.
-   Aturan kewenangan dan validasi diterapkan.
-   Flutter dapat melihat dan mengelola susunan sesuai role.
