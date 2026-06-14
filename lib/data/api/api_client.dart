import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payouts_platform/services/auth_service.dart';

class ApiClient {
  final AuthService _authService;

  ApiClient(this._authService);

  Future<Map<String, String>> _headers({bool withAuth = true}) async {
    final headers = {'Content-Type': 'application/json'};
    if (withAuth) {
      final token = await _authService.getAccessToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  // Get 

  Future<http.Response> get(String url) async {
    return http.get(
      Uri.parse(url),
      headers: await _headers(),
    );
  }

  // Post

  Future<http.Response> post(
    String url, {
    Map<String, dynamic>? body,
    bool withAuth = true,
  }) async {
    return http.post(
      Uri.parse(url),
      headers: await _headers(withAuth: withAuth),
      body: body != null ? jsonEncode(body) : null,
    );
  }

  // Patch

  Future<http.Response> patch(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    return http.patch(
      Uri.parse(url),
      headers: await _headers(),
      body: body != null ? jsonEncode(body) : null,
    );
  }

  // Delete

  Future<http.Response> delete(String url) async {
    return http.delete(
      Uri.parse(url),
      headers: await _headers(),
    );
  }
}