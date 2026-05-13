import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;

class ApiService {
  // Change this to your actual IP when testing on phone
  // For emulator use: http://10.0.2.2:8000
  // For real device use: http://YOUR_PC_IP:8000
  /*static const String _baseUrl = 'http://10.0.2.2:8000';
  static const String _userId = 'demo-user';*/
  static const String _baseUrl = 'http://192.168.0.215:8000';
  static const String _userId = 'demo-user';

  static Future<Map<String, dynamic>> analyzeLetter(String ocrText) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/scanner/analyze'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': _userId,
          'ocr_text': ocrText,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Analysis failed');
      }
    } on SocketException {
      throw Exception('No connection. Please check your internet.');
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}