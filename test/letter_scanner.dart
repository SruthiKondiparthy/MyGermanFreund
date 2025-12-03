import 'package:flutter_test/flutter_test.dart';
import 'package:mygermanfreund/services/document_analyzer.dart';
import 'package:mygermanfreund/services/ocr_service.dart';
import 'dart:io';

void main() {
  group('OCR Service Tests', () {
    test('OCR should handle invalid file gracefully', () async {
      final result = await OcrService.extractText(File('non_existing.jpg'));
      expect(result, contains("Failed to extract"));
    });
  });

  group('Document Analyzer Tests', () {
    test('Should extract dates, emails, and phones correctly', () {
      const textSample = '''
        Dear Mr. Schmidt,
        Please send payment of €250 by 12.11.2025.
        Contact us at info@germanbank.de or call +49 176 1234567.
        Regards, Deutsche Bank
      ''';

      final result = DocumentAnalyzer.analyzeText(textSample);

      expect(result['dates'], isNotEmpty);
      expect(result['emails'], contains('info@germanbank.de'));
      expect(result['phones'].any((p) => p.contains('176')), true);
      expect(result['mentionsPayment'], true);
      expect(result['mentionsDeadline'], true);
    });
  });

  group('Integration Test', () {
    test('Combined text extraction and analysis', () async {
      // Mock OCR result (simulate extracted text)
      const mockText = "Deadline: 23.10.2025\nContact: test@demo.de\nAmount: €150";

      final result = DocumentAnalyzer.analyzeText(mockText);

      expect(result['mentionsPayment'], true);
      expect(result['mentionsDeadline'], true);
      expect(result['emails'].first, "test@demo.de");
    });
  });
}
