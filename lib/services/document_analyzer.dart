import 'dart:core';

class DocumentAnalyzer {
  static Map<String, dynamic> analyzeText(String text) {
    final Map<String, dynamic> info = {};

    final RegExp dateRegex = RegExp(
      r'\b(\d{1,2}[./-]\d{1,2}[./-]\d{2,4})\b',
      caseSensitive: false,
    );
    final RegExp emailRegex = RegExp(
      r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}\b',
      caseSensitive: false,
    );
    final RegExp phoneRegex = RegExp(
      r'(\+?\d{1,3}[-.\s]?)?(\(?\d{2,5}\)?[-.\s]?)?\d{3,5}[-.\s]?\d{3,5}',
      caseSensitive: false,
    );
    final RegExp paymentRegex = RegExp(
      r'\b(?:Euro|€|\$|invoice|amount|total|payment|summe)\b',
      caseSensitive: false,
    );
    final RegExp dueDateRegex = RegExp(
      r'\b(bis|fällig am|due date|Zahlungsfrist)\s*(\d{1,2}[./-]\d{1,2}[./-]\d{2,4})',
      caseSensitive: false,
    );
    final RegExp websiteRegex = RegExp(
      r'\b(?:https?:\/\/|www\.)[^\s]+',
      caseSensitive: false,
    );

    info['dates'] = dateRegex.allMatches(text).map((m) => m.group(0)!).toSet().toList();
    info['emails'] = emailRegex.allMatches(text).map((m) => m.group(0)!).toSet().toList();
    info['phones'] = phoneRegex.allMatches(text).map((m) => m.group(0)!).toSet().toList();
    info['websites'] = websiteRegex.allMatches(text).map((m) => m.group(0)!).toSet().toList();

    final dueDateMatch = dueDateRegex.firstMatch(text);
    info['dueDate'] = dueDateMatch != null ? dueDateMatch.group(2) : null;
    info['mentionsPayment'] = paymentRegex.hasMatch(text);

    info['summary'] = _generateSummary(info);

    return info;
  }

  static String _generateSummary(Map<String, dynamic> info) {
    final buffer = StringBuffer();

    buffer.writeln("📄 **Document Summary**\n");

    if (info['dueDate'] != null) buffer.writeln("🗓️ **Due Date:** ${info['dueDate']}");
    if (info['emails'].isNotEmpty) buffer.writeln("✉️ **Email:** ${info['emails'].join(', ')}");
    if (info['phones'].isNotEmpty) buffer.writeln("📞 **Phone:** ${info['phones'].join(', ')}");
    if (info['websites'].isNotEmpty) buffer.writeln("🌐 **Website:** ${info['websites'].join(', ')}");
    if (info['mentionsPayment']) buffer.writeln("💰 **Payment Information Detected**");

    if (buffer.isEmpty) buffer.writeln("No key details found.");

    return buffer.toString();
  }
}
