import 'package:flutter/material.dart';

import '../../../core/widgets/empty_state.dart';

class PresensiScreen extends StatelessWidget {
  const PresensiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Presensi Kegiatan'),
      ),
      body: const Center(
        child: EmptyStateWidget(
          message: 'Presensi kegiatan dengan QR/kode kehadiran akan ditampilkan di sini.',
          icon: Icons.qr_code_scanner_outlined,
        ),
      ),
    );
  }
}
