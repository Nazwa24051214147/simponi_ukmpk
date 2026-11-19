import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../data/models/division_model.dart';
import '../../../data/services/division_service.dart';
import '../../auth/providers/auth_provider.dart';
import 'divisi_form_screen.dart';

class DivisiDetailScreen extends StatefulWidget {
  final int divisionId;
  final String? initialName;

  const DivisiDetailScreen({
    super.key,
    required this.divisionId,
    this.initialName,
  });

  @override
  State<DivisiDetailScreen> createState() => _DivisiDetailScreenState();
}

class _DivisiDetailScreenState extends State<DivisiDetailScreen> {
  final DivisionService _divisionService = DivisionService();

  DivisionModel? _division;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _isLoading = _division == null;
      _errorMessage = null;
    });

    try {
      final div = await _divisionService.getDivisionDetail(widget.divisionId);
      if (mounted) {
        setState(() {
          _division = div;
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

  Future<void> _handleDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Divisi?'),
        content: Text(
          'Apakah Anda yakin ingin menghapus divisi "${_division?.name}"? '
          'Divisi hanya dapat dihapus jika tidak memiliki anggota atau program kerja terkait.',
        ),
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
            child: const Text('Hapus Divisi'),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    setState(() => _isDeleting = true);

    try {
      await _divisionService.deleteDivision(widget.divisionId);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Divisi berhasil dihapus.'),
          backgroundColor: AppTheme.teal,
        ),
      );
      Navigator.of(context).pop(true);
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
        setState(() => _isDeleting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isAdmin = auth.user?.isAdmin ?? false;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.initialName ?? 'Detail Divisi')),
        body: const LoadingIndicator(message: 'Memuat data divisi...'),
      );
    }

    if (_errorMessage != null && _division == null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.initialName ?? 'Detail Divisi')),
        body: ErrorStateWidget(
          message: _errorMessage!,
          onRetry: _fetchDetail,
        ),
      );
    }

    final div = _division!;
    final pengurusList = div.members.where((m) => m.isPengurus).toList();
    final staffList = div.members.where((m) => !m.isPengurus).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(div.name),
        actions: [
          if (isAdmin) ...[
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Ubah Divisi',
              onPressed: () async {
                final updated = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (_) => DivisiFormScreen(division: div),
                  ),
                );
                if (updated == true && mounted) {
                  _fetchDetail();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Hapus Divisi',
              onPressed: _isDeleting ? null : _handleDelete,
            ),
          ],
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchDetail,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Kartu Divisi
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.teal.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.apartment_rounded,
                              color: AppTheme.teal,
                              size: 32,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.warmYellow.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppTheme.warmYellow,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.people_alt_outlined,
                                  size: 14,
                                  color: AppTheme.deepNavy,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${div.membersCount} Anggota',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.deepNavy,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        div.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.deepNavy,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        div.description?.isNotEmpty == true
                            ? div.description!
                            : 'Belum ada deskripsi untuk divisi ini.',
                        style: TextStyle(
                          fontSize: 13,
                          color: div.description?.isNotEmpty == true
                              ? const Color(0xFF555555)
                              : const Color(0xFF999999),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Bagian Struktur Pengurus Divisi
              const Text(
                'Struktur Pengurus Divisi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.deepNavy,
                ),
              ),
              const SizedBox(height: 8),
              if (pengurusList.isNotEmpty) ...[
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pengurusList.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = pengurusList[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.deepNavy,
                          child: Text(
                            item.userName.isNotEmpty
                                ? item.userName[0].toUpperCase()
                                : 'P',
                            style: const TextStyle(
                              color: AppTheme.warmYellow,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          item.userName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.deepNavy,
                          ),
                        ),
                        subtitle: Text(
                          '${item.nim} • ${item.userEmail}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.teal.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item.position,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.teal,
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
                      message: 'Belum ada data pengurus di divisi ini.',
                      icon: Icons.person_search_outlined,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),

              // Bagian Anggota / Staff Divisi
              const Text(
                'Daftar Anggota / Staff Divisi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.deepNavy,
                ),
              ),
              const SizedBox(height: 8),
              if (staffList.isNotEmpty) ...[
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: staffList.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = staffList[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.teal,
                          child: Text(
                            item.userName.isNotEmpty
                                ? item.userName[0].toUpperCase()
                                : 'A',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          item.userName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.deepNavy,
                          ),
                        ),
                        subtitle: Text(
                          'NIM: ${item.nim} • Angkatan ${item.generation}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: Text(
                          item.position,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF666666),
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
                      message: 'Belum ada anggota staf di divisi ini.',
                      icon: Icons.groups_outlined,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
