import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../data/models/program_model.dart';
import '../../../data/services/program_service.dart';
import '../../akun/screens/account_form_screen.dart'; // contains kDivisions
import '../../auth/providers/auth_provider.dart';
import 'program_kerja_detail_screen.dart';
import 'program_kerja_form_screen.dart';

class ProgramKerjaScreen extends StatefulWidget {
  const ProgramKerjaScreen({super.key});

  @override
  State<ProgramKerjaScreen> createState() => _ProgramKerjaScreenState();
}

class _ProgramKerjaScreenState extends State<ProgramKerjaScreen> {
  final ProgramService _programService = ProgramService();
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String? _errorMessage;
  List<ProgramModel> _programs = [];

  String _selectedStatus = 'Semua';
  int? _selectedDivisionId;

  final List<Map<String, String>> _statusOptions = [
    {'code': 'Semua', 'label': 'Semua'},
    {'code': 'Planned', 'label': 'Perencanaan'},
    {'code': 'Preparation', 'label': 'Persiapan'},
    {'code': 'Ongoing', 'label': 'Berlangsung'},
    {'code': 'Completed', 'label': 'Selesai'},
    {'code': 'Cancelled', 'label': 'Dibatalkan'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchPrograms();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchPrograms() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final list = await _programService.getPrograms(
        search: _searchController.text.trim(),
        divisionId: _selectedDivisionId,
        status: _selectedStatus == 'Semua' ? null : _selectedStatus,
      );

      if (mounted) {
        setState(() {
          _programs = list;
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

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final isAdmin = user?.isAdmin ?? false;
    final isPengurus = user?.isPengurus ?? false;
    final canAddProker = isAdmin || isPengurus;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Program Kerja UKMPK'),
      ),
      floatingActionButton: canAddProker
          ? FloatingActionButton.extended(
              onPressed: () async {
                final created = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (_) => const ProgramKerjaFormScreen(),
                  ),
                );
                if (created == true && mounted) {
                  _fetchPrograms();
                }
              },
              backgroundColor: AppTheme.deepNavy,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Tambah Proker'),
            )
          : null,
      body: Column(
        children: [
          // Filter & Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _fetchPrograms(),
                  decoration: InputDecoration(
                    hintText: 'Cari nama proker atau lokasi...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _fetchPrograms();
                            },
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 10),

                // Baris Filter Divisi & Status
                Row(
                  children: [
                    // Dropdown Divisi
                    Expanded(
                      flex: 4,
                      child: DropdownButtonFormField<int?>(
                        initialValue: _selectedDivisionId,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          prefixIcon: Icon(Icons.filter_alt_outlined, size: 18),
                        ),
                        items: [
                          const DropdownMenuItem<int?>(
                            value: null,
                            child: Text('Semua Divisi', style: TextStyle(fontSize: 12)),
                          ),
                          ...kDivisions.map((div) {
                            return DropdownMenuItem<int?>(
                              value: div.id,
                              child: Text(div.name, style: const TextStyle(fontSize: 12)),
                            );
                          }),
                        ],
                        onChanged: (val) {
                          setState(() => _selectedDivisionId = val);
                          _fetchPrograms();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Horizontal Filter Chips untuk Status
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _statusOptions.map((st) {
                      final isSelected = _selectedStatus == st['code'];
                      return Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: FilterChip(
                          label: Text(
                            st['label']!,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight:
                                  isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.white : AppTheme.deepNavy,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: AppTheme.teal,
                          backgroundColor: Colors.white,
                          checkmarkColor: Colors.white,
                          onSelected: (_) {
                            setState(() => _selectedStatus = st['code']!);
                            _fetchPrograms();
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Content List
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const LoadingIndicator(message: 'Memuat data program kerja...');
    }

    if (_errorMessage != null) {
      return ErrorStateWidget(
        message: _errorMessage!,
        onRetry: _fetchPrograms,
      );
    }

    if (_programs.isEmpty) {
      return const EmptyStateWidget(
        message: 'Tidak ada program kerja yang ditemukan.',
        icon: Icons.assignment_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchPrograms,
      child: ListView.separated(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 4.0,
          bottom: 80.0,
        ),
        itemCount: _programs.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final p = _programs[index];

          return Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                final updated = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (_) => ProgramKerjaDetailScreen(
                      programId: p.id,
                      initialName: p.name,
                    ),
                  ),
                );
                if (updated == true && mounted) {
                  _fetchPrograms();
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.teal.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            p.divisionName.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.teal,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: p.statusColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: p.statusColor, width: 0.6),
                          ),
                          child: Text(
                            p.statusLabel,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: p.statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      p.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.deepNavy,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 13,
                          color: Color(0xFF666666),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          p.startDate != null
                              ? '${p.startDate} s/d ${p.endDate ?? "Selesai"}'
                              : 'Jadwal belum ditentukan',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                    if (p.location?.isNotEmpty == true) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 13,
                            color: Color(0xFF666666),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              p.location!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF666666),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'PIC: ${p.picName != null ? (p.picNim != null && p.picNim!.isNotEmpty ? "${p.picName} (${p.picNim})" : p.picName!) : "Belum ditentukan"}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFF777777),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${p.membersCount} Panitia/Peserta',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.deepNavy,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
