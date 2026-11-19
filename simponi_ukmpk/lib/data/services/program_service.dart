import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../models/program_model.dart';
import 'storage_service.dart';

class ProgramService {
  final StorageService _storageService;

  ProgramService({StorageService? storageService})
      : _storageService = storageService ?? StorageService();

  Future<List<ProgramModel>> getPrograms({
    String? search,
    int? divisionId,
    String? status,
  }) async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Sesi tidak ditemukan. Silakan login kembali.');
    }

    final queryParams = <String, String>{};
    if (search != null && search.trim().isNotEmpty) {
      queryParams['search'] = search.trim();
    }
    if (divisionId != null && divisionId > 0) {
      queryParams['division_id'] = divisionId.toString();
    }
    if (status != null && status.isNotEmpty && status != 'Semua') {
      queryParams['status'] = status;
    }

    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.programs}')
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
      final list = body['data'] as List<dynamic>? ?? [];
      return list
          .whereType<Map<String, dynamic>>()
          .map((p) => ProgramModel.fromJson(p))
          .toList();
    }

    throw Exception(_parseErrorMessage(body, 'Gagal memuat daftar program kerja.'));
  }

  Future<ProgramModel> getProgramDetail(int id) async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Sesi tidak ditemukan. Silakan login kembali.');
    }

    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.programDetail(id)}'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final dynamic body = jsonDecode(response.body);

    if (response.statusCode == 200 && body is Map<String, dynamic>) {
      return ProgramModel.fromJson(body['data'] as Map<String, dynamic>);
    }

    throw Exception(_parseErrorMessage(body, 'Gagal memuat detail program kerja.'));
  }

  Future<ProgramModel> createProgram(Map<String, dynamic> data) async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Sesi tidak ditemukan. Silakan login kembali.');
    }

    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.programs}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    final dynamic body = jsonDecode(response.body);

    if (response.statusCode == 201 && body is Map<String, dynamic>) {
      return ProgramModel.fromJson(body['data'] as Map<String, dynamic>);
    }

    throw Exception(_parseErrorMessage(body, 'Gagal membuat program kerja baru.'));
  }

  Future<ProgramModel> updateProgram(int id, Map<String, dynamic> data) async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Sesi tidak ditemukan. Silakan login kembali.');
    }

    final response = await http.put(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.programDetail(id)}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    final dynamic body = jsonDecode(response.body);

    if (response.statusCode == 200 && body is Map<String, dynamic>) {
      return ProgramModel.fromJson(body['data'] as Map<String, dynamic>);
    }

    throw Exception(_parseErrorMessage(body, 'Gagal memperbarui program kerja.'));
  }

  Future<void> updateProgramStatus(int id, String status) async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Sesi tidak ditemukan. Silakan login kembali.');
    }

    final response = await http.patch(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.programStatus(id)}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'status': status}),
    );

    final dynamic body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return;
    }

    throw Exception(_parseErrorMessage(body, 'Gagal mengubah status program kerja.'));
  }

  Future<void> deleteProgram(int id) async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Sesi tidak ditemukan. Silakan login kembali.');
    }

    final response = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.programDetail(id)}'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final dynamic body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return;
    }

    throw Exception(_parseErrorMessage(body, 'Gagal menghapus program kerja.'));
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
