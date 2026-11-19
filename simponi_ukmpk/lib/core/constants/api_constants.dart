// lib/core/constants/api_constants.dart
// Konstanta URL dan path endpoint REST API Laravel SIMPONI.
//
// CATATAN BASE URL (dari README):
//   - Android emulator : http://10.0.2.2:8000  (10.0.2.2 merujuk ke localhost komputer)
//   - iOS simulator    : http://localhost:8000
//   - Device fisik     : gunakan IP komputer di jaringan yang sama, contoh http://192.168.1.x:8000
//
// Ganti nilai [baseUrl] sesuai environment yang digunakan.

class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://127.0.0.1:8000';

  // --- Autentikasi ---
  static const String login = '/api/login';
  static const String logout = '/api/logout';
  static const String user = '/api/user';
  static const String changePassword = '/api/change-password';

  // --- Akun / Anggota ---
  static const String accounts = '/api/accounts';
  static const String adminAccounts = '/api/admin/accounts';
  static String adminAccountDetail(dynamic id) => '/api/admin/accounts/$id';
  static String adminAccountToggleStatus(dynamic id) =>
      '/api/admin/accounts/$id/toggle-status';

  // --- Divisi ---
  static const String divisions = '/api/divisions';
  static String divisionDetail(dynamic id) => '/api/divisions/$id';
  static const String adminDivisions = '/api/admin/divisions';
  static String adminDivisionDetail(dynamic id) => '/api/admin/divisions/$id';

  // --- Program Kerja ---
  static const String programs = '/api/programs';
  static String programDetail(dynamic id) => '/api/programs/$id';
  static String programStatus(dynamic id) => '/api/programs/$id/status';
}
