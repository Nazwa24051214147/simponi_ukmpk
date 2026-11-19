import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/division_model.dart';
import '../../../data/services/division_service.dart';

class DivisiFormScreen extends StatefulWidget {
  final DivisionModel? division;

  const DivisiFormScreen({super.key, this.division});

  @override
  State<DivisiFormScreen> createState() => _DivisiFormScreenState();
}

class _DivisiFormScreenState extends State<DivisiFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final DivisionService _divisionService = DivisionService();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  bool _isLoading = false;

  bool get isEditing => widget.division != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.division?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.division?.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final payload = <String, dynamic>{
      'name': _nameController.text.trim(),
      'description': _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : null,
    };

    try {
      if (isEditing) {
        await _divisionService.updateDivision(widget.division!.id, payload);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Divisi berhasil diperbarui.'),
            backgroundColor: AppTheme.teal,
          ),
        );
      } else {
        await _divisionService.createDivision(payload);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Divisi baru berhasil ditambahkan.'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Ubah Data Divisi' : 'Tambah Divisi Baru'),
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
                        'Informasi Divisi UKMPK',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.deepNavy,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        maxLength: 100,
                        decoration: const InputDecoration(
                          labelText: 'Nama Divisi',
                          hintText: 'Misal: PSDM, Huminfo, Ekraf',
                          prefixIcon: Icon(Icons.apartment_outlined),
                        ),
                        validator: (val) =>
                            Validators.validateRequired(val, 'Nama Divisi'),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
                        maxLength: 1000,
                        decoration: const InputDecoration(
                          labelText: 'Deskripsi Divisi (Opsional)',
                          hintText:
                              'Jelaskan tugas pokok dan fungsi divisi ini dalam UKMPK...',
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
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          isEditing ? 'Simpan Perubahan' : 'Tambah Divisi',
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
