import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../data/services/dashboard_service.dart';
import '../../auth/providers/auth_provider.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/quick_menu_grid.dart';
import '../widgets/section_title.dart';
import '../widgets/summary_card.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final DashboardService _dashboardService = DashboardService();
  bool _isLoadingStats = true;
  AdminDashboardStats _stats = AdminDashboardStats.empty();

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoadingStats = true);
    final stats = await _dashboardService.getAdminStats();
    if (mounted) {
      setState(() {
        _stats = stats;
        _isLoadingStats = false;
      });
    }
  }

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

    final quickMenuItems = [
      QuickMenuItem(
        title: 'Kelola Akun',
        icon: Icons.manage_accounts_outlined,
        color: AppTheme.deepNavy,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.adminAccounts),
      ),
      QuickMenuItem(
        title: 'Program Kerja',
        icon: Icons.assignment_outlined,
        color: AppTheme.teal,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.programKerja),
      ),
      QuickMenuItem(
        title: 'Divisi UKM',
        icon: Icons.groups_outlined,
        color: AppTheme.deepNavy,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.divisi),
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
        title: 'Presensi',
        icon: Icons.qr_code_scanner_outlined,
        color: AppTheme.softTerracotta,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.presensi),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
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
          await Future.wait([
            _loadStats(),
            auth.init(),
          ]);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Profil & Role
              DashboardHeader(
                user: user,
                roleBadgeText: 'ADMIN',
                roleBadgeColor: AppTheme.warmYellow,
                onProfileTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.profil),
              ),
              const SizedBox(height: 20),

              // Ringkasan Organisasi (KPI Cards)
              const SectionTitle(title: 'Ringkasan Organisasi'),
              Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      title: 'Total Anggota',
                      value: _isLoadingStats
                          ? '...'
                          : '${_stats.totalAccounts}',
                      icon: Icons.people_outline,
                      color: AppTheme.deepNavy,
                      subtitle: 'Akun terdaftar',
                      onTap: () => Navigator.of(context)
                          .pushNamed(AppRoutes.adminAccounts),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SummaryCard(
                      title: 'Akun Aktif',
                      value: _isLoadingStats
                          ? '...'
                          : '${_stats.activeAccounts}',
                      icon: Icons.check_circle_outline,
                      color: AppTheme.teal,
                      subtitle: 'Dapat login',
                      onTap: () => Navigator.of(context)
                          .pushNamed(AppRoutes.adminAccounts),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      title: 'Divisi UKMPK',
                      value: '5',
                      icon: Icons.apartment_outlined,
                      color: AppTheme.deepNavy,
                      subtitle: 'Struktur divisi',
                      onTap: () =>
                          Navigator.of(context).pushNamed(AppRoutes.divisi),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SummaryCard(
                      title: 'Program Kerja',
                      value: '0',
                      icon: Icons.task_alt_outlined,
                      color: AppTheme.softTerracotta,
                      subtitle: 'Belum terdaftar',
                      onTap: () => Navigator.of(context)
                          .pushNamed(AppRoutes.programKerja),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Menu Pintasan Fitur
              const SectionTitle(title: 'Pintasan Menu'),
              QuickMenuGrid(items: quickMenuItems),
              const SizedBox(height: 24),

              // Akun Anggota Terbaru
              SectionTitle(
                title: 'Akun Anggota Terbaru',
                actionText: 'Kelola Semua',
                onActionTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.adminAccounts),
              ),
              if (_stats.recentAccounts.isNotEmpty) ...[
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _stats.recentAccounts.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, idx) {
                      final acc = _stats.recentAccounts[idx];
                      final name = acc['name']?.toString() ?? '-';
                      final email = acc['email']?.toString() ?? '-';
                      final isActive = acc['is_active'] == true;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              isActive ? AppTheme.teal : Colors.grey,
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : 'A',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.deepNavy,
                          ),
                        ),
                        subtitle: Text(
                          email,
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.green.shade50
                                : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isActive ? 'Aktif' : 'Nonaktif',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isActive
                                  ? Colors.green.shade700
                                  : Colors.red.shade700,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ] else ...[
                const Card(
                  elevation: 1,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: EmptyStateWidget(
                      message: 'Belum ada data akun anggota.',
                      icon: Icons.people_outline,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),

              // Agenda Organisasi Terdekat
              const SectionTitle(title: 'Agenda Terdekat'),
              const Card(
                elevation: 1,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: EmptyStateWidget(
                    message:
                        'Belum ada agenda organisasi yang dijadwalkan.',
                    icon: Icons.event_note_outlined,
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
