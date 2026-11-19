import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../models/division_model.dart';
import 'storage_service.dart';

class DivisionService {
  final StorageService _storageService;

  DivisionService({StorageService? storageService})
      : _storageService = storageService ?? StorageService();

  Future<List<DivisionModel>> getDivisions({String? search}) async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Sesi tidak ditemukan. Silakan login kembali.');
    }

    final queryParams = <String, String>{};
    if (search != null && search.trim().isNotEmpty) {
      queryParams['search'] = search.trim();
    }

    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.divisions}')
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
          .map((d) => DivisionModel.fromJson(d))
          .toList();
    }

    throw Exception(_parseErrorMessage(body, 'Gagal memuat daftar divisi.'));
  }

  Future<DivisionModel> getDivisionDetail(int id) async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Sesi tidak ditemukan. Silakan login kembali.');
    }

    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.divisionDetail(id)}'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final dynamic body = jsonDecode(response.body);

    if (response.statusCode == 200 && body is Map<String, dynamic>) {
      return DivisionModel.fromJson(body['data'] as Map<String, dynamic>);
    }

    throw Exception(_parseErrorMessage(body, 'Gagal memuat detail divisi.'));
  }

  Future<DivisionModel> createDivision(Map<String, dynamic> data) async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Sesi tidak ditemukan. Silakan login kembali.');
    }

    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminDivisions}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    final dynamic body = jsonDecode(response.body);

    if (response.statusCode == 201 && body is Map<String, dynamic>) {
      return DivisionModel.fromJson(body['data'] as Map<String, dynamic>);
    }

    throw Exception(_parseErrorMessage(body, 'Gagal menambahkan divisi baru.'));
  }

  Future<DivisionModel> updateDivision(
    int id,
    Map<String, dynamic> data,
  ) async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Sesi tidak ditemukan. Silakan login kembali.');
    }

    final response = await http.put(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminDivisionDetail(id)}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    final dynamic body = jsonDecode(response.body);

    if (response.statusCode == 200 && body is Map<String, dynamic>) {
      return DivisionModel.fromJson(body['data'] as Map<String, dynamic>);
    }

    throw Exception(_parseErrorMessage(body, 'Gagal memperbarui divisi.'));
  }

  Future<void> deleteDivision(int id) async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Sesi tidak ditemukan. Silakan login kembali.');
    }

    final response = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminDivisionDetail(id)}'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final dynamic body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return;
    }

    throw Exception(_parseErrorMessage(body, 'Gagal menghapus divisi.'));
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
