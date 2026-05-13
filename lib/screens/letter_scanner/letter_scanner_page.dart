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
  final ImagePicker _picker = ImagePicker();

  // ─── Entry point ────────────────────────────────────────────────────────────
  Future<void> _onScanButtonPressed() async {
    final choice = await _showSourcePickerDialog();
    if (choice == null || !mounted) return;

    setState(() => _isLoading = true);

    try {
      // Returns combined OCR text (single or multi-page)
      final extractedText = await _acquireAndExtractText(choice);
      if (!mounted) return;

      if (extractedText == null) {
        setState(() => _isLoading = false);
        return;
      }

      if (extractedText.trim().isEmpty) {
        setState(() => _isLoading = false);
        _showError("No text detected.\n\nTips:\n• Ensure good lighting\n• Hold phone steady\n• Keep letter flat");
        return;
      }

      // Send combined text to Claude API
      final analyzedData = await ApiService.analyzeLetter(extractedText);
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
        _showError("You've used all 3 free scans this month.\n\nPremium plan coming soon!");
      } else if (msg.contains('SocketException') || msg.contains('connection')) {
        _showError("No internet connection.\nPlease check your WiFi and try again.");
      } else if (msg.contains('timeout')) {
        _showError("Request timed out.\nPlease try again.");
      } else {
        _showError("Something went wrong.\nPlease try again.");
      }
    }
  }

  // ─── Acquire image(s) and return combined OCR text ──────────────────────────
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

  // ─── Single image (camera or gallery) ───────────────────────────────────────
  Future<String?> _extractSingleImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 2000,
    );
    if (picked == null) return null;

    final imagePath = picked.path;

    // Clarity check
    final clarityOK = await _isImageClear(imagePath);
    if (!mounted) return null;
    if (!clarityOK) {
      setState(() => _isLoading = false);
      _showError("The document is too blurry.\n\nTips:\n• Better lighting\n• Hold phone steady\n• Keep letter flat");
      return null;
    }

    // Fix orientation then OCR
    final corrected = await ImageUtils.fixOrientation(File(imagePath));
    return await OcrService.extractText(corrected);
  }

  // ─── Document Scanner — multi-page!! ────────────────────────────────────────
  Future<String?> _extractDocScannerPages() async {
    try {
      final scannedFiles = await DocumentScanner.scan(format: DocScanFormat.jpeg);
      if (scannedFiles == null || scannedFiles.isEmpty) return null;

      // OCR every page and combine text
      final buffer = StringBuffer();

      for (int i = 0; i < scannedFiles.length; i++) {
        final file = File(scannedFiles[i]);
        final corrected = await ImageUtils.fixOrientation(file);
        final pageText = await OcrService.extractText(corrected);

        if (pageText.trim().isNotEmpty) {
          if (scannedFiles.length > 1) {
            // Only add page markers for multi-page docs
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
            (e.message?.toLowerCase().contains('feature not available') ?? false) ||
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
              "Document scanner not available on this device. Please use Camera or Upload.",
            ),
          ),
        );
        // Fallback to camera/gallery
        final fallback = await _showSourcePickerDialog(excludeDocScanner: true);
        if (!mounted || fallback == null) return null;
        return await _acquireAndExtractText(fallback);
      }

      rethrow;
    }
  }

  // ─── Error popup — user never gets stuck!! ──────────────────────────────────
  void _showError(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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

  // ─── Source picker dialog ────────────────────────────────────────────────────
  Future<_ScanChoice?> _showSourcePickerDialog({bool excludeDocScanner = false}) {
    return showDialog<_ScanChoice>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("How would you like to scan?"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF6C3CE1)),
              title: const Text("Camera"),
              subtitle: const Text("Take a photo now"),
              onTap: () => Navigator.pop(context, _ScanChoice.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF6C3CE1)),
              title: const Text("Upload Image"),
              subtitle: const Text("Choose from gallery"),
              onTap: () => Navigator.pop(context, _ScanChoice.gallery),
            ),
            if (!excludeDocScanner)
              ListTile(
                leading: const Icon(Icons.document_scanner, color: Color(0xFF6C3CE1)),
                title: const Text("Document Scanner"),
                subtitle: const Text("Scan multiple pages at once"),
                onTap: () => Navigator.pop(context, _ScanChoice.docScanner),
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

  // ─── Blur detection ──────────────────────────────────────────────────────────
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

  // ─── UI ─────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Letter Scanner"),
        backgroundColor: const Color(0xFF6C3CE1),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: _isLoading
            ? _buildLoadingState()
            : _buildIdleState(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(color: Color(0xFF6C3CE1)),
        const SizedBox(height: 20),
        const Text(
          "Analysing your letter...",
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 8),
        const Text(
          "This may take a moment",
          style: TextStyle(fontSize: 13, color: Colors.black38),
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
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
          const SizedBox(height: 28),
          const Text(
            "Scan Your Letter",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Use Document Scanner for multi-page letters.\nCamera or Upload for single pages.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black45,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 36),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _onScanButtonPressed,
              icon: const Icon(Icons.add_a_photo, size: 22),
              label: const Text(
                "Scan or Upload Letter",
                style: TextStyle(
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