import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _shareSummary(String summary) async {
    final text = '''Letter Summary\n\n$summary\n\n---\nTranslated Text:\n$translatedText''';
    await SharePlus.instance.share(ShareParams(text: text));
  }

  Future<void> _addDueDateToGoogleCalendar(String dueDate) async {
    final parsedDate = _parseDueDate(dueDate);
    if (parsedDate == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not parse due date for calendar.')),
      );
      return;
    }

    final start = DateTime(parsedDate.year, parsedDate.month, parsedDate.day, 9, 0);
    final end = start.add(const Duration(hours: 1));
    final fmt = DateFormat("yyyyMMdd'T'HHmmss'Z'");
    final startUtc = fmt.format(start.toUtc());
    final endUtc = fmt.format(end.toUtc());

    final details = Uri.encodeComponent(
      'Reminder from MyGermanFreund scanner. Please complete the required action before deadline.',
    );
    final eventText = Uri.encodeComponent('Important Due Date from German Letter');

    final calendarUrl = Uri.parse(
      'https://calendar.google.com/calendar/render?action=TEMPLATE&text=$eventText&dates=$startUtc/$endUtc&details=$details',
    );

    if (await canLaunchUrl(calendarUrl)) {
      await launchUrl(calendarUrl, mode: LaunchMode.externalApplication);
    }
  }

  DateTime? _parseDueDate(String value) {
    final patterns = [
      DateFormat('dd.MM.yyyy'),
      DateFormat('d.M.yyyy'),
      DateFormat('dd/MM/yyyy'),
      DateFormat('yyyy-MM-dd'),
    ];

    for (final pattern in patterns) {
      try {
        return pattern.parseStrict(value.trim());
      } catch (_) {
        continue;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final summary = widget.extractedInfo['summary'] ?? 'No summary available';
    final dueDate = widget.extractedInfo['dueDate']?.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Letter Summary'),
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
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _shareSummary(summary),
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        showDragHandle: true,
                        builder: (_) => _DeepAnalysisSheet(
                          extractedInfo: widget.extractedInfo,
                          translatedText: translatedText,
                          rawText: widget.fullText,
                        ),
                      );
                    },
                    icon: const Icon(Icons.psychology_alt_outlined),
                    label: const Text('Deep Analysis'),
                  ),
                ),
              ],
            ),
            if (dueDate != null && dueDate.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _addDueDateToGoogleCalendar(dueDate),
                      icon: const Icon(Icons.calendar_month),
                      label: Text('Add due date ($dueDate) to Google Calendar'),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            isTranslating
                ? const Center(child: CircularProgressIndicator())
                : Card(
                    color: Colors.green[50],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        translatedText.isEmpty ? 'No translation available.' : translatedText,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
            const SizedBox(height: 12),
            const Divider(),
            const Text(
              '⚙️ Debug Info (Extracted Text Below)',
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

class _DeepAnalysisSheet extends StatelessWidget {
  final Map<String, dynamic> extractedInfo;
  final String translatedText;
  final String rawText;

  const _DeepAnalysisSheet({
    required this.extractedInfo,
    required this.translatedText,
    required this.rawText,
  });

  @override
  Widget build(BuildContext context) {
    final amount = extractedInfo['amount'] ?? 'Not found';
    final dueDate = extractedInfo['dueDate'] ?? 'Not found';
    final contact = extractedInfo['contactInfo'] ?? 'Not found';
    final reference = extractedInfo['referenceNumber'] ?? 'Not found';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          shrinkWrap: true,
          children: [
            const Text(
              'Deep Analysis',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _kv('Due date', dueDate.toString()),
            _kv('Amount', amount.toString()),
            _kv('Contact info', contact.toString()),
            _kv('Reference', reference.toString()),
            const SizedBox(height: 12),
            const Text('Action Guidance', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text(
              '- Verify due dates and amounts from original letter.\n'
              '- Contact office using provided contact info for clarifications.\n'
              '- Keep reference number for all follow-up communication.',
            ),
            const SizedBox(height: 12),
            const Text('Translated Letter', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(translatedText.isEmpty ? 'Translation not ready yet.' : translatedText),
            const SizedBox(height: 12),
            const Text('Raw OCR Text', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(rawText),
          ],
        ),
      ),
    );
  }

  Widget _kv(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
