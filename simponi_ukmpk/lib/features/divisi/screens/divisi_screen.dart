import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../data/models/division_model.dart';
import '../../../data/services/division_service.dart';
import '../../auth/providers/auth_provider.dart';
import 'divisi_detail_screen.dart';
import 'divisi_form_screen.dart';

class DivisiScreen extends StatefulWidget {
  const DivisiScreen({super.key});

  @override
  State<DivisiScreen> createState() => _DivisiScreenState();
}

class _DivisiScreenState extends State<DivisiScreen> {
  final DivisionService _divisionService = DivisionService();
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String? _errorMessage;
  List<DivisionModel> _divisions = [];

  @override
  void initState() {
    super.initState();
    _fetchDivisions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchDivisions([String? search]) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final list = await _divisionService.getDivisions(search: search);
      if (mounted) {
        setState(() {
          _divisions = list;
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
    final isAdmin = auth.user?.isAdmin ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Divisi UKMPK UNESA'),
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: () async {
                final created = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(builder: (_) => const DivisiFormScreen()),
                );
                if (created == true && mounted) {
                  _fetchDivisions(_searchController.text);
                }
              },
              backgroundColor: AppTheme.deepNavy,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Tambah Divisi'),
            )
          : null,
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (val) => _fetchDivisions(val),
              decoration: InputDecoration(
                hintText: 'Cari divisi UKMPK...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _fetchDivisions();
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const LoadingIndicator(message: 'Memuat data divisi...');
    }

    if (_errorMessage != null) {
      return ErrorStateWidget(
        message: _errorMessage!,
        onRetry: () => _fetchDivisions(_searchController.text),
      );
    }

    if (_divisions.isEmpty) {
      return const EmptyStateWidget(
        message: 'Tidak ada divisi yang ditemukan.',
        icon: Icons.apartment_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: () => _fetchDivisions(_searchController.text),
      child: ListView.separated(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 4.0,
          bottom: 80.0,
        ),
        itemCount: _divisions.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final div = _divisions[index];

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
                    builder: (_) => DivisiDetailScreen(
                      divisionId: div.id,
                      initialName: div.name,
                    ),
                  ),
                );
                if (updated == true && mounted) {
                  _fetchDivisions(_searchController.text);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.teal.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.apartment_outlined,
                        color: AppTheme.teal,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  div.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.deepNavy,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.warmYellow.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${div.membersCount} Anggota',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.deepNavy,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            div.description?.isNotEmpty == true
                                ? div.description!
                                : 'Belum ada deskripsi divisi.',
                            style: TextStyle(
                              fontSize: 12,
                              color: div.description?.isNotEmpty == true
                                  ? const Color(0xFF555555)
                                  : const Color(0xFF999999),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: Color(0xFF999999),
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
