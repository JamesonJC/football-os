import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
 static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

 Future<Map<String, dynamic>> checkHealth() async {
  final uri = Uri.parse('$baseUrl/health/');

  final response = await http.get(uri).timeout(
   const Duration(seconds: 10),
  );

  if (response.statusCode == 200) {
   return jsonDecode(response.body) as Map<String, dynamic>;
  }

  throw Exception(
   'Health check failed: ${response.statusCode}',
  );
 }
}