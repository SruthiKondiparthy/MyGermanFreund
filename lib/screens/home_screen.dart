import 'package:flutter/material.dart';
import 'letter_scanner/letter_scanner_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Large Logo
              Image.asset('assets/MGF_Icon.png', height: 80),
              const SizedBox(height: 16),

              // App Name
              const Text(
                "MyGermanFreund",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF6C3CE1),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "by Athirikya Solutions",
                style: TextStyle(fontSize: 12, color: Colors.black45),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 16),

              // Mission
              const Text(
                "Our Mission",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Moving to Germany is exciting — but navigating official letters, bureaucracy, and cultural differences can be overwhelming.\n\nMyGermanFreund is your AI-powered companion that makes Germany feel like home. We translate and explain official German letters instantly, so you always know what to do next.\n\nNo more confusion. No more stress. Just clarity.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 20),

              // Version
              const Text(
                "Version 1.0.0",
                style: TextStyle(fontSize: 11, color: Colors.black38),
              ),
              const SizedBox(height: 16),

              // OK Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C3CE1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    "Got it!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: GestureDetector(
          onTap: () => _showAboutDialog(context),
          child: Image.asset('assets/MGF_Icon.png', height: 36),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Hero Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF6C3CE1).withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.document_scanner,
                size: 60,
                color: Color(0xFF6C3CE1),
              ),
            ),
            const SizedBox(height: 32),

            // Title
            const Text(
              "Understand Any\nGerman Letter",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 16),

            // Subtitle
            const Text(
              "Scan any official German letter and get\na plain English summary instantly.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black45,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 48),

            // Feature Pills
            _FeaturePill(
              icon: Icons.translate,
              text: "Instant English Translation",
              color: const Color(0xFF6C3CE1),
            ),
            const SizedBox(height: 12),
            _FeaturePill(
              icon: Icons.calendar_today,
              text: "Due Dates & Amounts Extracted",
              color: const Color(0xFFFF9500),
            ),
            const SizedBox(height: 12),
            _FeaturePill(
              icon: Icons.lock_outline,
              text: "Private — We never store your letters",
              color: const Color(0xFF34C759),
            ),
            const SizedBox(height: 12),
            _FeaturePill(
              icon: Icons.auto_awesome,
              text: "Multi-page letters supported",
              color: const Color(0xFF00C896),
            ),
          ],
        ),
      ),

      // Scan Button at bottom center
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LetterScannerPage(),
                  ),
                );
              },
              icon: const Icon(Icons.document_scanner, size: 24),
              label: const Text(
                "Scan a Letter",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C3CE1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _FeaturePill({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}