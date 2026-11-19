import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../data/services/account_service.dart';
import '../../auth/providers/auth_provider.dart';
import 'account_detail_screen.dart';
import 'account_form_screen.dart';

class AccountListScreen extends StatefulWidget {
  const AccountListScreen({super.key});

  @override
  State<AccountListScreen> createState() => _AccountListScreenState();
}

class _AccountListScreenState extends State<AccountListScreen> {
  final AccountService _accountService = AccountService();
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String? _errorMessage;
  List<dynamic> _accounts = [];

  @override
  void initState() {
    super.initState();
    _fetchAccounts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchAccounts([String? search]) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _accountService.getAccounts(search: search);
      final list = data['data'] as List<dynamic>? ?? [];

      if (mounted) {
        setState(() {
          _accounts = list;
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
        title: Text(isAdmin ? 'Kelola Akun Anggota' : 'Direktori Anggota UKMPK'),
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: () async {
                final created = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(builder: (_) => const AccountFormScreen()),
                );
                if (created == true && mounted) {
                  _fetchAccounts(_searchController.text);
                }
              },
              backgroundColor: AppTheme.deepNavy,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text('Tambah Akun'),
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
              onSubmitted: (val) => _fetchAccounts(val),
              decoration: InputDecoration(
                hintText: 'Cari nama, email, atau NIM...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _fetchAccounts();
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Content
          Expanded(
            child: _buildContent(isAdmin),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isAdmin) {
    if (_isLoading) {
      return const LoadingIndicator(message: 'Memuat data akun...');
    }

    if (_errorMessage != null) {
      return ErrorStateWidget(
        message: _errorMessage!,
        onRetry: () => _fetchAccounts(_searchController.text),
      );
    }

    if (_accounts.isEmpty) {
      return const EmptyStateWidget(
        message: 'Tidak ada data akun yang ditemukan.',
        icon: Icons.people_outline,
      );
    }

    return RefreshIndicator(
      onRefresh: () => _fetchAccounts(_searchController.text),
      child: ListView.separated(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0, bottom: 80.0),
        itemCount: _accounts.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final account = _accounts[index] as Map<String, dynamic>;
          final name = account['name']?.toString() ?? '-';
          final email = account['email']?.toString() ?? '-';
          final isActive = account['is_active'] == true || account['is_active'] == 1;
          final member = account['member'] as Map<String, dynamic>?;
          final nim = member?['nim']?.toString() ?? '';
          final position = member?['position']?.toString() ?? '';
          final roles = (account['roles'] as List<dynamic>?)
                  ?.map((r) => r is Map ? r['name'] : r.toString())
                  .join(', ') ??
              'anggota';

          return Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                final id = account['id'] is int
                    ? account['id'] as int
                    : int.parse(account['id'].toString());
                final result = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (_) => AccountDetailScreen(
                      accountId: id,
                      initialData: account,
                    ),
                  ),
                );
                if (result == true && mounted) {
                  _fetchAccounts(_searchController.text);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: isActive ? AppTheme.teal : Colors.grey,
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : 'A',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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
                                  name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.deepNavy,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? Colors.green.shade50
                                      : Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: isActive ? Colors.green : Colors.red,
                                    width: 0.8,
                                  ),
                                ),
                                child: Text(
                                  isActive ? 'Aktif' : 'Nonaktif',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isActive
                                        ? Colors.green.shade800
                                        : Colors.red.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF666666),
                            ),
                          ),
                          if (nim.isNotEmpty || position.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              [
                                if (nim.isNotEmpty) 'NIM: $nim',
                                if (position.isNotEmpty) position,
                                'Role: $roles'
                              ].join(' • '),
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.teal,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
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
