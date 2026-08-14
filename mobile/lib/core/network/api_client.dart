import 'dart:convert';

import 'package:http/http.dart' as http;

import '../storage/token_storage.dart';

class ApiClient {
  final TokenStorage _tokenStorage;

  ApiClient({TokenStorage? tokenStorage})
    : _tokenStorage = tokenStorage ?? TokenStorage();

  Future<Map<String, dynamic>> get(String url) async {
    final response = await http.get(Uri.parse(url), headers: await _headers());

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    final response = await http.post(
      Uri.parse(url),
      headers: await _headers(),
      body: body == null ? null : jsonEncode(body),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    final response = await http.put(
      Uri.parse(url),
      headers: await _headers(),
      body: body == null ? null : jsonEncode(body),
    );

    return _handleResponse(response);
  }

  Future<void> delete(String url) async {
    final response = await http.delete(
      Uri.parse(url),
      headers: await _headers(),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      _handleResponse(response);
    }
  }

  Future<Map<String, String>> _headers() async {
    final token = await _tokenStorage.getAccessToken();

    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final decoded = response.body.isNotEmpty
        ? jsonDecode(response.body)
        : <String, dynamic>{};

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Map<String, dynamic>.from(decoded);
    }

    final message = decoded is Map<String, dynamic>
        ? decoded['message']?.toString()
        : null;

    throw ApiException(message ?? 'Request failed', response.statusCode);
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  const ApiException(this.message, this.statusCode);

  @override
  String toString() {
    return 'ApiException($statusCode): $message';
  }
}
