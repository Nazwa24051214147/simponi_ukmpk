import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../auth/providers/auth_provider.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/quick_menu_grid.dart';
import '../widgets/section_title.dart';
import '../widgets/summary_card.dart';

class AnggotaDashboardScreen extends StatelessWidget {
  const AnggotaDashboardScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari Akun?'),
        content: const Text('Apakah Anda yakin ingin logout dari SIMPONI?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.softTerracotta,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await context.read<AuthProvider>().logout();
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final member = user?.member;
    final divisionName = member?.divisionName ?? 'UKMPK UNESA';

    final quickMenuItems = [
      QuickMenuItem(
        title: 'Presensi',
        icon: Icons.qr_code_scanner_outlined,
        color: AppTheme.softTerracotta,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.presensi),
      ),
      QuickMenuItem(
        title: 'Kegiatan',
        icon: Icons.event_available_outlined,
        color: AppTheme.deepNavy,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.kegiatan),
      ),
      QuickMenuItem(
        title: 'Jadwal Agenda',
        icon: Icons.calendar_month_outlined,
        color: AppTheme.teal,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.jadwal),
      ),
      QuickMenuItem(
        title: 'Materi/Dokumen',
        icon: Icons.folder_shared_outlined,
        color: AppTheme.deepNavy,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.materi),
      ),
      QuickMenuItem(
        title: 'Informasi Divisi',
        icon: Icons.groups_outlined,
        color: AppTheme.teal,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.divisi),
      ),
      QuickMenuItem(
        title: 'Profil Saya',
        icon: Icons.person_outline,
        color: AppTheme.deepNavy,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.profil),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('SIMPONI UKMPK'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Profil Saya',
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.profil),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await auth.init();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Profil Anggota
              DashboardHeader(
                user: user,
                roleBadgeText: 'ANGGOTA',
                roleBadgeColor: AppTheme.teal,
                onProfileTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.profil),
              ),
              const SizedBox(height: 20),

              // Status Keanggotaan & Kehadiran
              const SectionTitle(title: 'Status Keanggotaan'),
              Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      title: 'Status Anggota',
                      value: member?.status ?? 'Active',
                      icon: Icons.verified_user_outlined,
                      color: AppTheme.teal,
                      subtitle: 'UKMPK UNESA',
                      onTap: () =>
                          Navigator.of(context).pushNamed(AppRoutes.profil),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SummaryCard(
                      title: 'Divisi',
                      value: divisionName,
                      icon: Icons.apartment_outlined,
                      color: AppTheme.deepNavy,
                      subtitle: member?.position ?? 'Anggota',
                      onTap: () =>
                          Navigator.of(context).pushNamed(AppRoutes.divisi),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      title: 'Kegiatan Diikuti',
                      value: '0',
                      icon: Icons.event_available_outlined,
                      color: AppTheme.deepNavy,
                      subtitle: 'Peserta & Panitia',
                      onTap: () =>
                          Navigator.of(context).pushNamed(AppRoutes.kegiatan),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SummaryCard(
                      title: 'Presensi',
                      value: '0 Hadir',
                      icon: Icons.how_to_reg_outlined,
                      color: AppTheme.softTerracotta,
                      subtitle: 'Kehadiran agenda',
                      onTap: () =>
                          Navigator.of(context).pushNamed(AppRoutes.presensi),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Akses Cepat Menu
              const SectionTitle(title: 'Akses Cepat'),
              QuickMenuGrid(items: quickMenuItems),
              const SizedBox(height: 24),

              // Agenda Terdekat
              const SectionTitle(title: 'Agenda Terdekat'),
              const Card(
                elevation: 1,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: EmptyStateWidget(
                    message:
                        'Belum ada kegiatan atau agenda yang dijadwalkan.',
                    icon: Icons.event_busy_outlined,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Kegiatan yang Diikuti
              const SectionTitle(title: 'Kegiatan yang Anda Ikuti'),
              const Card(
                elevation: 1,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: EmptyStateWidget(
                    message:
                        'Anda belum mendaftar kegiatan atau kepanitiaan.',
                    icon: Icons.assignment_late_outlined,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
