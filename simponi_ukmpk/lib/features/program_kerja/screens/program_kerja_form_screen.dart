import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/program_model.dart';
import '../../../data/services/account_service.dart';
import '../../../data/services/program_service.dart';
import '../../akun/screens/account_form_screen.dart'; // contains kDivisions
import '../../auth/providers/auth_provider.dart';

class PicCandidate {
  final int memberId;
  final String name;
  final String nim;

  const PicCandidate({
    required this.memberId,
    required this.name,
    required this.nim,
  });

  String get label => nim.isNotEmpty ? '$name ($nim)' : name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PicCandidate &&
          runtimeType == other.runtimeType &&
          memberId == other.memberId;

  @override
  int get hashCode => memberId.hashCode;
}

class ProgramKerjaFormScreen extends StatefulWidget {
  final ProgramModel? program;

  const ProgramKerjaFormScreen({super.key, this.program});

  @override
  State<ProgramKerjaFormScreen> createState() => _ProgramKerjaFormScreenState();
}

class _ProgramKerjaFormScreenState extends State<ProgramKerjaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProgramService _programService = ProgramService();
  final AccountService _accountService = AccountService();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  late final TextEditingController _quotaController;

  int? _selectedDivisionId;
  int? _selectedPicId;
  List<PicCandidate> _picCandidates = [];
  bool _isLoadingPics = true;

  String _selectedStatus = 'Planned';
  String _selectedRegType = 'Internal';
  DateTime? _startDate;
  DateTime? _endDate;

  bool _isLoading = false;

  bool get isEditing => widget.program != null;

  @override
  void initState() {
    super.initState();
    final p = widget.program;

    _nameController = TextEditingController(text: p?.name ?? '');
    _descriptionController = TextEditingController(text: p?.description ?? '');
    _locationController = TextEditingController(text: p?.location ?? '');
    _quotaController =
        TextEditingController(text: p?.quota != null ? p!.quota.toString() : '');

    _selectedPicId = p?.picId;
    if (p?.picId != null) {
      _picCandidates = [
        PicCandidate(
          memberId: p!.picId!,
          name: p.picName ?? 'Ketua Pelaksana',
          nim: p.picNim ?? '',
        ),
      ];
    }
    _loadPicCandidates();

    const validStatuses = [
      'Planned',
      'Preparation',
      'Ongoing',
      'Completed',
      'Cancelled',
    ];

    const validRegTypes = [
      'Internal',
      'Open',
      'Public',
      'Closed',
    ];

    _selectedStatus = validStatuses.contains(p?.status)
        ? p!.status
        : 'Planned';

    _selectedRegType = validRegTypes.contains(p?.registrationType)
        ? p!.registrationType
        : 'Internal';

    if (p?.startDate != null) {
      _startDate = DateTime.tryParse(p!.startDate!);
    }
    if (p?.endDate != null) {
      _endDate = DateTime.tryParse(p!.endDate!);
    }

    if (p != null) {
      _selectedDivisionId = p.divisionId;
    } else {
      // Jika Pengurus, otomatis gunakan divisinya
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final auth = context.read<AuthProvider>();
        if (!auth.user!.isAdmin && auth.user?.member?.divisionId != null) {
          setState(() {
            _selectedDivisionId = auth.user!.member!.divisionId;
          });
        } else {
          setState(() {
            _selectedDivisionId = _selectedDivisionId ?? 1;
          });
        }
      });
    }
  }

  Future<void> _loadPicCandidates() async {
    try {
      final rawAccounts = await _accountService.getPicCandidates();
      final seenIds = <int>{};
      final candidates = <PicCandidate>[];

      for (final item in rawAccounts) {
        final member = item['member'] as Map<String, dynamic>?;
        if (member != null && member['id'] != null) {
          final memberId = member['id'] is int
              ? member['id'] as int
              : int.tryParse(member['id'].toString());
          final name = item['name']?.toString() ?? '';
          final nim = member['nim']?.toString() ?? '';

          if (memberId != null && !seenIds.contains(memberId)) {
            seenIds.add(memberId);
            candidates.add(PicCandidate(
              memberId: memberId,
              name: name,
              nim: nim,
            ));
          }
        }
      }

      // Pastikan jika ada PIC terpilih sebelumnya, tetap ada di daftar kandidat
      if (_selectedPicId != null && !seenIds.contains(_selectedPicId)) {
        if (widget.program?.picName != null) {
          candidates.insert(
            0,
            PicCandidate(
              memberId: _selectedPicId!,
              name: widget.program!.picName!,
              nim: widget.program!.picNim ?? '',
            ),
          );
          seenIds.add(_selectedPicId!);
        }
      }

      if (mounted) {
        setState(() {
          _picCandidates = candidates;
          _isLoadingPics = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoadingPics = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _quotaController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final initial = isStart
        ? (_startDate ?? DateTime.now())
        : (_endDate ?? _startDate ?? DateTime.now());

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return 'Pilih Tanggal';
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  Future<void> _handleSubmit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDivisionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih divisi penyelenggara terlebih dahulu.'),
          backgroundColor: AppTheme.softTerracotta,
        ),
      );
      return;
    }

    if (_startDate != null && _endDate != null && _endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tanggal selesai tidak boleh sebelum tanggal mulai.'),
          backgroundColor: AppTheme.softTerracotta,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final payload = <String, dynamic>{
      'division_id': _selectedDivisionId,
      'pic_id': _selectedPicId,
      'name': _nameController.text.trim(),
      'description': _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : null,
      'location': _locationController.text.trim().isNotEmpty
          ? _locationController.text.trim()
          : null,
      'quota': _quotaController.text.trim().isNotEmpty
          ? int.tryParse(_quotaController.text.trim())
          : null,
      'registration_type': _selectedRegType,
      'status': _selectedStatus,
      'start_date': _startDate != null ? _formatDate(_startDate) : null,
      'end_date': _endDate != null ? _formatDate(_endDate) : null,
    };

    try {
      if (isEditing) {
        await _programService.updateProgram(widget.program!.id, payload);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Program kerja berhasil diperbarui.'),
            backgroundColor: AppTheme.teal,
          ),
        );
      } else {
        await _programService.createProgram(payload);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Program kerja baru berhasil ditambahkan.'),
            backgroundColor: AppTheme.teal,
          ),
        );
      }

      if (mounted) {
        Navigator.of(context).pop(true);
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
    final auth = context.watch<AuthProvider>();
    final isAdmin = auth.user?.isAdmin ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Ubah Program Kerja' : 'Tambah Program Kerja'),
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
                        'Informasi Utama Program Kerja',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.deepNavy,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Nama Proker
                      TextFormField(
                        controller: _nameController,
                        maxLength: 150,
                        decoration: const InputDecoration(
                          labelText: 'Nama Program Kerja',
                          hintText: 'Misal: Donor Darah Akbar, Diklat Relawan',
                          prefixIcon: Icon(Icons.assignment_outlined),
                        ),
                        validator: (val) =>
                            Validators.validateRequired(val, 'Nama Program Kerja'),
                      ),
                      const SizedBox(height: 14),

                      // Divisi Penyelenggara
                      DropdownButtonFormField<int>(
                        initialValue: _selectedDivisionId,
                        decoration: InputDecoration(
                          labelText: 'Divisi Penyelenggara',
                          prefixIcon: const Icon(Icons.apartment_outlined),
                          helperText: !isAdmin
                              ? 'Terkunci pada divisi Anda'
                              : null,
                        ),
                        items: kDivisions.map((div) {
                          return DropdownMenuItem<int>(
                            value: div.id,
                            child: Text(div.name),
                          );
                        }).toList(),
                        onChanged: isAdmin
                            ? (val) {
                                setState(() => _selectedDivisionId = val);
                              }
                            : null, // Pengurus tidak bisa memindahkan divisi
                      ),
                      const SizedBox(height: 14),

                      // Ketua Pelaksana (PIC)
                      DropdownButtonFormField<int?>(
                        key: ValueKey(
                          'pic_select_${_picCandidates.length}_${_isLoadingPics ? "loading" : "ready"}',
                        ),
                        initialValue: _selectedPicId,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Ketua Pelaksana (PIC)',
                          prefixIcon: const Icon(Icons.person_pin_outlined),
                          helperText: _isLoadingPics
                              ? 'Memuat daftar anggota...'
                              : 'Pilih anggota terdaftar sebagai PIC',
                          suffixIcon: _isLoadingPics
                              ? const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        items: [
                          const DropdownMenuItem<int?>(
                            value: null,
                            child: Text('Belum Ditentukan (Tanpa PIC)'),
                          ),
                          ..._picCandidates.map((c) {
                            return DropdownMenuItem<int?>(
                              value: c.memberId,
                              child: Text(
                                c.label,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }),
                        ],
                        onChanged: (val) {
                          setState(() => _selectedPicId = val);
                        },
                      ),
                      const SizedBox(height: 14),

                      // Status Pelaksanaan
                      DropdownButtonFormField<String>(
                        initialValue: _selectedStatus,
                        decoration: const InputDecoration(
                          labelText: 'Status Pelaksanaan',
                          prefixIcon: Icon(Icons.flag_outlined),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Planned',
                            child: Text('Perencanaan (Planned)'),
                          ),
                          DropdownMenuItem(
                            value: 'Preparation',
                            child: Text('Persiapan (Preparation)'),
                          ),
                          DropdownMenuItem(
                            value: 'Ongoing',
                            child: Text('Berlangsung (Ongoing)'),
                          ),
                          DropdownMenuItem(
                            value: 'Completed',
                            child: Text('Selesai (Completed)'),
                          ),
                          DropdownMenuItem(
                            value: 'Cancelled',
                            child: Text('Dibatalkan (Cancelled)'),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedStatus = val);
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
                        'Waktu, Lokasi & Pendaftaran',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.deepNavy,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Tanggal Pelaksanaan (Mulai & Selesai)
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => _pickDate(isStart: true),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Tanggal Mulai',
                                  prefixIcon: Icon(Icons.date_range_outlined),
                                ),
                                child: Text(
                                  _formatDate(_startDate),
                                  style: TextStyle(
                                    color: _startDate != null
                                        ? AppTheme.deepNavy
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InkWell(
                              onTap: () => _pickDate(isStart: false),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Tanggal Selesai',
                                  prefixIcon: Icon(Icons.event_outlined),
                                ),
                                child: Text(
                                  _formatDate(_endDate),
                                  style: TextStyle(
                                    color: _endDate != null
                                        ? AppTheme.deepNavy
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Lokasi
                      TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          labelText: 'Lokasi Pelaksanaan (Opsional)',
                          hintText: 'Misal: Gedung Rektorat UNESA / Zoom Meeting',
                          prefixIcon: Icon(Icons.location_on_outlined),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Jenis Pendaftaran & Kuota
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _selectedRegType,
                              decoration: const InputDecoration(
                                labelText: 'Jenis Pendaftaran',
                                prefixIcon: Icon(Icons.how_to_reg_outlined),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'Internal', child: Text('Internal')),
                                DropdownMenuItem(value: 'Open', child: Text('Terbuka (Open)')),
                                DropdownMenuItem(value: 'Public', child: Text('Publik / Umum')),
                                DropdownMenuItem(value: 'Closed', child: Text('Ditutup')),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedRegType = val);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _quotaController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Kuota Peserta (Opsional)',
                                hintText: 'Misal: 50',
                                prefixIcon: Icon(Icons.people_alt_outlined),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Deskripsi
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Deskripsi Program Kerja (Opsional)',
                          hintText: 'Jelaskan tujuan, sasaran, dan gambaran umum kegiatan...',
                          alignLabelWithHint: true,
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
                          isEditing ? 'Simpan Perubahan' : 'Buat Program Kerja',
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
