# Fitur Divisi

## 1. Tujuan

Menyediakan informasi divisi UKMPK dan struktur keanggotaan setiap
divisi. Fitur ini menjadi dasar pengelompokan anggota dan pembatasan
kewenangan Pengurus.

## 2. Pengguna dan Hak Akses

  Aktivitas                  Admin   Pengurus   Anggota
  ------------------------ ------- ---------- ---------
  Melihat daftar divisi         Ya         Ya        Ya
  Melihat detail divisi         Ya         Ya        Ya
  Menambah divisi               Ya      Tidak     Tidak
  Mengubah divisi               Ya      Tidak     Tidak
  Menghapus divisi              Ya      Tidak     Tidak
  Melihat anggota divisi        Ya         Ya        Ya

Pengurus hanya dapat mengelola data divisi jika aturan khusus memang
memberikan kewenangan tersebut. Default pengelolaan data divisi adalah
Admin.

## 3. Informasi Divisi

Setiap divisi sekurang-kurangnya memiliki: - Nama divisi. - Deskripsi. -
Daftar pengurus. - Daftar anggota/staff. - Jumlah anggota.

Struktur pengurus dapat menampilkan: - Kepala Divisi. - Wakil Kepala
Divisi. - Staff/anggota.

Jabatan struktural harus berasal dari data keanggotaan, bukan diketik
sebagai data dummy permanen.

## 4. Kebutuhan Fungsional

### Daftar divisi

-   Menampilkan seluruh divisi.
-   Menampilkan nama dan deskripsi singkat.
-   Menampilkan jumlah anggota jika datanya tersedia.
-   Menyediakan pencarian sederhana bila diperlukan.

### Detail divisi

-   Menampilkan identitas dan deskripsi divisi.
-   Menampilkan Kepala Divisi dan Wakil Kepala Divisi.
-   Menampilkan daftar anggota.
-   Menampilkan jumlah anggota.
-   Menyediakan navigasi ke detail anggota jika halaman anggota
    tersedia.

### Pengelolaan divisi oleh Admin

-   Menambah divisi.
-   Mengubah nama dan deskripsi.
-   Menghapus divisi dengan pemeriksaan relasi.
-   Divisi yang masih digunakan oleh data anggota atau program kerja
    tidak boleh dihapus sembarangan.

## 5. Relasi Data

-   `members.division_id` terhubung ke `divisions.id`.
-   Satu divisi memiliki banyak member.
-   Data program kerja dapat memiliki relasi ke divisi
    penyelenggara/penanggung jawab sesuai rancangan fitur program kerja.
-   Jangan membuat tabel anggota divisi baru jika relasi
    `members.division_id` sudah memenuhi kebutuhan.

## 6. Frontend Flutter

Halaman: 1. Daftar Divisi. 2. Detail Divisi. 3. Form Tambah Divisi
(Admin). 4. Form Edit Divisi (Admin).

Detail divisi disarankan memiliki: - Header nama dan deskripsi. - Bagian
Pengurus. - Bagian Anggota. - Jumlah anggota. - Empty state jika belum
ada anggota.

## 7. Aturan Teknis

-   Validasi nama divisi wajib diisi dan memiliki batas panjang.
-   Nama divisi sebaiknya unik.
-   Gunakan pagination jika jumlah data bertambah.
-   Backend memeriksa role Admin untuk operasi create, update, dan
    delete.
-   Jangan menghapus divisi yang masih dipakai tanpa strategi pemindahan
    atau penanganan relasi.
-   Data yang ditampilkan Flutter harus berasal dari API.

## 8. Gambaran Endpoint

Rancangan endpoint: - `GET /api/divisions` -
`GET /api/divisions/{division}` - `POST /api/admin/divisions` -
`PUT /api/admin/divisions/{division}` -
`DELETE /api/admin/divisions/{division}`

Sesuaikan prefix dan pola route dengan struktur Laravel yang sudah ada.

## 9. Kriteria Selesai

-   Semua role dapat melihat daftar dan detail divisi.
-   Admin dapat menambah dan mengubah divisi.
-   Penghapusan divisi aman terhadap relasi.
-   Detail divisi menampilkan pengurus dan anggota.
-   Data anggota menggunakan relasi divisi yang sama dengan modul akun.
-   Flutter terhubung ke API.
