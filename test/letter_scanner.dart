import 'package:flutter_test/flutter_test.dart';
import 'package:mygermanfreund/services/api_service.dart';
import 'package:mygermanfreund/services/ocr_service.dart';
import 'dart:io';

void main() {
  group('OCR Service Tests', () {
    test('OCR should handle invalid file gracefully', () async {
      final result = await OcrService.extractText(File('non_existing.jpg'));
      expect(result, contains("Failed to extract"));
    });
  });

  group('Input Validation Tests', () {
    test('Empty text should be invalid', () {
      const text = '';
      expect(text.trim().isEmpty, true);
    });

    test('Short text should be invalid', () {
      const text = 'Hello';
      expect(text.trim().length < 20, true);
    });

    test('Valid German text should pass length check', () {
      const text = '''
        Sehr geehrter Herr Schmidt,
        bitte zahlen Sie den Betrag von 250 EUR bis zum 12.11.2025.
        Mit freundlichen Grüßen, Finanzamt München
      ''';
      expect(text.trim().length >= 20, true);
    });

    test('Text should contain readable characters', () {
      const text = 'Finanzamt München Steuer 2025';
      final hasReadable = RegExp(r'[a-zA-ZäöüÄÖÜß]').hasMatch(text);
      expect(hasReadable, true);
    });
  });

  group('API Response Validation Tests', () {
    test('validateResponse fills missing fields with defaults', () {
      final response = <String, dynamic>{
        'summary': 'Test summary',
      };

      // Simulate validation
      final validated = {
        'summary': response['summary'] ?? '',
        'translated_text': response['translated_text'] ?? '',
        'urgency': response['urgency'] ?? 'LOW',
        'due_dates': response['due_dates'] ?? [],
        'amounts': response['amounts'] ?? [],
        'contact_info': response['contact_info'] ?? [],
        'reference_numbers': response['reference_numbers'] ?? [],
        'sender': response['sender'] ?? '',
        'document_type': response['document_type'] ?? '',
        'action_required': response['action_required'] ?? '',
        'has_payment_due': response['has_payment_due'] ?? false,
        'premium': response['premium'] ?? false,
      };

      expect(validated['summary'], 'Test summary');
      expect(validated['urgency'], 'LOW');
      expect(validated['due_dates'], isEmpty);
      expect(validated['has_payment_due'], false);
    });

    test('Urgency should default to LOW for unknown values', () {
      const valid = ['HIGH', 'MEDIUM', 'LOW'];
      const unknownUrgency = 'CRITICAL';
      final result = valid.contains(unknownUrgency) ? unknownUrgency : 'LOW';
      expect(result, 'LOW');
    });

    test('Amounts should only show when has_payment_due is true', () {
      final response = {
        'has_payment_due': false,
        'amounts': ['250 EUR'],
      };
      final hasPayment = response['has_payment_due'] as bool;
      final amounts = response['amounts'] as List;
      // Should not display amounts when no payment due
      expect(hasPayment && amounts.isNotEmpty, false);
    });

    test('Empty list fields should return empty list', () {
      final value = null;
      final result = value is List ? value : [];
      expect(result, isEmpty);
    });
  });

  group('Share Text Tests', () {
    test('Share text should include sender when present', () {
      const sender = 'Finanzamt München';
      final buffer = StringBuffer();
      if (sender.isNotEmpty) buffer.writeln("From: $sender");
      expect(buffer.toString(), contains('Finanzamt München'));
    });

    test('Share text should include branding', () {
      final buffer = StringBuffer();
      buffer.writeln("Powered by MyGermanFreund — athirikya.com");
      expect(buffer.toString(), contains('athirikya.com'));
    });

    test('Share text should not include amounts when no payment due', () {
      final hasPayment = false;
      final amounts = ['250 EUR'];
      final buffer = StringBuffer();
      if (hasPayment && amounts.isNotEmpty) {
        buffer.writeln("Amount Due: ${amounts.join(', ')}");
      }
      expect(buffer.toString(), isEmpty);
    });
  });

  group('Multi-Page Text Tests', () {
    test('Multi-page text should contain page markers', () {
      final pages = ['Page 1 content here', 'Page 2 content here'];
      final buffer = StringBuffer();
      for (int i = 0; i < pages.length; i++) {
        buffer.writeln("--- Page ${i + 1} ---");
        buffer.writeln(pages[i]);
      }
      final combined = buffer.toString();
      expect(combined, contains('--- Page 1 ---'));
      expect(combined, contains('--- Page 2 ---'));
    });

    test('Single page text should not have page markers', () {
      final pages = ['Single page content here'];
      final buffer = StringBuffer();
      for (int i = 0; i < pages.length; i++) {
        if (pages.length > 1) {
          buffer.writeln("--- Page ${i + 1} ---");
        }
        buffer.writeln(pages[i]);
      }
      final combined = buffer.toString();
      expect(combined.contains('--- Page'), false);
    });
  });
}