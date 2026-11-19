import 'package:flutter/material.dart';

import '../../../core/widgets/empty_state.dart';

class KepanitiaanScreen extends StatelessWidget {
  const KepanitiaanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kepanitiaan'),
      ),
      body: const Center(
        child: EmptyStateWidget(
          message: 'Susunan kepanitiaan program kerja akan ditampilkan di sini.',
          icon: Icons.badge_outlined,
        ),
      ),
    );
  }
}
