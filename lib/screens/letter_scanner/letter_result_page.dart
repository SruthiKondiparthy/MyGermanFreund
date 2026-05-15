//import 'package:add_2_calendar/add_2_calendar.dart';
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

  // Build share text
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

    if (sender.isNotEmpty) {
      buffer.writeln("From: $sender");
    }

    if (letterDate.isNotEmpty) {
      buffer.writeln("Date: $letterDate");
    }

    if (subject.isNotEmpty) {
      buffer.writeln("Subject: $subject");
    }

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
        const SizedBox(height: 12),

        // Single Share Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () => Share.share(
              shareText,
              subject: "German Letter Summary — MyGermanFreund",
            ),
            icon: const Icon(Icons.share),
            label: const Text(
              "Share Summary",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C3CE1),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        // Add To Calendar — only if due date exists!!
        /*if (dueDates.isNotEmpty) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () => _addToCalendar(
                context: context,
                subject: subject,
                sender: sender,
                dueDates: dueDates,
                actionRequired: actionRequired,
              ),
              icon: const Icon(Icons.calendar_today),
              label: const Text(
                "Add Deadline to Calendar",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFFF9500),
                side: const BorderSide(
                  color: Color(0xFFFF9500),
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],*/

        const SizedBox(height: 16),
        _FullTranslationSection(translatedText: translated),
      ],
    );
  }

// Add to calendar function
/*  void _addToCalendar({
    required BuildContext context,
    required String subject,
    required String sender,
    required List dueDates,
    required String actionRequired,
  }) {
    try {
      // Parse first due date
      final dueDateStr = dueDates.first.toString();

      // Try to parse German date format DD.MM.YYYY
      DateTime? eventDate;
      try {
        final parts = dueDateStr.split('.');
        if (parts.length == 3) {
          eventDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
            9, 0, // 9:00 AM default
          );
        }
      } catch (_) {
        eventDate = DateTime.now().add(const Duration(days: 7));
      }

      final event = Event(
        title: subject.isNotEmpty
            ? "📄 $subject"
            : "📄 German Letter Deadline",
        description: actionRequired.isNotEmpty
            ? "$actionRequired\n\nFrom: $sender\nTracked by MyGermanFreund"
            : "Letter from $sender\nTracked by MyGermanFreund",
        location: '',
        startDate: eventDate ?? DateTime.now().add(const Duration(days: 7)),
        endDate: (eventDate ?? DateTime.now().add(const Duration(days: 7)))
            .add(const Duration(hours: 1)),
        allDay: false,
      );

      Add2Calendar.addEvent2Cal(event);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Could not open calendar. Please add manually."),
        ),
      );
    }
  } */

  @override
  Widget build(BuildContext context) {
    final summary = extractedInfo['summary'] ?? '';
    final translated = extractedInfo['translated_text'] ?? '';
    final dueDates = extractedInfo['due_dates'] as List? ?? [];
    final amounts = extractedInfo['amounts'] as List? ?? [];
    final contacts = extractedInfo['contact_info'] as List? ?? [];
    final sender = extractedInfo['sender'] ?? '';
    final docType = extractedInfo['document_type'] ?? '';
    final urgency = (extractedInfo['urgency'] ?? 'LOW').toString().toUpperCase();
    final actionRequired = extractedInfo['action_required'] ?? '';
    final subject = extractedInfo['subject'] ?? '';
    final letterDate = extractedInfo['letter_date'] ?? '';
    final hasPayment = extractedInfo['has_payment_due'] ?? false;
    final isInvitation = extractedInfo['is_invitation'] ?? false;
    final venueAddress = extractedInfo['venue_address'] ?? '';
    final appointmentDate = extractedInfo['appointment_date'] ?? '';

    // Vibrant urgency colors
    final urgencyColor = urgency == 'HIGH'
        ? const Color(0xFFFF3B30)
        : urgency == 'MEDIUM'
        ? const Color(0xFFFF9500)
        : const Color(0xFF34C759);

    final urgencyIcon = urgency == 'HIGH'
        ? Icons.error_outline
        : urgency == 'MEDIUM'
        ? Icons.warning_amber
        : Icons.check_circle_outline;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Letter Summary"),
        backgroundColor: const Color(0xFF6C3CE1),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [

            // 1. Urgency Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: urgencyColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: urgencyColor, width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(urgencyIcon, color: urgencyColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    urgency == 'HIGH'
                        ? '🔴 High Priority — Action Needed'
                        : urgency == 'MEDIUM'
                        ? '🟡 Medium Priority'
                        : '🟢 Low Priority — Informational',
                    style: TextStyle(
                      color: urgencyColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 2. Sender + Document Type
            if (sender.isNotEmpty || docType.isNotEmpty)
              _InfoCard(
                icon: Icons.business,
                title: 'From',
                content: [sender, docType]
                    .where((e) => e.isNotEmpty)
                    .join('\n'),
                color: const Color(0xFFF0EBFF),
                iconColor: const Color(0xFF6C3CE1),
              ),
            const SizedBox(height: 10),

            // 3. Letter Date
            if (letterDate.isNotEmpty)
              _InfoCard(
                icon: Icons.send,
                title: 'Letter Date',
                content: letterDate,
                color: const Color(0xFFF5F5F5),
                iconColor: Colors.black54,
              ),
            const SizedBox(height: 10),

            // 4. Subject
            if (subject.isNotEmpty)
              _InfoCard(
                icon: Icons.subject,
                title: 'Subject',
                content: subject,
                color: const Color(0xFFE8F4FD),
                iconColor: const Color(0xFF007AFF),
              ),
            const SizedBox(height: 10),

            // 5. Summary
            if (summary.isNotEmpty)
              _InfoCard(
                icon: Icons.summarize,
                title: 'Summary',
                content: summary,
                color: const Color(0xFFEEF0FF),
                iconColor: const Color(0xFF5856D6),
              ),
            const SizedBox(height: 10),

            // 6. Action Required
            if (actionRequired.isNotEmpty)
              _InfoCard(
                icon: Icons.task_alt,
                title: 'Action Required',
                content: actionRequired,
                color: const Color(0xFFFFF3E0),
                iconColor: const Color(0xFFFF9500),
              ),
            const SizedBox(height: 10),

            // 7. Due Date — deadline only!!
            if (dueDates.isNotEmpty)
              _InfoCard(
                icon: Icons.alarm,
                title: 'Action Deadline',
                content: dueDates.join('\n'),
                color: const Color(0xFFFFEBEE),
                iconColor: const Color(0xFFFF3B30),
              ),
            const SizedBox(height: 10),

            // 8. Amount — ONLY when payment is due!!
            if (hasPayment && amounts.isNotEmpty)
              _InfoCard(
                icon: Icons.euro,
                title: 'Amount Due',
                content: amounts.join('\n'),
                color: const Color(0xFFFFEBEE),
                iconColor: const Color(0xFFFF3B30),
              ),
            const SizedBox(height: 10),

            // 9. Appointment Date — for invitations!!
            if (isInvitation && appointmentDate.isNotEmpty)
              _InfoCard(
                icon: Icons.event,
                title: 'Appointment',
                content: appointmentDate,
                color: const Color(0xFFFFF3E0),
                iconColor: const Color(0xFFFF9500),
              ),
            const SizedBox(height: 10),

            // 10. Venue Address — for invitations!!
            if (isInvitation && venueAddress.isNotEmpty)
              _InfoCard(
                icon: Icons.location_on,
                title: 'Address / Venue',
                content: venueAddress,
                color: const Color(0xFFE8F5E9),
                iconColor: const Color(0xFF34C759),
              ),
            const SizedBox(height: 10),

            // 11. Contact Info
            if (contacts.isNotEmpty)
              _InfoCard(
                icon: Icons.contact_phone,
                title: 'Contact',
                content: contacts.join('\n'),
                color: const Color(0xFFE0F7FA),
                iconColor: const Color(0xFF00C896),
              ),
            const SizedBox(height: 24),

            // 12. Share Section
            _ShareSection(
              shareText: _buildShareText(
                sender: sender,
                letterDate: letterDate,
                subject: subject,
                summary: summary,
                actionRequired: actionRequired,
                dueDates: dueDates,
                amounts: amounts,
                hasPayment: hasPayment,
              ),
              context: context,
            ),
            const SizedBox(height: 16),

            // 13. Full Translation Toggle
            _FullTranslationSection(translatedText: translated),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// Share Section Widget
class _ShareSection extends StatelessWidget {
  final String shareText;
  final BuildContext context;

  const _ShareSection({
    required this.shareText,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 12),
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
            // WhatsApp
            Expanded(
              child: _ShareButton(
                icon: Icons.chat,
                label: "WhatsApp",
                color: const Color(0xFF25D366),
                onTap: () => Share.share(
                  shareText,
                  subject: "German Letter Summary",
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Email
            Expanded(
              child: _ShareButton(
                icon: Icons.email_outlined,
                label: "Email",
                color: const Color(0xFF007AFF),
                onTap: () => Share.share(
                  shareText,
                  subject: "German Letter Summary — MyGermanFreund",
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Copy
            Expanded(
              child: _ShareButton(
                icon: Icons.copy,
                label: "Copy",
                color: const Color(0xFF6C3CE1),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: shareText));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Copied to clipboard!!"),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Share Button Widget
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

// Full Translation Toggle Widget
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
          icon: Icon(_expanded ? Icons.expand_less : Icons.translate),
          label: Text(
            _expanded ? "Hide Full Translation" : "View Full Translation",
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            side: const BorderSide(color: Color(0xFF6C3CE1)),
            foregroundColor: const Color(0xFF6C3CE1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        if (_expanded) ...[
          const SizedBox(height: 12),
          _InfoCard(
            icon: Icons.translate,
            title: 'Full Translation',
            content: widget.translatedText,
            color: const Color(0xFFF5F5F5),
            iconColor: Colors.black54,
          ),
        ],
      ],
    );
  }
}

// Info Card Widget
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final Color color;
  final Color iconColor;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.content,
    required this.color,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: iconColor.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: iconColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: iconColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}