import 'package:flutter/material.dart';

import '../features/akun/screens/account_list_screen.dart';
import '../features/auth/screens/change_password_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/dashboard/screens/admin_dashboard_screen.dart';
import '../features/dashboard/screens/anggota_dashboard_screen.dart';
import '../features/dashboard/screens/pengurus_dashboard_screen.dart';
import '../features/divisi/screens/divisi_screen.dart';
import '../features/jadwal/screens/jadwal_screen.dart';
import '../features/kegiatan/screens/kegiatan_screen.dart';
import '../features/kepanitiaan/screens/kepanitiaan_screen.dart';
import '../features/materi/screens/materi_screen.dart';
import '../features/presensi/screens/presensi_screen.dart';
import '../features/profil/screens/profil_screen.dart';
import '../features/program_kerja/screens/program_kerja_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String initial = '/';
  static const String login = '/login';
  static const String changePassword = '/change-password';
  static const String adminDashboard = '/dashboard/admin';
  static const String pengurusDashboard = '/dashboard/pengurus';
  static const String anggotaDashboard = '/dashboard/anggota';

  // Rute pintasan fitur
  static const String profil = '/profil';
  static const String divisi = '/divisi';
  static const String programKerja = '/program-kerja';
  static const String kepanitiaan = '/kepanitiaan';
  static const String kegiatan = '/kegiatan';
  static const String jadwal = '/jadwal';
  static const String materi = '/materi';
  static const String presensi = '/presensi';
  static const String adminAccounts = '/admin/accounts';

  static Map<String, WidgetBuilder> get routes => {
        login: (context) => const LoginScreen(),
        changePassword: (context) => const ChangePasswordScreen(),
        adminDashboard: (context) => const AdminDashboardScreen(),
        pengurusDashboard: (context) => const PengurusDashboardScreen(),
        anggotaDashboard: (context) => const AnggotaDashboardScreen(),
        profil: (context) => const ProfilScreen(),
        divisi: (context) => const DivisiScreen(),
        programKerja: (context) => const ProgramKerjaScreen(),
        kepanitiaan: (context) => const KepanitiaanScreen(),
        kegiatan: (context) => const KegiatanScreen(),
        jadwal: (context) => const JadwalScreen(),
        materi: (context) => const MateriScreen(),
        presensi: (context) => const PresensiScreen(),
        adminAccounts: (context) => const AccountListScreen(),
      };

  static String dashboardForRole(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return adminDashboard;
      case 'pengurus':
        return pengurusDashboard;
      default:
        return anggotaDashboard;
    }
  }
}
