import 'package:flutter/material.dart';

import '../../../core/widgets/empty_state.dart';

class KegiatanScreen extends StatelessWidget {
  const KegiatanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kegiatan & Pendaftaran'),
      ),
      body: const Center(
        child: EmptyStateWidget(
          message: 'Daftar kegiatan serta pendaftaran peserta dan panitia akan ditampilkan di sini.',
          icon: Icons.event_available_outlined,
        ),
      ),
    );
  }
}
