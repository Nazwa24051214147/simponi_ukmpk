import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import 'storage_service.dart';

class AdminDashboardStats {
  final int totalAccounts;
  final int activeAccounts;
  final int inactiveAccounts;
  final List<Map<String, dynamic>> recentAccounts;

  AdminDashboardStats({
    required this.totalAccounts,
    required this.activeAccounts,
    required this.inactiveAccounts,
    required this.recentAccounts,
  });

  factory AdminDashboardStats.empty() {
    return AdminDashboardStats(
      totalAccounts: 0,
      activeAccounts: 0,
      inactiveAccounts: 0,
      recentAccounts: [],
    );
  }
}

class DashboardService {
  final StorageService _storageService;

  DashboardService({StorageService? storageService})
      : _storageService = storageService ?? StorageService();

  Future<AdminDashboardStats> getAdminStats() async {
    final token = await _storageService.getToken();
    if (token == null) {
      return AdminDashboardStats.empty();
    }

    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminAccounts}'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final dynamic body = jsonDecode(response.body);
        if (body is Map<String, dynamic> && body['data'] is Map<String, dynamic>) {
          final data = body['data'] as Map<String, dynamic>;
          final total = data['total'] is int ? data['total'] as int : 0;
          final accountsList = data['data'] as List<dynamic>? ?? [];

          int activeCount = 0;
          int inactiveCount = 0;
          final List<Map<String, dynamic>> recent = [];

          for (final item in accountsList) {
            if (item is Map<String, dynamic>) {
              final isActive = item['is_active'] == true || item['is_active'] == 1;
              if (isActive) {
                activeCount++;
              } else {
                inactiveCount++;
              }

              if (recent.length < 5) {
                recent.add({
                  'id': item['id'],
                  'name': item['name'] ?? '',
                  'email': item['email'] ?? '',
                  'is_active': isActive,
                  'role': (item['roles'] as List<dynamic>?)
                          ?.map((r) => r is Map ? r['name'] : r.toString())
                          .firstOrNull ??
                      'anggota',
                });
              }
            }
          }

          return AdminDashboardStats(
            totalAccounts: total,
            activeAccounts: activeCount,
            inactiveAccounts: inactiveCount,
            recentAccounts: recent,
          );
        }
      }
    } catch (_) {
      // Fallback ke empty jika backend atau jaringan belum tersedia
    }

    return AdminDashboardStats.empty();
  }
}
