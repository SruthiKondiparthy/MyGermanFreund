import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService {
  /// Extracts text from a given image file
  static Future<String> extractText(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

      final RecognizedText recognizedText =
      await textRecognizer.processImage(inputImage);

      await textRecognizer.close();
      return recognizedText.text;
    } catch (e) {
      print("OCR Error: $e");
      return "Failed to extract text. Please try again.";
    }
  }
}

