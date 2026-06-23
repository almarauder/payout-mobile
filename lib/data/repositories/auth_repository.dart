import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/api_client.dart';
import '../api/api_constant.dart';
import '../models/auth_token_model.dart';
import '../models/user_model.dart';
import '../../services/auth_service.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final AuthService _authService;

  AuthRepository(this._apiClient, this._authService);

  Future<void> registerCompany({
    required String companyName,
    required String bin,
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstant.register,
      body: {
        'company_name': companyName,
        'bin': bin,
        'username': username,
        'email': email,
        'password': password,
      },
      withAuth: false,
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      final error = _parseError(response);
      throw AuthException(error);
    }
  }

  Future<void> registerContractor({
    required String username,
    required String email,
    required String password,
    bool isSelfEmployed = true,
  }) async {
    final response = await _apiClient.post(
      ApiConstant.registerContractor,
      body: {
        'userame': username, 
        'email': email,
        'password': password,
        'selfEmployed': isSelfEmployed,
      },
      withAuth: false,
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      final error = _parseError(response);
      throw AuthException(error);
    }
  }

  Future<AuthTokenModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstant.login,
      body: {
        'email': email,
        'password': password,
      },
      withAuth: false,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final tokens = AuthTokenModel.fromJson(json);

      await _authService.saveTokens(
        access: tokens.access,
        refresh: tokens.refresh,
      );

      return tokens;
    } else {
      final error = _parseError(response);
      throw AuthException(error);
    }
  }

  Future<UserModel> getCurrentUser() async {
    final response = await _apiClient.get(ApiConstant.me);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return UserModel.fromJson(json);
    } else if (response.statusCode == 401) {
      throw AuthException('Не авторизован. Войдите заново.');
    } else {
      throw AuthException(_parseError(response));
    }
  }

  Future<void> logout() async {
    await _authService.clearTokens();
  }

  String _parseError(http.Response response) {
    try {
      final json = jsonDecode(response.body);
      if (json is Map) {
        if (json.containsKey('detail')) return json['detail'].toString();
        return json.values.first.toString();
      }
    } catch (_) {}
    return 'Ошибка ${response.statusCode}';
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}