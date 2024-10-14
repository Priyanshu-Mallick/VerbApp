import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import 'shared_preference_service.dart';

class ApiService {
  static const String baseUrl = 'https://fastapi-example-czxp.onrender.com';

  static IOClient getHttpClient() {
    // Bypass SSL certificate check
    final ioc = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    return IOClient(ioc);
  }

  // Post request with JSON body
  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final client = getHttpClient();
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await client.post(
      url,
      body: jsonEncode(body),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );
    return response;
  }

  // Verify if the email is registered
  Future<Map<String, dynamic>?> verifySchool(String email) async {
    final response = await post('/schools/verify', {"email": email});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
}
