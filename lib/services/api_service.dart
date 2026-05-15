import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

enum OutputLanguage {
  english,
  simpleGerman,
}

class ApiService {
  static const String _baseUrl = 'http://192.168.0.215:8000';
  static const String _userId = 'demo-user';

  static const Duration _analyzeTimeout = Duration(seconds: 45);
  static const Duration _deepAnalysisTimeout = Duration(seconds: 60);
  static const Duration _quotaTimeout = Duration(seconds: 10);

  static String _languageToString(OutputLanguage language) {
    switch (language) {
      case OutputLanguage.english:
        return 'english';
      case OutputLanguage.simpleGerman:
        return 'simple_german';
    }
  }

  // ─── Analyze Letter ────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> analyzeLetter(
      String ocrText, {
        OutputLanguage language = OutputLanguage.english,
      }) async {
    try {
      final response = await http
          .post(
        Uri.parse('$_baseUrl/api/scanner/analyze'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'user_id': _userId,
          'ocr_text': ocrText,
          'output_language': _languageToString(language),
        }),
      )
          .timeout(
        _analyzeTimeout,
        onTimeout: () {
          throw TimeoutException(
            "Analysis timed out. Please try again.",
            _analyzeTimeout,
          );
        },
      );

      switch (response.statusCode) {
        case 200:
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          return _validateResponse(data);
        case 400:
          final error = jsonDecode(response.body);
          throw Exception(error['detail'] ?? 'Invalid document');
        case 429:
          throw Exception('429: Monthly scan limit reached');
        case 503:
          throw Exception('Service temporarily unavailable.');
        default:
          throw Exception('Server error. Please try again.');
      }
    } on TimeoutException {
      rethrow;
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid server response. Please try again.');
    }
  }

  // ─── Deep Analysis — Premium Only!! ───────────────────────────────────────
  static Future<Map<String, dynamic>> deepAnalysis(
      String ocrText,
      String summary, {
        OutputLanguage language = OutputLanguage.english,
      }) async {
    try {
      final response = await http
          .post(
        Uri.parse('$_baseUrl/api/scanner/deep-analysis'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'user_id': _userId,
          'ocr_text': ocrText,
          'summary': summary,
          'output_language': _languageToString(language),
        }),
      )
          .timeout(
        _deepAnalysisTimeout,  // Longer timeout — more complex!!
        onTimeout: () {
          throw TimeoutException(
            "Deep analysis timed out. Please try again.",
            _deepAnalysisTimeout,
          );
        },
      );

      switch (response.statusCode) {
        case 200:
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          return _validateDeepAnalysisResponse(data);
        case 403:
        // Premium required — Flutter shows paywall!!
          throw Exception('PREMIUM_REQUIRED');
        case 400:
          final error = jsonDecode(response.body);
          throw Exception(error['detail'] ?? 'Invalid request');
        case 503:
          throw Exception('Deep analysis unavailable. Please try again.');
        default:
          throw Exception('Server error. Please try again.');
      }
    } on TimeoutException {
      rethrow;
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid server response. Please try again.');
    }
  }

  // ─── Get Quota ─────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> getQuota() async {
    final response = await http
        .get(
      Uri.parse('$_baseUrl/api/scanner/quota/$_userId'),
    )
        .timeout(_quotaTimeout);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception('Failed to load quota');
  }

  // ─── Validate Basic Response ───────────────────────────────────────────────
  static Map<String, dynamic> _validateResponse(Map<String, dynamic> r) {
    return {
      'summary': r['summary'] ?? '',
      'translated_text': r['translated_text'] ?? '',
      'urgency': _validateUrgency(r['urgency']),
      'due_dates': _validateList(r['due_dates']),
      'amounts': _validateList(r['amounts']),
      'contact_info': _validateList(r['contact_info']),
      'reference_numbers': _validateList(r['reference_numbers']),
      'sender': r['sender'] ?? '',
      'document_type': r['document_type'] ?? '',
      'action_required': r['action_required'] ?? '',
      'has_payment_due': r['has_payment_due'] ?? false,
      'premium': r['premium'] ?? false,
      'subject': r['subject'] ?? '',
      'letter_date': r['letter_date'] ?? '',
      'is_invitation': r['is_invitation'] ?? false,
      'venue_address': r['venue_address'] ?? '',
      'appointment_date': r['appointment_date'] ?? '',
      'output_language': r['output_language'] ?? 'english',
    };
  }

  // ─── Validate Deep Analysis Response ──────────────────────────────────────
  static Map<String, dynamic> _validateDeepAnalysisResponse(
      Map<String, dynamic> r) {
    return {
      'section_breakdown': _validateDeepList(r['section_breakdown']),
      'legal_references': _validateDeepList(r['legal_references']),
      'your_rights': _validateList(r['your_rights']),
      'consequences_if_ignored': r['consequences_if_ignored'] ?? '',
      'recommended_next_steps': _validateList(r['recommended_next_steps']),
      'helpful_phrases': _validateDeepList(r['helpful_phrases']),
    };
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────
  static String _validateUrgency(dynamic urgency) {
    const valid = ['HIGH', 'MEDIUM', 'LOW'];
    if (urgency is String && valid.contains(urgency.toUpperCase())) {
      return urgency.toUpperCase();
    }
    return 'LOW';
  }

  static List<String> _validateList(dynamic value) {
    if (value is List) {
      return value
          .map((e) => e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    }
    return [];
  }

  // For lists of maps (section_breakdown, legal_references etc)
  static List<Map<String, dynamic>> _validateDeepList(dynamic value) {
    if (value is List) {
      return value
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    return [];
  }
}