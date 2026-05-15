import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:doc_scan_flutter/doc_scan.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import '../../services/ocr_service.dart';
import '../../services/api_service.dart';
import '../../services/image_utils.dart';
import 'letter_result_page.dart';

class LetterScannerPage extends StatefulWidget {
  const LetterScannerPage({super.key});

  @override
  State<LetterScannerPage> createState() => _LetterScannerPageState();
}

class _LetterScannerPageState extends State<LetterScannerPage> {
  bool _isLoading = false;
  OutputLanguage _selectedLanguage = OutputLanguage.english; // Default!!
  final ImagePicker _picker = ImagePicker();

  // ─── Language Options ────────────────────────────────────────────────────────
  static const List<Map<String, String>> _languages = [
    {
      'value': 'english',
      'label': 'English',
      'flag': '🇬🇧',
      'desc': 'Plain English',
    },
    {
      'value': 'simple_german',
      'label': 'Einfaches Deutsch',
      'flag': '🇩🇪',
      'desc': 'Leichte Sprache',
    },
  ];

  // ─── Entry point ─────────────────────────────────────────────────────────────
  Future<void> _onScanButtonPressed() async {
    final choice = await _showSourcePickerDialog();
    if (choice == null || !mounted) return;

    setState(() => _isLoading = true);

    try {
      final extractedText = await _acquireAndExtractText(choice);
      if (!mounted) return;

      if (extractedText == null) {
        setState(() => _isLoading = false);
        return;
      }

      if (extractedText.trim().isEmpty) {
        setState(() => _isLoading = false);
        _showError(
          "No text detected.\n\nTips:\n• Ensure good lighting\n• Hold phone steady\n• Keep letter flat",
        );
        return;
      }

      // Pass selected language to API!!
      final analyzedData = await ApiService.analyzeLetter(
        extractedText,
        language: _selectedLanguage,
      );
      if (!mounted) return;

      setState(() => _isLoading = false);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => LetterResultPage(
            fullText: extractedText,
            extractedInfo: analyzedData,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);

      final msg = e.toString();
      if (msg.contains('429') || msg.contains('limit reached')) {
        _showError(
          "You've used all 3 free scans this month.\n\nPremium plan coming soon!",
        );
      } else if (msg.contains('SocketException') ||
          msg.contains('connection')) {
        _showError(
          "No internet connection.\nPlease check your WiFi and try again.",
        );
      } else if (msg.contains('timeout')) {
        _showError("Request timed out.\nPlease try again.");
      } else {
        _showError("Something went wrong.\nPlease try again.");
      }
    }
  }

  // ─── Acquire image(s) and return combined OCR text ───────────────────────────
  Future<String?> _acquireAndExtractText(_ScanChoice choice) async {
    switch (choice) {
      case _ScanChoice.camera:
        return await _extractSingleImage(ImageSource.camera);
      case _ScanChoice.gallery:
        return await _extractSingleImage(ImageSource.gallery);
      case _ScanChoice.docScanner:
        return await _extractDocScannerPages();
    }
  }

  // ─── Single image (camera or gallery) ────────────────────────────────────────
  Future<String?> _extractSingleImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 2000,
    );
    if (picked == null) return null;

    final imagePath = picked.path;

    final clarityOK = await _isImageClear(imagePath);
    if (!mounted) return null;
    if (!clarityOK) {
      setState(() => _isLoading = false);
      _showError(
        "The document is too blurry.\n\nTips:\n• Better lighting\n• Hold phone steady\n• Keep letter flat",
      );
      return null;
    }

    final corrected = await ImageUtils.fixOrientation(File(imagePath));
    return await OcrService.extractText(corrected);
  }

  // ─── Document Scanner — multi-page!! ─────────────────────────────────────────
  Future<String?> _extractDocScannerPages() async {
    try {
      final scannedFiles =
      await DocumentScanner.scan(format: DocScanFormat.jpeg);
      if (scannedFiles == null || scannedFiles.isEmpty) return null;

      final buffer = StringBuffer();

      for (int i = 0; i < scannedFiles.length; i++) {
        final file = File(scannedFiles[i]);
        final corrected = await ImageUtils.fixOrientation(file);
        final pageText = await OcrService.extractText(corrected);

        if (pageText.trim().isNotEmpty) {
          if (scannedFiles.length > 1) {
            buffer.writeln("--- Page ${i + 1} ---");
          }
          buffer.writeln(pageText.trim());
          buffer.writeln();
        }
      }

      return buffer.toString();
    } catch (e) {
      if (!mounted) return null;

      final message = e.toString().toLowerCase();
      final bool isUnavailable;

      if (e is PlatformException) {
        final code = e.code.toLowerCase();
        isUnavailable = code.contains('unavailable') ||
            code.contains('not_found') ||
            code.contains('activity') ||
            (e.message?.toLowerCase().contains('feature not available') ??
                false) ||
            (e.message?.toLowerCase().contains('google play') ?? false);
      } else {
        isUnavailable = message.contains('feature not available') ||
            message.contains('google play') ||
            message.contains('unavailable');
      }

      if (isUnavailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Document scanner not available. Please use Camera or Upload.",
            ),
          ),
        );
        final fallback =
        await _showSourcePickerDialog(excludeDocScanner: true);
        if (!mounted || fallback == null) return null;
        return await _acquireAndExtractText(fallback);
      }

      rethrow;
    }
  }

  // ─── Error popup ──────────────────────────────────────────────────────────────
  void _showError(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 28),
            SizedBox(width: 8),
            Text("Oops!"),
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
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C3CE1),
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

  // ─── Source picker dialog ─────────────────────────────────────────────────────
  Future<_ScanChoice?> _showSourcePickerDialog(
      {bool excludeDocScanner = false}) {
    return showDialog<_ScanChoice>(
      context: context,
      builder: (_) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("How would you like to scan?"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
              const Icon(Icons.camera_alt, color: Color(0xFF6C3CE1)),
              title: const Text("Camera"),
              subtitle: const Text("Take photo — single page"),
              onTap: () => Navigator.pop(context, _ScanChoice.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library,
                  color: Color(0xFF6C3CE1)),
              title: const Text("Upload Image"),
              subtitle: const Text("Choose from gallery — single page"),
              onTap: () => Navigator.pop(context, _ScanChoice.gallery),
            ),
            if (!excludeDocScanner)
              ListTile(
                leading: const Icon(Icons.document_scanner,
                    color: Color(0xFF00C896)),
                title: Row(
                  children: [
                    const Text("Document Scanner"),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color:
                        const Color(0xFF00C896).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "MULTI-PAGE",
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00C896),
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: const Text("Scan multiple pages at once"),
                onTap: () =>
                    Navigator.pop(context, _ScanChoice.docScanner),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  // ─── Language Selector Widget ─────────────────────────────────────────────────
  Widget _buildLanguageSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: _languages.map((lang) {
          final isSelected =
              _selectedLanguage == OutputLanguage.values.firstWhere(
                    (e) => e.name ==
                    (lang['value'] == 'simple_german'
                        ? 'simpleGerman'
                        : 'english'),
              );

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedLanguage = lang['value'] == 'simple_german'
                      ? OutputLanguage.simpleGerman
                      : OutputLanguage.english;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF6C3CE1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      lang['flag']!,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lang['label']!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color:
                        isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      lang['desc']!,
                      style: TextStyle(
                        fontSize: 10,
                        color: isSelected
                            ? Colors.white70
                            : Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── Blur detection ───────────────────────────────────────────────────────────
  double _computeLaplacianVariance(img.Image image) {
    final img.Image resized =
    image.width > 800 ? img.copyResize(image, width: 800) : image;

    const kernel = [
      [0, 1, 0],
      [1, -4, 1],
      [0, 1, 0],
    ];

    final width = resized.width;
    final height = resized.height;
    double sum = 0;
    double sumSq = 0;
    int n = 0;

    for (int y = 1; y < height - 1; y += 2) {
      for (int x = 1; x < width - 1; x += 2) {
        double v = 0;
        for (int ky = -1; ky <= 1; ky++) {
          for (int kx = -1; kx <= 1; kx++) {
            final pixel = resized.getPixel(x + kx, y + ky);
            final gray = img.getLuminance(pixel).toDouble();
            v += gray * kernel[ky + 1][kx + 1];
          }
        }
        sum += v;
        sumSq += v * v;
        n++;
      }
    }

    if (n == 0) return 0;
    final mean = sum / n;
    return (sumSq / n) - (mean * mean);
  }

  Future<bool> _isImageClear(String path) async {
    try {
      final bytes = await File(path).readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return true;
      return _computeLaplacianVariance(image) > 40.0;
    } catch (_) {
      return true;
    }
  }

  // ─── UI ───────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Letter Scanner"),
        backgroundColor: const Color(0xFF6C3CE1),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: _isLoading ? _buildLoadingState() : _buildIdleState(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(color: Color(0xFF6C3CE1)),
        const SizedBox(height: 20),
        Text(
          _selectedLanguage == OutputLanguage.simpleGerman
              ? "Brief wird analysiert..."
              : "Analysing your letter...",
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 8),
        Text(
          _selectedLanguage == OutputLanguage.simpleGerman
              ? "Das dauert einen Moment"
              : "This may take a moment",
          style: const TextStyle(fontSize: 13, color: Colors.black38),
        ),
        const SizedBox(height: 24),
        TextButton(
          onPressed: () => setState(() => _isLoading = false),
          child: const Text("Cancel"),
        ),
      ],
    );
  }

  Widget _buildIdleState() {
    final isGerman = _selectedLanguage == OutputLanguage.simpleGerman;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: const Color(0xFF6C3CE1).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.document_scanner,
              size: 54,
              color: Color(0xFF6C3CE1),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            isGerman ? "Brief scannen" : "Scan Your Letter",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            isGerman
                ? "Wählen Sie Ihre Sprache.\nDann scannen Sie den Brief."
                : "Choose your language then scan!!",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black45,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),

          // Language Selector!!
          _buildLanguageSelector(),
          const SizedBox(height: 10),

          // Language hint
          Text(
            isGerman
                ? "Ergebnis auf Einfachem Deutsch"
                : "Results in plain English",
            style: TextStyle(
              fontSize: 12,
              color: const Color(0xFF6C3CE1).withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 32),

          // Scan Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _onScanButtonPressed,
              icon: const Icon(Icons.add_a_photo, size: 22),
              label: Text(
                isGerman
                    ? "Brief scannen oder hochladen"
                    : "Scan or Upload Letter",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C3CE1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Internal enum for source-picker choices
enum _ScanChoice { camera, gallery, docScanner }