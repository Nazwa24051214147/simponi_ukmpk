# Fitur Autentikasi, Pengelolaan Akun, dan Hak Akses

## 1. Tujuan

Mengatur proses masuk dan keluar aplikasi, identitas pengguna,
pengelolaan akun anggota, perubahan password, serta pembatasan fitur
berdasarkan role.

## 2. Role

-   **Admin:** Ketua Umum dan Wakil Ketua Umum.
-   **Pengurus:** Kepala Divisi dan Wakil Kepala Divisi.
-   **Anggota:** anggota/staff UKMPK.

Role sistem tidak boleh disamakan dengan jabatan struktural secara
sembarangan. Data jabatan seperti Ketum, Waketum, Kadiv, Wakadiv, dan
Staff disimpan sebagai informasi keanggotaan/posisi. Role menentukan
izin akses aplikasi.

## 3. Kebutuhan Fungsional

### Autentikasi

-   Login menggunakan email dan password.
-   Sistem memeriksa kredensial.
-   Sistem menolak akun yang tidak aktif.
-   Login menghasilkan token Sanctum.
-   Logout menghapus token aktif.
-   Endpoint profil menampilkan data pengguna, anggota, divisi, dan
    role.

### Password

-   Akun baru dibuat oleh Admin.
-   Sistem menghasilkan password sementara.
-   Akun baru diberi penanda `must_change_password = true`.
-   Saat login, respons memberi tahu apakah pengguna wajib mengganti
    password.
-   Sebelum password sementara diganti, pengguna hanya boleh mengakses
    endpoint yang diperlukan untuk mengganti password dan logout.
-   Setelah password berhasil diganti, `must_change_password` menjadi
    false.
-   Pengguna dapat mengganti password dari pengaturan akun setelah
    login.

### Pengelolaan akun oleh Admin

-   Melihat daftar akun.
-   Mencari akun berdasarkan nama, email, atau NIM.
-   Melihat detail akun.
-   Membuat akun anggota.
-   Mengubah data akun dan data anggota.
-   Mengubah role sesuai aturan.
-   Mengaktifkan atau menonaktifkan akun.
-   Sistem tidak menyediakan registrasi publik.

### Profil pribadi

-   Pengguna melihat profilnya.
-   Pengguna dapat mengubah informasi kontak yang diizinkan, misalnya
    nomor telepon.
-   Data sensitif organisasi seperti role, NIM, divisi, dan jabatan
    hanya dapat diubah Admin sesuai kebijakan.

## 4. Data Utama

### users

Data autentikasi dan status akun. Kolom yang telah diketahui dari
rancangan: - `id` - `name` - `email` (unik) - `password` (hash) -
`is_active` - `must_change_password` - timestamps

### members

Data keanggotaan yang terhubung ke users: - `id` - `user_id` (unik dan
foreign key ke users) - `nim` (unik) - `phone` (nullable) -
`division_id` - `position` - `generation` - `status` - timestamps

### roles dan pivot

Role dasar: `admin`, `pengurus`, `anggota`. Relasi user-role menggunakan
tabel pivot sesuai implementasi yang tersedia.

## 5. Aturan Bisnis dan Keamanan

-   Satu akun anggota terhubung dengan satu data member.
-   Email dan NIM tidak boleh duplikat.
-   Password harus di-hash oleh Laravel.
-   Jangan pernah menyimpan atau mengembalikan password lama.
-   Password sementara hanya ditampilkan sekali ketika akun dibuat, bila
    mekanisme tersebut digunakan.
-   Akun nonaktif tidak dapat menggunakan endpoint terlindungi.
-   Pengguna dengan `must_change_password = true` tidak dapat membuka
    fitur normal.
-   Hanya Admin yang dapat mengelola akun pengguna lain.
-   Pengguna tidak boleh mengubah role atau status akun sendiri melalui
    endpoint profil.
-   Admin tidak boleh menonaktifkan akunnya sendiri jika aturan tersebut
    sudah diterapkan.
-   Otorisasi harus berada di backend.

## 6. Alur Utama

### Login

1.  Pengguna memasukkan email dan password.
2.  Backend memvalidasi kredensial dan status akun.
3.  Backend membuat token.
4.  Respons mengembalikan data pengguna, role, token, dan status
    kewajiban ganti password.
5.  Flutter mengarahkan pengguna ke halaman ganti password jika flag
    bernilai true; jika false, pengguna masuk ke dashboard sesuai role.

### Pembuatan akun

1.  Admin mengisi data akun dan anggota.
2.  Backend memvalidasi email, NIM, divisi, dan role.
3.  Backend membuat user dan member dalam satu transaksi.
4.  Backend menghubungkan role.
5.  Sistem membuat password sementara dan mengaktifkan kewajiban ganti
    password.
6.  Admin menyampaikan kredensial sementara secara aman kepada anggota.

### Ganti password pertama kali

1.  Pengguna login dengan password sementara.
2.  Flutter menampilkan halaman wajib ganti password.
3.  Pengguna mengisi password lama, password baru, dan konfirmasi.
4.  Backend memverifikasi password lama dan validasi password baru.
5.  Backend menyimpan hash password baru dan mengubah flag menjadi
    false.
6.  Pengguna dapat mengakses fitur normal.

## 7. Gambaran Endpoint

Endpoint berikut merupakan rancangan/daftar berdasarkan implementasi
yang telah dibahas. Cocokkan dengan `routes/api.php` aktual.

  -----------------------------------------------------------------------------------------------------
  Method            Endpoint                                        Akses             Fungsi
  ----------------- ----------------------------------------------- ----------------- -----------------
  POST              `/api/login`                                    Publik            Login

  POST              `/api/logout`                                   Login aktif       Logout

  GET               `/api/user`                                     Login, password   Profil pengguna
                                                                    sudah diganti     

  POST              `/api/change-password`                          Login aktif       Ganti password

  GET               `/api/admin/accounts`                           Admin             Daftar akun

  GET               `/api/admin/accounts/{account}`                 Admin             Detail akun

  POST              `/api/admin/accounts`                           Admin             Tambah akun

  PUT               `/api/admin/accounts/{account}`                 Admin             Ubah akun

  PATCH             `/api/admin/accounts/{account}/toggle-status`   Admin             Aktif/nonaktif
                                                                                      akun
  -----------------------------------------------------------------------------------------------------

## 8. Frontend Flutter

Halaman yang diperlukan: - Login. - Wajib ganti password. - Dashboard
entry berdasarkan role. - Profil. - Pengaturan/ganti password. - Daftar
akun (Admin). - Detail akun (Admin). - Form tambah akun (Admin). - Form
edit akun (Admin).

Komponen UI: - Form input dan validasi. - Indikator loading. - Pesan
error dan sukses. - Dialog konfirmasi untuk menonaktifkan akun. -
Penyimpanan token secara aman. - Logout dan pembersihan sesi lokal.

## 9. Kriteria Selesai

-   Login, logout, dan profil dapat digunakan.
-   Akun baru dapat dibuat oleh Admin.
-   Akun baru wajib mengganti password sementara.
-   Akun nonaktif ditolak.
-   Admin dapat melihat, menambah, mengubah, dan menonaktifkan akun.
-   Role dikembalikan dan digunakan untuk menentukan navigasi.
-   Backend memblokir akses yang tidak berwenang.
-   Flutter terhubung ke API, bukan hanya menampilkan data statis.
