import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../data/services/account_service.dart';
import '../../auth/providers/auth_provider.dart';
import 'account_form_screen.dart';

class AccountDetailScreen extends StatefulWidget {
  final int accountId;
  final Map<String, dynamic>? initialData;

  const AccountDetailScreen({
    super.key,
    required this.accountId,
    this.initialData,
  });

  @override
  State<AccountDetailScreen> createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends State<AccountDetailScreen> {
  final AccountService _accountService = AccountService();

  Map<String, dynamic>? _account;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isTogglingStatus = false;

  @override
  void initState() {
    super.initState();
    _account = widget.initialData;
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _isLoading = _account == null;
      _errorMessage = null;
    });

    try {
      final data = await _accountService.getAccountDetail(widget.accountId);
      if (mounted) {
        setState(() {
          _account = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleToggleStatus(bool currentStatus) async {
    final actionText = currentStatus ? 'menonaktifkan' : 'mengaktifkan';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${currentStatus ? "Nonaktifkan" : "Aktifkan"} Akun?'),
        content: Text(
          'Apakah Anda yakin ingin $actionText akun ${_account?["name"] ?? "anggota"}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: currentStatus ? AppTheme.softTerracotta : AppTheme.teal,
            ),
            child: Text(currentStatus ? 'Nonaktifkan' : 'Aktifkan'),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    setState(() => _isTogglingStatus = true);

    try {
      final res = await _accountService.toggleStatus(widget.accountId);
      if (!mounted) return;

      final msg = res['message']?.toString() ?? 'Status akun berhasil diubah.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: AppTheme.teal,
        ),
      );
      _fetchDetail();
    } catch (e) {
      if (!mounted) return;
      final error = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: AppTheme.softTerracotta,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isTogglingStatus = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final currentUserId = auth.user?.id;
    final isAdmin = auth.user?.isAdmin ?? false;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Akun Anggota')),
        body: const LoadingIndicator(message: 'Memuat detail akun...'),
      );
    }

    if (_errorMessage != null && _account == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Akun Anggota')),
        body: ErrorStateWidget(
          message: _errorMessage!,
          onRetry: _fetchDetail,
        ),
      );
    }

    final acc = _account!;
    final name = acc['name']?.toString() ?? '-';
    final email = acc['email']?.toString() ?? '-';
    final isActive = acc['is_active'] == true || acc['is_active'] == 1;
    final mustChangePassword = acc['must_change_password'] == true || acc['must_change_password'] == 1;
    final member = acc['member'] as Map<String, dynamic>?;
    final nim = member?['nim']?.toString() ?? '-';
    final division = member?['division'] as Map<String, dynamic>?;
    final divisionName = division?['name']?.toString() ?? '-';
    final position = member?['position']?.toString() ?? '-';
    final generation = member?['generation']?.toString() ?? '-';
    final phone = member?['phone']?.toString() ?? '-';
    final memberStatus = member?['status']?.toString() ?? '-';
    final isOwnAccount = currentUserId != null && currentUserId == acc['id'];

    final roles = (acc['roles'] as List<dynamic>?)
            ?.map((r) => r is Map ? r['name']?.toString() : r.toString())
            .whereType<String>()
            .toList() ??
        ['anggota'];
    final roleString = roles.join(', ').toUpperCase();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Akun Anggota'),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Ubah Data Akun',
              onPressed: () async {
                final updated = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (_) => AccountFormScreen(account: acc),
                  ),
                );
                if (updated == true && mounted) {
                  _fetchDetail();
                }
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Kartu Ringkasan Atas
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: isActive ? AppTheme.teal : Colors.grey,
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : 'A',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.deepNavy,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF666666),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppTheme.warmYellow,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  roleString,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.deepNavy,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isActive ? Colors.green.shade100 : Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  isActive ? 'AKUN AKTIF' : 'NONAKTIF',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isActive ? Colors.green.shade800 : Colors.red.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Kartu Data Keanggotaan
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Data Keanggotaan UKMPK',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.deepNavy,
                      ),
                    ),
                    const Divider(height: 20),
                    _buildInfoRow('NIM Mahasiswa', nim),
                    _buildInfoRow('Divisi Organisasi', divisionName),
                    _buildInfoRow('Jabatan / Penugasan', position),
                    _buildInfoRow('Angkatan', generation),
                    _buildInfoRow('No. Telepon / WhatsApp', phone),
                    _buildInfoRow('Status Keanggotaan', memberStatus),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Kartu Informasi Sistem & Keamanan
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Sistem & Akses',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.deepNavy,
                      ),
                    ),
                    const Divider(height: 20),
                    _buildInfoRow('Wajib Ganti Password', mustChangePassword ? 'Ya (Password Sementara)' : 'Tidak'),
                    _buildInfoRow('ID Pengguna Sistem', '${acc["id"]}'),
                    if (isOwnAccount)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Catatan: Ini adalah akun login Anda saat ini.',
                          style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppTheme.teal),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Aksi (Khusus Admin)
            if (isAdmin) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Ubah Data'),
                      onPressed: () async {
                        final updated = await Navigator.of(context).push<bool>(
                          MaterialPageRoute(
                            builder: (_) => AccountFormScreen(account: acc),
                          ),
                        );
                        if (updated == true && mounted) {
                          _fetchDetail();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(
                        isActive ? Icons.person_off_outlined : Icons.person_outline,
                        size: 18,
                      ),
                      label: Text(isActive ? 'Nonaktifkan' : 'Aktifkan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isActive ? AppTheme.softTerracotta : Colors.green.shade700,
                      ),
                      onPressed: (_isTogglingStatus || isOwnAccount)
                          ? null
                          : () => _handleToggleStatus(isActive),
                    ),
                  ),
                ],
              ),
              if (isOwnAccount) ...[
                const SizedBox(height: 8),
                const Text(
                  'Admin tidak dapat menonaktifkan akun sendiri.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: AppTheme.softTerracotta),
                ),
              ],
            ] else ...[
              const Center(
                child: Text(
                  'Hanya Admin yang memiliki kewenangan mengubah data dan status akun anggota.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Color(0xFF777777)),
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.deepNavy,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
