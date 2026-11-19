import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../data/services/account_service.dart';

class DivisionOption {
  final int id;
  final String name;

  const DivisionOption({required this.id, required this.name});
}

const List<DivisionOption> kDivisions = [
  DivisionOption(id: 1, name: 'BPH'),
  DivisionOption(id: 2, name: 'Pendidikan'),
  DivisionOption(id: 3, name: 'Kesehatan'),
  DivisionOption(id: 4, name: 'PSDM'),
  DivisionOption(id: 5, name: 'Mitigasi Bencana'),
  DivisionOption(id: 6, name: 'Huminfo'),
  DivisionOption(id: 7, name: 'Ekraf'),
];

class AccountFormScreen extends StatefulWidget {
  final Map<String, dynamic>? account;

  const AccountFormScreen({super.key, this.account});

  @override
  State<AccountFormScreen> createState() => _AccountFormScreenState();
}

class _AccountFormScreenState extends State<AccountFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final AccountService _accountService = AccountService();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _nimController;
  late final TextEditingController _phoneController;
  late final TextEditingController _positionController;
  late final TextEditingController _generationController;

  int? _selectedDivisionId;
  String _selectedRole = AppConstants.roleAnggota;
  String _selectedStatus = 'Active';

  bool _isLoading = false;

  bool get isEditing => widget.account != null;

  @override
  void initState() {
    super.initState();
    final acc = widget.account;
    final member = acc?['member'] as Map<String, dynamic>?;

    _nameController = TextEditingController(text: acc?['name']?.toString() ?? '');
    _emailController = TextEditingController(text: acc?['email']?.toString() ?? '');
    _nimController = TextEditingController(text: member?['nim']?.toString() ?? '');
    _phoneController = TextEditingController(text: member?['phone']?.toString() ?? '');
    _positionController = TextEditingController(text: member?['position']?.toString() ?? '');
    _generationController = TextEditingController(text: member?['generation']?.toString() ?? '');

    if (member?['division_id'] != null) {
      _selectedDivisionId = int.tryParse(member!['division_id'].toString());
    } else {
      _selectedDivisionId = 1;
    }

    final roles = acc?['roles'] as List<dynamic>?;
    if (roles != null && roles.isNotEmpty) {
      final firstRole = roles.first;
      final roleName = firstRole is Map ? firstRole['name']?.toString() : firstRole.toString();
      if (['admin', 'pengurus', 'anggota'].contains(roleName)) {
        _selectedRole = roleName!;
      }
    }

    if (member?['status'] != null) {
      final st = member!['status'].toString();
      if (['Active', 'Inactive'].contains(st)) {
        _selectedStatus = st;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _nimController.dispose();
    _phoneController.dispose();
    _positionController.dispose();
    _generationController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDivisionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih divisi anggota terlebih dahulu.'),
          backgroundColor: AppTheme.softTerracotta,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final payload = <String, dynamic>{
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'nim': _nimController.text.trim(),
      'phone': _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : null,
      'division_id': _selectedDivisionId,
      'position': _positionController.text.trim(),
      'generation': _generationController.text.trim(),
      'role': _selectedRole,
      'status': _selectedStatus,
    };

    try {
      if (isEditing) {
        final accountId = widget.account!['id'] is int
            ? widget.account!['id'] as int
            : int.parse(widget.account!['id'].toString());

        await _accountService.updateAccount(accountId, payload);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data akun anggota berhasil diperbarui.'),
            backgroundColor: AppTheme.teal,
          ),
        );
        Navigator.of(context).pop(true);
      } else {
        final result = await _accountService.createAccount(payload);

        if (!mounted) return;
        final tempPassword = result['temporary_password']?.toString() ?? '-';

        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Akun Berhasil Dibuat'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Akun anggota berhasil didaftarkan dengan password sementara di bawah ini:',
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.warmYellow.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.warmYellow),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SelectableText(
                        tempPassword,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.deepNavy,
                          letterSpacing: 1.2,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 20),
                        tooltip: 'Salin Password',
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: tempPassword));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Password sementara disalin ke clipboard.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Catatan: Anggota wajib mengganti password sementara ini saat pertama kali login.',
                  style: TextStyle(fontSize: 11, color: Color(0xFF666666)),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Selesai'),
              ),
            ],
          ),
        );

        if (mounted) {
          Navigator.of(context).pop(true);
        }
      }
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
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Ubah Akun Anggota' : 'Tambah Akun Anggota'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                        'Data Akun Pengguna',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.deepNavy,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Lengkap',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (val) => Validators.validateRequired(val, 'Nama Lengkap'),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'nama@unesa.ac.id',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: Validators.validateEmail,
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedRole,
                        decoration: const InputDecoration(
                          labelText: 'Role Aplikasi',
                          prefixIcon: Icon(Icons.security_outlined),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'anggota',
                            child: Text('Anggota (Staff / Anggota UKMPK)'),
                          ),
                          DropdownMenuItem(
                            value: 'pengurus',
                            child: Text('Pengurus (Kadiv / Wakadiv)'),
                          ),
                          DropdownMenuItem(
                            value: 'admin',
                            child: Text('Admin (Ketum / Waketum)'),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedRole = val);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

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
                        'Data Keanggotaan UKMPK',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.deepNavy,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nimController,
                        decoration: const InputDecoration(
                          labelText: 'NIM Mahasiswa',
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                        validator: (val) => Validators.validateRequired(val, 'NIM'),
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<int>(
                        initialValue: _selectedDivisionId,
                        decoration: const InputDecoration(
                          labelText: 'Divisi',
                          prefixIcon: Icon(Icons.apartment_outlined),
                        ),
                        items: kDivisions.map((div) {
                          return DropdownMenuItem<int>(
                            value: div.id,
                            child: Text(div.name),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() => _selectedDivisionId = val);
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _positionController,
                        decoration: const InputDecoration(
                          labelText: 'Jabatan / Posisi',
                          hintText: 'Misal: Staf Divisi, Kadiv, Koordinator',
                          prefixIcon: Icon(Icons.work_outline),
                        ),
                        validator: (val) => Validators.validateRequired(val, 'Jabatan'),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _generationController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Angkatan',
                                hintText: '2024',
                                prefixIcon: Icon(Icons.calendar_today_outlined),
                              ),
                              validator: (val) => Validators.validateRequired(val, 'Angkatan'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _selectedStatus,
                              decoration: const InputDecoration(
                                labelText: 'Status',
                                prefixIcon: Icon(Icons.check_circle_outline),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'Active', child: Text('Active')),
                                DropdownMenuItem(value: 'Inactive', child: Text('Inactive')),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedStatus = val);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Nomor Telepon / WhatsApp (Opsional)',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubmit,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          isEditing ? 'Simpan Perubahan' : 'Buat Akun Anggota',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
