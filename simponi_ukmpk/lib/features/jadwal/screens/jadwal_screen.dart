import 'package:flutter/material.dart';

import '../../../core/widgets/empty_state.dart';

class JadwalScreen extends StatelessWidget {
  const JadwalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal & Agenda'),
      ),
      body: const Center(
        child: EmptyStateWidget(
          message: 'Kalender agenda dan jadwal kegiatan organisasi akan ditampilkan di sini.',
          icon: Icons.calendar_month_outlined,
        ),
      ),
    );
  }
}
