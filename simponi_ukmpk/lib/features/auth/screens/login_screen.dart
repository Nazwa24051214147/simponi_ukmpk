// lib/features/auth/screens/login_screen.dart
// Halaman login SIMPONI UKMPK.
// Input: email dan password.
// Alur (dari README-AUTENTIKASI-AKUN.md):
//   1. Pengguna memasukkan email dan password.
//   2. Panggil POST /api/login via AuthService.
//   3. Jika must_change_password = true → arahkan ke ChangePasswordScreen.
//   4. Jika false → arahkan ke Dashboard sesuai role.
// TODO: Implementasi form, validasi, dan navigasi.
