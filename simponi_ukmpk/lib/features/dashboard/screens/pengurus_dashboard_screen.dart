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

class PengurusDashboardScreen extends StatelessWidget {
  const PengurusDashboardScreen({super.key});

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
    final divisionName = user?.member?.divisionName ?? 'Divisi UKMPK';
    final position = user?.member?.position ?? 'Pengurus Divisi';

    final quickMenuItems = [
      QuickMenuItem(
        title: 'Proker Divisi',
        icon: Icons.assignment_outlined,
        color: AppTheme.deepNavy,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.programKerja),
      ),
      QuickMenuItem(
        title: 'Kepanitiaan',
        icon: Icons.badge_outlined,
        color: AppTheme.teal,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.kepanitiaan),
      ),
      QuickMenuItem(
        title: 'Kegiatan UKM',
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
        title: 'Materi & Dokumen',
        icon: Icons.folder_shared_outlined,
        color: AppTheme.deepNavy,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.materi),
      ),
      QuickMenuItem(
        title: 'Presensi',
        icon: Icons.qr_code_scanner_outlined,
        color: AppTheme.softTerracotta,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.presensi),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Pengurus'),
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
              // Header Profil Pengurus
              DashboardHeader(
                user: user,
                roleBadgeText: 'PENGURUS',
                roleBadgeColor: AppTheme.teal,
                onProfileTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.profil),
              ),
              const SizedBox(height: 20),

              // Fokus Divisi & Tanggung Jawab
              const SectionTitle(title: 'Tanggung Jawab Divisi'),
              Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      title: 'Divisi Saya',
                      value: divisionName,
                      icon: Icons.apartment_outlined,
                      color: AppTheme.deepNavy,
                      subtitle: position,
                      onTap: () =>
                          Navigator.of(context).pushNamed(AppRoutes.divisi),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SummaryCard(
                      title: 'Program Kerja',
                      value: '0 Aktif',
                      icon: Icons.task_alt_outlined,
                      color: AppTheme.teal,
                      subtitle: 'Divisi $divisionName',
                      onTap: () => Navigator.of(context)
                          .pushNamed(AppRoutes.programKerja),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      title: 'Kepanitiaan',
                      value: '0 Panitia',
                      icon: Icons.badge_outlined,
                      color: AppTheme.deepNavy,
                      subtitle: 'Proker terkait',
                      onTap: () => Navigator.of(context)
                          .pushNamed(AppRoutes.kepanitiaan),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SummaryCard(
                      title: 'Dokumen Divisi',
                      value: '0 File',
                      icon: Icons.description_outlined,
                      color: AppTheme.softTerracotta,
                      subtitle: 'Arsip divisi',
                      onTap: () =>
                          Navigator.of(context).pushNamed(AppRoutes.materi),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Pintasan Menu Pengurus
              const SectionTitle(title: 'Pintasan Menu Pengurus'),
              QuickMenuGrid(items: quickMenuItems),
              const SizedBox(height: 24),

              // Agenda Terdekat Divisi
              const SectionTitle(title: 'Agenda Terdekat Divisi'),
              const Card(
                elevation: 1,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: EmptyStateWidget(
                    message:
                        'Belum ada agenda divisi yang dijadwalkan.',
                    icon: Icons.calendar_today_outlined,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Tugas & Tindak Lanjut
              const SectionTitle(title: 'Tindak Lanjut & Dokumen'),
              const Card(
                elevation: 1,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: EmptyStateWidget(
                    message:
                        'Tidak ada tugas kepanitiaan atau dokumen yang menunggu tindak lanjut.',
                    icon: Icons.checklist_outlined,
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
