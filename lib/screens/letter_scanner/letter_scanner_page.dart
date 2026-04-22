import 'dart:io';
import 'package:flutter/material.dart';
import 'package:doc_scan_flutter/doc_scan.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:opencv_4/opencv_4.dart' as cv2;
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

  Future<void> _scanDocument() async {
    try {
      setState(() => _isLoading = true);

      List<String>? scannedFiles;

      try {
        // Try Google Doc Scanner first
        scannedFiles = await DocumentScanner.scan(format: DocScanFormat.jpeg);
      } catch (_) {
        scannedFiles = null;
      }

      if (!mounted) return;

      String? imagePath;
      if (scannedFiles == null || scannedFiles.isEmpty) {
        // Fallback: manual picker
        imagePath = await _pickFromCameraOrGallery();
        if (!mounted) return;
        if (imagePath == null) {
          setState(() => _isLoading = false);
          return;
        }

        // Run edge detection + enhancement
        imagePath = await _enhanceAndCropImage(imagePath);
        if (!mounted) return;
      } else {
        imagePath = scannedFiles.first;
      }

      final imageFile = File(imagePath);

      // ✅ Step 1: Check image clarity before OCR
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

      // ✅ Step 2: Run OCR
      final extractedText = await OcrService.extractText(imageFile);
      if (!mounted) return;
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

  Future<String?> _pickFromCameraOrGallery() async {
    return await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Select Image Source"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Use Camera"),
              onTap: () async {
                final picked = await _picker.pickImage(
                  source: ImageSource.camera,
                  maxWidth: 1920,
                  imageQuality: 85,
                );
                Navigator.pop(context, picked?.path);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Pick from Gallery"),
              onTap: () async {
                final picked = await _picker.pickImage(
                  source: ImageSource.gallery,
                  maxWidth: 1920,
                  imageQuality: 85,
                );
                Navigator.pop(context, picked?.path);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _enhanceAndCropImage(String path) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final String outPath =
        '${dir.path}/enhanced_${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Just copy the original image for now
    await File(path).copy(outPath);

    return outPath;
  }

  double computeLaplacianVariance(img.Image image) {
    // Downscale to at most 800px wide to avoid OOM on high-resolution images.
    final img.Image resized =
        image.width > 800 ? img.copyResize(image, width: 800) : image;

    const kernel = [
      [0, 1, 0],
      [1, -4, 1],
      [0, 1, 0],
    ];

    final width = resized.width;
    final height = resized.height;

    // Streaming variance: no list allocation, sample every other pixel (step=2).
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

      final variance = computeLaplacianVariance(image);

      // Threshold lowered to 40.0 because we now analyze a downscaled image.
      return variance > 40.0;
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
          onPressed: _scanDocument,
          icon: const Icon(Icons.document_scanner),
          label: const Text("Scan or Upload Letter"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),
      ),
    );
  }
}
