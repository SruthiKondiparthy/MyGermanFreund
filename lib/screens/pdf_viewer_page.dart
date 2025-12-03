import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewerPage extends StatefulWidget {
  final String pdfPath;
  final String title;

  const PdfViewerPage({
    super.key,
    required this.pdfPath,
    required this.title,
  });

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String? localPath;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final data = await rootBundle.load(widget.pdfPath);
      final bytes = data.buffer.asUint8List();

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${widget.pdfPath.split('/').last}');
      await file.writeAsBytes(bytes, flush: true);

      setState(() {
        localPath = file.path;
      });
    } catch (e) {
      print("❌ Error loading PDF: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: localPath == null
          ? const Center(child: CircularProgressIndicator())
          : PDFView(
        filePath: localPath!,
      ),
    );
  }
}
