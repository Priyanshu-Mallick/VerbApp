import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import 'shared_preference_service.dart';

class ApiService {
  static const String baseUrl = 'https://fastapi-example-czxp.onrender.com';
  final SharedPreferenceService _sharedPreferenceService =
      SharedPreferenceService();

  static IOClient getHttpClient() {
    // Bypass SSL certificate check
    final ioc = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    return IOClient(ioc);
  }

  // Helper function to get the access token from shared preferences
  Future<String?> _getAccessToken() async {
    return await _sharedPreferenceService.getAccessToken();
  }

  // Post request with optional content type
  Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body, {
    String contentType = 'application/json',
  }) async {
    final client = getHttpClient();
    final url = Uri.parse('$baseUrl$endpoint');

    // Get the access token from shared preferences
    String? token = await _getAccessToken();

    Map<String, String> headers = {
      'Content-Type': contentType,
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await client.post(
      url,
      headers: headers,
      body: contentType == 'application/json' ? jsonEncode(body) : body,
    );

    return response;
  }

  // Get request with Bearer token
  Future<http.Response> get(String endpoint) async {
    final client = getHttpClient();
    final url = Uri.parse('$baseUrl$endpoint');

    // Get the access token from shared preferences
    String? token = await _getAccessToken();

    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    return response;
  }
}
