import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../models/user_model.dart';
import 'storage_service.dart';

class AuthService {
  final StorageService _storageService;

  AuthService({StorageService? storageService})
      : _storageService = storageService ?? StorageService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email.trim(),
        'password': password,
      }),
    );

    final dynamic body = jsonDecode(response.body);

    if (response.statusCode == 200 && body is Map<String, dynamic>) {
      final data = body['data'] as Map<String, dynamic>;
      final token = data['token']?.toString() ?? '';
      await _storageService.saveToken(token);

      return {
        'user': UserModel.fromJson(data['user'] as Map<String, dynamic>),
        'token': token,
        'must_change_password': data['must_change_password'] == true ||
            data['must_change_password'] == 1,
      };
    }

    String errorMessage = 'Login gagal.';
    if (body is Map<String, dynamic>) {
      if (body['message'] != null) {
        errorMessage = body['message'].toString();
      } else if (body['errors'] is Map<String, dynamic>) {
        final errors = body['errors'] as Map<String, dynamic>;
        final firstError = errors.values.first;
        if (firstError is List && firstError.isNotEmpty) {
          errorMessage = firstError.first.toString();
        }
      }
    }

    throw Exception(errorMessage);
  }

  Future<UserModel?> getProfile() async {
    final token = await _storageService.getToken();
    if (token == null) return null;

    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.user}'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final dynamic body = jsonDecode(response.body);
      if (body is Map<String, dynamic>) {
        final userJson = body['data'] is Map<String, dynamic>
            ? body['data'] as Map<String, dynamic>
            : body;
        return UserModel.fromJson(userJson);
      }
    } else if (response.statusCode == 401) {
      await _storageService.deleteToken();
    }

    return null;
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Sesi tidak ditemukan. Silakan login kembali.');
    }

    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.changePassword}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      }),
    );

    final dynamic body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return;
    }

    String errorMessage = 'Gagal mengubah password.';
    if (body is Map<String, dynamic>) {
      if (body['message'] != null) {
        errorMessage = body['message'].toString();
      } else if (body['errors'] is Map<String, dynamic>) {
        final errors = body['errors'] as Map<String, dynamic>;
        final firstError = errors.values.first;
        if (firstError is List && firstError.isNotEmpty) {
          errorMessage = firstError.first.toString();
        }
      }
    }

    throw Exception(errorMessage);
  }

  Future<void> logout() async {
    final token = await _storageService.getToken();

    if (token != null) {
      try {
        await http.post(
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.logout}'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      } catch (_) {
        // Abaikan kesalahan koneksi saat logout agar sesi lokal tetap terhapus
      }
    }

    await _storageService.deleteToken();
  }
}
