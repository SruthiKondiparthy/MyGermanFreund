import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class LetterResultPage extends StatelessWidget {
  final String fullText;
  final Map<String, dynamic> extractedInfo;

  const LetterResultPage({
    super.key,
    required this.fullText,
    required this.extractedInfo,
  });

  String _buildShareText({
    required String sender,
    required String letterDate,
    required String subject,
    required String summary,
    required String actionRequired,
    required List dueDates,
    required List amounts,
    required bool hasPayment,
  }) {
    final buffer = StringBuffer();

    buffer.writeln("📄 MyGermanFreund — Letter Summary");
    buffer.writeln("================================");

    if (sender.isNotEmpty) buffer.writeln("From: $sender");
    if (letterDate.isNotEmpty) buffer.writeln("Date: $letterDate");
    if (subject.isNotEmpty) buffer.writeln("Subject: $subject");

    if (summary.isNotEmpty) {
      buffer.writeln("\n📋 Summary:\n$summary");
    }

    if (actionRequired.isNotEmpty) {
      buffer.writeln("\n✅ Action Required:\n$actionRequired");
    }

    if (dueDates.isNotEmpty) {
      buffer.writeln("\n📅 Deadline: ${dueDates.join(', ')}");
    }

    if (hasPayment && amounts.isNotEmpty) {
      buffer.writeln("\n💶 Amount Due: ${amounts.join(', ')}");
    }

    buffer.writeln("\n—————————————————");
    buffer.writeln("Powered by MyGermanFreund — athirikya.com");

    return buffer.toString();
  }

  Widget _buildShareSection({
    required BuildContext context,
    required String sender,
    required String letterDate,
    required String subject,
    required String summary,
    required String actionRequired,
    required List dueDates,
    required List amounts,
    required bool hasPayment,
    required String translated,
  }) {
    final shareText = _buildShareText(
      sender: sender,
      letterDate: letterDate,
      subject: subject,
      summary: summary,
      actionRequired: actionRequired,
      dueDates: dueDates,
      amounts: amounts,
      hasPayment: hasPayment,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 8),
        const Text(
          "Share or Save",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ShareButton(
                icon: Icons.chat,
                label: "WhatsApp",
                color: const Color(0xFF25D366),
                onTap: () {
                  Share.share(
                    shareText,
                    subject: "German Letter Summary",
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ShareButton(
                icon: Icons.email,
                label: "Email",
                color: Colors.blue,
                onTap: () {
                  Share.share(
                    shareText,
                    subject: "German Letter Summary — MyGermanFreund",
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ShareButton(
                icon: Icons.copy,
                label: "Copy",
                color: Colors.deepPurple,
                onTap: () async {
                  await Clipboard.setData(
                    ClipboardData(text: shareText),
                  );

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Copied to clipboard!"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _FullTranslationSection(translatedText: translated),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final summary = extractedInfo['summary'] ?? '';
    final translated = extractedInfo['translated_text'] ?? '';
    final dueDates = extractedInfo['due_dates'] as List? ?? [];
    final amounts = extractedInfo['amounts'] as List? ?? [];
    final contacts = extractedInfo['contact_info'] as List? ?? [];
    final sender = extractedInfo['sender'] ?? '';
    final docType = extractedInfo['document_type'] ?? '';
    final urgency = extractedInfo['urgency'] ?? 'LOW';
    final actionRequired = extractedInfo['action_required'] ?? '';
    final subject = extractedInfo['subject'] ?? '';
    final letterDate = extractedInfo['letter_date'] ?? '';
    final hasPayment = extractedInfo['has_payment_due'] ?? false;

    final urgencyColor = urgency == 'HIGH'
        ? Colors.red
        : urgency == 'MEDIUM'
        ? Colors.orange
        : Colors.green;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Letter Summary"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: urgencyColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: urgencyColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning_amber, color: urgencyColor, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'Urgency: $urgency',
                    style: TextStyle(
                      color: urgencyColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            if (sender.isNotEmpty || docType.isNotEmpty)
              _InfoCard(
                icon: Icons.business,
                title: 'From',
                content: [sender, docType].where((e) => e.isNotEmpty).join('\n'),
                color: Colors.purple[50]!,
              ),
            const SizedBox(height: 10),

            if (letterDate.isNotEmpty)
              _InfoCard(
                icon: Icons.edit_calendar,
                title: 'Letter Date',
                content: letterDate,
                color: Colors.grey[100]!,
              ),
            const SizedBox(height: 10),

            if (subject.isNotEmpty)
              _InfoCard(
                icon: Icons.subject,
                title: 'Subject',
                content: subject,
                color: Colors.blue[50]!,
              ),
            const SizedBox(height: 10),

            if (summary.isNotEmpty)
              _InfoCard(
                icon: Icons.summarize,
                title: 'Summary',
                content: summary,
                color: Colors.indigo[50]!,
              ),
            const SizedBox(height: 10),

            if (actionRequired.isNotEmpty)
              _InfoCard(
                icon: Icons.task_alt,
                title: 'Action Required',
                content: actionRequired,
                color: Colors.orange[50]!,
              ),
            const SizedBox(height: 10),

            if (dueDates.isNotEmpty)
              _InfoCard(
                icon: Icons.calendar_today,
                title: 'Due Date',
                content: dueDates.join('\n'),
                color: Colors.red[50]!,
              ),
            const SizedBox(height: 10),

            if (hasPayment && amounts.isNotEmpty)
              _InfoCard(
                icon: Icons.euro,
                title: 'Amount Due',
                content: amounts.join('\n'),
                color: Colors.red[50]!,
              ),
            const SizedBox(height: 10),

            if (contacts.isNotEmpty)
              _InfoCard(
                icon: Icons.contact_phone,
                title: 'Contact',
                content: contacts.join('\n'),
                color: Colors.teal[50]!,
              ),
            const SizedBox(height: 24),

            _buildShareSection(
              context: context,
              sender: sender,
              letterDate: letterDate,
              subject: subject,
              summary: summary,
              actionRequired: actionRequired,
              dueDates: dueDates,
              amounts: amounts,
              hasPayment: hasPayment,
              translated: translated,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final Color color;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.content,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: Colors.black54),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

class _FullTranslationSection extends StatefulWidget {
  final String translatedText;

  const _FullTranslationSection({required this.translatedText});

  @override
  State<_FullTranslationSection> createState() =>
      _FullTranslationSectionState();
}

class _FullTranslationSectionState extends State<_FullTranslationSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.translatedText.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        OutlinedButton.icon(
          onPressed: () => setState(() => _expanded = !_expanded),
          icon: Icon(
            _expanded ? Icons.expand_less : Icons.translate,
          ),
          label: Text(
            _expanded ? "Hide Translation" : "View Full Translation",
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            side: const BorderSide(color: Colors.deepPurple),
            foregroundColor: Colors.deepPurple,
          ),
        ),
        if (_expanded) ...[
          const SizedBox(height: 12),
          _InfoCard(
            icon: Icons.translate,
            title: 'Full Translation',
            content: widget.translatedText,
            color: Colors.grey[50]!,
          ),
        ],
      ],
    );
  }
}

class _ShareButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ShareButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showErrorAndGoBack(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 28),
          SizedBox(width: 8),
          Text("Oops!!"),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(fontSize: 15, height: 1.5),
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "OK — Try Again",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    ),
  );
}