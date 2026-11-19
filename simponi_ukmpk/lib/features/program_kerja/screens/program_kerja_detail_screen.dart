import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../data/models/program_model.dart';
import '../../../data/services/program_service.dart';
import '../../auth/providers/auth_provider.dart';
import 'program_kerja_form_screen.dart';

class ProgramKerjaDetailScreen extends StatefulWidget {
  final int programId;
  final String? initialName;

  const ProgramKerjaDetailScreen({
    super.key,
    required this.programId,
    this.initialName,
  });

  @override
  State<ProgramKerjaDetailScreen> createState() =>
      _ProgramKerjaDetailScreenState();
}

class _ProgramKerjaDetailScreenState extends State<ProgramKerjaDetailScreen> {
  final ProgramService _programService = ProgramService();

  ProgramModel? _program;
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
      _isLoading = _program == null;
      _errorMessage = null;
    });

    try {
      final p = await _programService.getProgramDetail(widget.programId);
      if (mounted) {
        setState(() {
          _program = p;
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

  Future<void> _handleUpdateStatus() async {
    final currentStatus = _program?.status ?? 'Planned';
    final statuses = [
      {'code': 'Planned', 'label': 'Perencanaan (Planned)'},
      {'code': 'Preparation', 'label': 'Persiapan (Preparation)'},
      {'code': 'Ongoing', 'label': 'Berlangsung (Ongoing)'},
      {'code': 'Completed', 'label': 'Selesai (Completed)'},
      {'code': 'Cancelled', 'label': 'Dibatalkan (Cancelled)'},
    ];

    final selected = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Ubah Status Program Kerja'),
        children: statuses.map((st) {
          final isCurrent = st['code'] == currentStatus;
          return SimpleDialogOption(
            onPressed: () => Navigator.of(ctx).pop(st['code']),
            child: Row(
              children: [
                Icon(
                  isCurrent
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: isCurrent ? AppTheme.teal : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  st['label']!,
                  style: TextStyle(
                    fontWeight:
                        isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isCurrent ? AppTheme.deepNavy : null,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );

    if (selected != null && selected != currentStatus && mounted) {
      try {
        await _programService.updateProgramStatus(widget.programId, selected);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Status program kerja berhasil diubah.'),
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
      }
    }
  }

  Future<void> _handleDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Program Kerja?'),
        content: Text(
          'Apakah Anda yakin ingin menghapus "${_program?.name}"? '
          'Program kerja yang sudah memiliki susunan panitia, peserta, atau jadwal kegiatan tidak dapat dihapus.',
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
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    setState(() => _isDeleting = true);

    try {
      await _programService.deleteProgram(widget.programId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Program kerja berhasil dihapus.'),
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
    final user = auth.user;
    final isAdmin = user?.isAdmin ?? false;
    final isPengurus = user?.isPengurus ?? false;
    final userDivisionId = user?.member?.divisionId;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.initialName ?? 'Detail Program Kerja')),
        body: const LoadingIndicator(message: 'Memuat data program kerja...'),
      );
    }

    if (_errorMessage != null && _program == null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.initialName ?? 'Detail Program Kerja')),
        body: ErrorStateWidget(
          message: _errorMessage!,
          onRetry: _fetchDetail,
        ),
      );
    }

    final p = _program!;
    final canManage = isAdmin || (isPengurus && userDivisionId == p.divisionId);

    return Scaffold(
      appBar: AppBar(
        title: Text(p.name),
        actions: [
          if (canManage) ...[
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Ubah Data Proker',
              onPressed: () async {
                final updated = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (_) => ProgramKerjaFormScreen(program: p),
                  ),
                );
                if (updated == true && mounted) {
                  _fetchDetail();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Hapus Proker',
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
              // Header Card
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.teal.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              p.divisionName.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.teal,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: p.statusColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: p.statusColor, width: 0.8),
                            ),
                            child: Text(
                              p.statusLabel.toUpperCase(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: p.statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        p.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.deepNavy,
                        ),
                      ),
                      if (p.description?.isNotEmpty == true) ...[
                        const SizedBox(height: 8),
                        Text(
                          p.description!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF555555),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Kartu Detail Pelaksanaan
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rincian Pelaksanaan',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.deepNavy,
                        ),
                      ),
                      const Divider(height: 20),
                      _buildInfoRow(
                        'Divisi Penyelenggara',
                        p.divisionName,
                        Icons.apartment_outlined,
                      ),
                      _buildInfoRow(
                        'Ketua Pelaksana (PIC)',
                        p.picName != null
                            ? (p.picNim != null && p.picNim!.isNotEmpty
                                ? '${p.picName} (${p.picNim})'
                                : p.picName!)
                            : 'Belum ditentukan',
                        Icons.person_pin_outlined,
                      ),
                      _buildInfoRow(
                        'Waktu Pelaksanaan',
                        p.startDate != null
                            ? '${p.startDate} s/d ${p.endDate ?? "Selesai"}'
                            : 'Belum dijadwalkan',
                        Icons.calendar_month_outlined,
                      ),
                      _buildInfoRow(
                        'Lokasi',
                        p.location?.isNotEmpty == true
                            ? p.location!
                            : 'Belum ditentukan',
                        Icons.location_on_outlined,
                      ),
                      _buildInfoRow(
                        'Pendaftaran',
                        '${p.registrationType} • ${p.quota != null ? "${p.quota} kuota" : "Tanpa batas"}',
                        Icons.how_to_reg_outlined,
                      ),
                      _buildInfoRow(
                        'Panitia & Peserta',
                        '${p.membersCount} orang terdaftar',
                        Icons.groups_outlined,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Navigasi ke Fitur Terkait (Kepanitiaan & Jadwal)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.badge_outlined, size: 18),
                      label: const Text('Kepanitiaan'),
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.kepanitiaan);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_month_outlined, size: 18),
                      label: const Text('Jadwal Kegiatan'),
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.jadwal);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Tombol Tindakan Cepat (Update Status) untuk yang berwenang
              if (canManage) ...[
                SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.flag_outlined, size: 18),
                    label: const Text('Perbarui Status Proker'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.teal,
                    ),
                    onPressed: _handleUpdateStatus,
                  ),
                ),
              ] else ...[
                const Center(
                  child: Text(
                    'Anda memiliki hak akses baca untuk program kerja ini.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF777777)),
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

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppTheme.teal),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
          ),
          const Spacer(),
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
