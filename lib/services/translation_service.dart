import 'package:translator/translator.dart';

class TranslationService {
  static final _translator = GoogleTranslator();

  /// Translates German → English
  static Future<String> translateToEnglish(String text) async {
    if (text.trim().isEmpty) return "No text available for translation.";

    try {
      final translation = await _translator.translate(text, from: 'de', to: 'en');
      return translation.text;
    } catch (e) {
      print("Translation error: $e");
      return "Translation failed. Please check your connection.";
    }
  }
}

