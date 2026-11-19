# Fitur Presensi

## 1. Tujuan

Mencatat kehadiran anggota pada sesi kegiatan UKMPK secara terstruktur
dan memudahkan panitia memantau daftar hadir.

## 2. Metode Presensi

Metode utama yang direncanakan adalah QR Code atau kode presensi yang
dibuat untuk satu sesi kegiatan. Sediakan alternatif pencatatan manual
oleh petugas/panitia yang berwenang.

QR/kode harus terkait dengan sesi presensi tertentu, bukan satu kode
permanen untuk seluruh kegiatan.

## 3. Kebutuhan Fungsional

-   Pengurus/Ketupel membuat sesi presensi.
-   Sistem menghasilkan QR/kode untuk sesi tersebut.
-   Anggota melakukan scan atau memasukkan kode.
-   Backend memvalidasi keanggotaan, sesi, waktu, dan status presensi.
-   Sistem mencatat waktu presensi.
-   Panitia dapat melihat daftar hadir.
-   Panitia dapat melakukan pencatatan manual jika diperlukan.
-   Panitia dapat menyelesaikan/finalisasi presensi.
-   Rekap kehadiran dapat dilihat sesuai kewenangan.

## 4. Status Kehadiran

Status yang direncanakan: - Hadir. - Izin. - Sakit. - Alpha.

Catatan: sistem tidak harus menyediakan pengajuan izin di dalam aplikasi
pada versi awal. Jika anggota tidak melakukan scan, status akhirnya
dapat ditentukan secara manual oleh petugas sesuai prosedur organisasi.
Status akhir harus dapat diperbarui oleh pengguna berwenang
sebelum/finalisasi sesuai kebijakan.

## 5. Aturan Bisnis

-   Satu anggota hanya memiliki satu catatan presensi per sesi.
-   QR/kode hanya berlaku untuk sesi yang sesuai.
-   Kode dapat dibatasi masa aktifnya.
-   Kode tidak boleh dapat digunakan untuk mencatat kehadiran anggota
    lain.
-   Presensi ditolak jika sesi belum dibuka atau sudah ditutup.
-   Pencatatan manual hanya boleh dilakukan oleh panitia/petugas
    berwenang.
-   Perubahan status kehadiran harus tercatat dengan konsisten.
-   Rekap tidak boleh menghitung satu anggota lebih dari sekali pada
    sesi yang sama.

## 6. Relasi Data

-   Kegiatan dapat memiliki satu atau beberapa sesi presensi.
-   Sesi presensi memiliki kode/QR.
-   Catatan presensi terhubung ke sesi dan member.
-   Presensi harus merujuk ke data anggota yang sudah ada.

## 7. Frontend Flutter

Halaman: - Detail sesi presensi. - Scanner QR. - Input kode
alternatif. - Hasil presensi anggota. - Daftar hadir untuk panitia. -
Form presensi manual. - Rekap presensi.

## 8. Keamanan

-   Token login wajib untuk presensi.
-   Validasi akhir dilakukan backend.
-   Jangan mempercayai data member ID yang dikirim bebas dari frontend;
    identitas anggota diambil dari pengguna yang sedang login.
-   Kode QR tidak boleh berisi informasi sensitif.
-   Cegah presensi ganda dengan validasi aplikasi dan constraint
    database.
-   Akses rekap dibatasi sesuai role dan penugasan.

## 9. Kriteria Selesai

-   Panitia dapat membuat sesi dan QR/kode.
-   Anggota dapat melakukan presensi.
-   Presensi ganda dicegah.
-   Pencatatan manual tersedia.
-   Status Hadir/Izin/Sakit/Alpha dapat dikelola.
-   Rekap kehadiran dapat ditampilkan.
-   Flutter terhubung ke API presensi.
