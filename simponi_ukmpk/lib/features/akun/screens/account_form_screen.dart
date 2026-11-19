// lib/features/akun/screens/account_form_screen.dart
// Form tambah dan edit akun — hanya dapat diakses oleh Admin.
// Digunakan untuk:
//   - Membuat akun baru (POST /api/admin/accounts)
//   - Mengubah akun yang ada (PUT /api/admin/accounts/{account})
// Data yang diisi: nama, email, NIM, divisi, jabatan, role, generasi, status.
// Akun baru otomatis mendapat password sementara dan must_change_password = true.
// TODO: Implementasi form, validasi, dan submit ke API.
