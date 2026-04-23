import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:doc_scan_flutter/doc_scan.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import '../../services/ocr_service.dart';
import '../../services/document_analyzer.dart';
import 'letter_result_page.dart';

class LetterScannerPage extends StatefulWidget {
  const LetterScannerPage({super.key});

  @override
  State<LetterScannerPage> createState() => _LetterScannerPageState();
}

class _LetterScannerPageState extends State<LetterScannerPage> {
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  // Entry point: show the source-picker dialog, then process the chosen image.
  Future<void> _onScanButtonPressed() async {
    final choice = await _showSourcePickerDialog();
    if (choice == null || !mounted) return;

    setState(() => _isLoading = true);
    try {
      final imagePath = await _acquireImage(choice);
      if (!mounted) return;

      if (imagePath == null) {
        setState(() => _isLoading = false);
        return;
      }

      // Check image clarity before OCR
      final clarityOK = await _isImageClear(imagePath);
      if (!mounted) return;
      if (!clarityOK) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "The document is too blurry or unclear. Please try again with better lighting."),
          ),
        );
        return;
      }

      final extractedText = await OcrService.extractText(File(imagePath));
      if (!mounted) return;

      if (extractedText.trim().isEmpty) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  "No text detected. Try better lighting or a closer scan.")),
        );
        return;
      }

      final analyzedData = DocumentAnalyzer.analyzeText(extractedText);
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error scanning document: $e")));
    }
  }

  // Returns the image file path for the chosen source, or null if cancelled.
  Future<String?> _acquireImage(_ScanChoice choice) async {
    switch (choice) {
      case _ScanChoice.camera:
        final picked = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
          maxWidth: 2000,
        );
        return picked?.path;

      case _ScanChoice.gallery:
        final picked = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
          maxWidth: 2000,
        );
        return picked?.path;

      case _ScanChoice.docScanner:
        return await _tryDocScanner();
    }
  }

  // Attempts to use the Google Play document scanner.
  // On PlatformException or "feature not available" errors, shows a friendly
  // SnackBar and returns null so the caller can present the source picker again.
  Future<String?> _tryDocScanner() async {
    try {
      final scannedFiles = await DocumentScanner.scan(format: DocScanFormat.jpeg);
      if (scannedFiles == null || scannedFiles.isEmpty) return null;
      return scannedFiles.first;
    } catch (e) {
      if (!mounted) return null;
      final message = e.toString().toLowerCase();
      final bool isUnavailable;
      if (e is PlatformException) {
        // Check common codes reported by doc_scan_flutter when scanner is absent.
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
                "Document scanner not available on this device. Please use Camera or Upload."),
          ),
        );
        // Re-open the source picker so the user can choose camera/gallery.
        final fallback = await _showSourcePickerDialog(
            excludeDocScanner: true);
        if (!mounted || fallback == null) return null;
        return _acquireImage(fallback);
      }
      // Unexpected error — re-throw so the outer handler shows it.
      rethrow;
    }
  }

  // Shows the source-picker dialog. Set [excludeDocScanner] to hide the
  // Document Scanner option (used when it has already failed).
  Future<_ScanChoice?> _showSourcePickerDialog(
      {bool excludeDocScanner = false}) {
    return showDialog<_ScanChoice>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Select Image Source"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Scan with Camera"),
              onTap: () => Navigator.pop(context, _ScanChoice.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Upload Image"),
              onTap: () => Navigator.pop(context, _ScanChoice.gallery),
            ),
            if (!excludeDocScanner)
              ListTile(
                leading: const Icon(Icons.document_scanner),
                title: const Text("Use Document Scanner"),
                subtitle: const Text("Availability depends on device support"),
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

  // Blur detection: downscale + sampling + streaming variance to avoid OOM.
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Letter Scanner"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
                onPressed: _onScanButtonPressed,
                icon: const Icon(Icons.document_scanner),
                label: const Text("Scan or Upload Letter"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 16),
                ),
              ),
      ),
    );
  }
}

// Internal enum for source-picker choices.
enum _ScanChoice { camera, gallery, docScanner }
