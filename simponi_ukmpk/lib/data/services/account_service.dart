import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import 'storage_service.dart';

class AccountService {
  final StorageService _storageService;

  AccountService({StorageService? storageService})
      : _storageService = storageService ?? StorageService();

  Future<Map<String, dynamic>> getAccounts({
    String? search,
    int page = 1,
    int? perPage,
  }) async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Sesi tidak ditemukan. Silakan login kembali.');
    }

    final queryParams = <String, String>{};
    if (search != null && search.trim().isNotEmpty) {
      queryParams['search'] = search.trim();
    }
    if (page > 1) {
      queryParams['page'] = page.toString();
    }
    if (perPage != null && perPage > 0) {
      queryParams['per_page'] = perPage.toString();
    }

    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.accounts}')
        .replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final dynamic body = jsonDecode(response.body);

    if (response.statusCode == 200 && body is Map<String, dynamic>) {
      return body['data'] as Map<String, dynamic>;
    }

    throw Exception(_parseErrorMessage(body, 'Gagal memuat daftar akun.'));
  }

  Future<List<Map<String, dynamic>>> getPicCandidates({int perPage = 200}) async {
    try {
      final result = await getAccounts(perPage: perPage);
      final rawList = result['data'] as List<dynamic>? ?? [];
      return rawList.whereType<Map<String, dynamic>>().toList();
    } catch (_) {
      return [];
    }
  }

  Future<Map<String, dynamic>> getAccountDetail(int id) async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Sesi tidak ditemukan. Silakan login kembali.');
    }

    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminAccountDetail(id)}'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final dynamic body = jsonDecode(response.body);

    if (response.statusCode == 200 && body is Map<String, dynamic>) {
      return body['data'] as Map<String, dynamic>;
    }

    throw Exception(_parseErrorMessage(body, 'Gagal memuat detail akun.'));
  }

  Future<Map<String, dynamic>> createAccount(Map<String, dynamic> data) async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Sesi tidak ditemukan. Silakan login kembali.');
    }

    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminAccounts}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    final dynamic body = jsonDecode(response.body);

    if (response.statusCode == 201 && body is Map<String, dynamic>) {
      return body['data'] as Map<String, dynamic>;
    }

    throw Exception(_parseErrorMessage(body, 'Gagal membuat akun anggota.'));
  }

  Future<Map<String, dynamic>> updateAccount(
    int id,
    Map<String, dynamic> data,
  ) async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Sesi tidak ditemukan. Silakan login kembali.');
    }

    final response = await http.put(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminAccountDetail(id)}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    final dynamic body = jsonDecode(response.body);

    if (response.statusCode == 200 && body is Map<String, dynamic>) {
      return body['data'] as Map<String, dynamic>;
    }

    throw Exception(_parseErrorMessage(body, 'Gagal memperbarui akun anggota.'));
  }

  Future<Map<String, dynamic>> toggleStatus(int id) async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Sesi tidak ditemukan. Silakan login kembali.');
    }

    final response = await http.patch(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminAccountToggleStatus(id)}'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final dynamic body = jsonDecode(response.body);

    if (response.statusCode == 200 && body is Map<String, dynamic>) {
      return body['data'] as Map<String, dynamic>;
    }

    throw Exception(_parseErrorMessage(body, 'Gagal mengubah status akun.'));
  }

  String _parseErrorMessage(dynamic body, String defaultMessage) {
    if (body is Map<String, dynamic>) {
      if (body['message'] != null) {
        return body['message'].toString();
      }
      if (body['errors'] is Map<String, dynamic>) {
        final errors = body['errors'] as Map<String, dynamic>;
        final first = errors.values.first;
        if (first is List && first.isNotEmpty) {
          return first.first.toString();
        }
      }
    }
    return defaultMessage;
  }
}
