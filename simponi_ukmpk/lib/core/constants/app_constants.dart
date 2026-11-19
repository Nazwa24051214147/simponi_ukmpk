// lib/core/constants/app_constants.dart
// Konstanta umum aplikasi SIMPONI UKMPK.

class AppConstants {
  AppConstants._();

  static const String appName = 'SIMPONI UKMPK';
  static const String appTagline = 'UKM Peduli Kemanusiaan UNESA';
  static const String appMotto = 'Together We Care';

  // Key untuk menyimpan token di flutter_secure_storage
  static const String tokenKey = 'simponi_auth_token';

  // Nama role (harus cocok dengan nilai di tabel roles backend)
  static const String roleAdmin = 'admin';
  static const String rolePengurus = 'pengurus';
  static const String roleAnggota = 'anggota';
}
