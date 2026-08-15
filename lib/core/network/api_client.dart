import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_config.dart';

/// Thin client mirroring `apiFetch` from the React `lib/api.ts`.
class ApiClient {
  ApiClient({http.Client? client, this.tokenProvider})
      : _client = client ?? http.Client();

  final http.Client _client;
  final Future<String?> Function()? tokenProvider;

  Future<http.Response> fetch(
    String path, {
    String method = 'GET',
    Map<String, String>? headers,
    Object? body,
  }) async {
    final uri = Uri.parse(ApiConfig.url(path));
    final h = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...?headers,
    };
    final token = tokenProvider != null ? await tokenProvider!() : null;
    if (token != null && token.isNotEmpty) {
      h['Authorization'] = 'Bearer $token';
    }

    switch (method.toUpperCase()) {
      case 'POST':
        return _client.post(uri, headers: h, body: body is String ? body : jsonEncode(body));
      case 'PUT':
        return _client.put(uri, headers: h, body: body is String ? body : jsonEncode(body));
      case 'PATCH':
        return _client.patch(uri, headers: h, body: body is String ? body : jsonEncode(body));
      case 'DELETE':
        return _client.delete(uri, headers: h);
      default:
        return _client.get(uri, headers: h);
    }
  }

  Future<Map<String, dynamic>> getJson(String path) async {
    final res = await fetch(path);
    final text = res.body;
    if (text.isEmpty) return {};
    final decoded = jsonDecode(text);
    if (decoded is Map<String, dynamic>) return decoded;
    return {'data': decoded};
  }

  Future<List<dynamic>> getList(String path) async {
    final res = await fetch(path);
    final text = res.body;
    if (text.isEmpty) return [];
    final decoded = jsonDecode(text);
    if (decoded is List) return decoded;
    if (decoded is Map && decoded['data'] is List) return decoded['data'] as List;
    return [];
  }
}
