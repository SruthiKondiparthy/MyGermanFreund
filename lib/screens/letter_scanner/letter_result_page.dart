import 'package:flutter/material.dart';
import '../../services/translation_service.dart';

class LetterResultPage extends StatefulWidget {
  final String fullText;
  final Map<String, dynamic> extractedInfo;

  const LetterResultPage({super.key, required this.fullText, required this.extractedInfo});

  @override
  State<LetterResultPage> createState() => _LetterResultPageState();
}

class _LetterResultPageState extends State<LetterResultPage> {
  String translatedText = '';
  bool isTranslating = false;

  @override
  void initState() {
    super.initState();
    _translateText();
  }

  Future<void> _translateText() async {
    setState(() => isTranslating = true);
    final result = await TranslationService.translateToEnglish(widget.fullText);
    if (!mounted) return;
    setState(() {
      translatedText = result;
      isTranslating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final summary = widget.extractedInfo['summary'] ?? 'No summary available';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Letter Summary"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              color: Colors.blue[50],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(summary, style: const TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
            isTranslating
                ? const Center(child: CircularProgressIndicator())
                : Card(
              color: Colors.green[50],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  translatedText.isEmpty ? "No translation available." : translatedText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const Text(
              "⚙️ Debug Info (Extracted Text Below)",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.fullText, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
