import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/loading_indicator.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/auth/screens/change_password_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/dashboard/screens/admin_dashboard_screen.dart';
import '../features/dashboard/screens/anggota_dashboard_screen.dart';
import '../features/dashboard/screens/pengurus_dashboard_screen.dart';
import 'routes.dart';

class SimponiApp extends StatelessWidget {
  const SimponiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      routes: AppRoutes.routes,
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (!auth.isInitialized) {
      return const Scaffold(
        backgroundColor: AppTheme.warmIvory,
        body: LoadingIndicator(message: 'Memuat sesi SIMPONI...'),
      );
    }

    if (!auth.isAuthenticated) {
      return const LoginScreen();
    }

    if (auth.mustChangePassword) {
      return const ChangePasswordScreen(isMandatory: true);
    }

    final role = auth.user?.primaryRole ?? AppConstants.roleAnggota;
    switch (role) {
      case AppConstants.roleAdmin:
        return const AdminDashboardScreen();
      case AppConstants.rolePengurus:
        return const PengurusDashboardScreen();
      default:
        return const AnggotaDashboardScreen();
    }
  }
}
