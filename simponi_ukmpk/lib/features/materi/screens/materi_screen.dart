import 'package:flutter/material.dart';

import '../../../core/widgets/empty_state.dart';

class MateriScreen extends StatelessWidget {
  const MateriScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Materi & Dokumen'),
      ),
      body: const Center(
        child: EmptyStateWidget(
          message: 'Distribusi materi dan dokumen organisasi akan ditampilkan di sini.',
          icon: Icons.folder_shared_outlined,
        ),
      ),
    );
  }
}
