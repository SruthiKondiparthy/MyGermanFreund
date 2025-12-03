import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/checklist_data.dart';
import '../pdf_viewer_page.dart';
import '../location_search_page.dart';
import '../webview_page.dart';

class ChecklistDetailPage extends StatelessWidget {
  final String checklistKey;
  const ChecklistDetailPage({super.key, required this.checklistKey});

  // Opens external link in browser
  Future<void> _openExternalLink(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (!await canLaunchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open link: $url")),
      );
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  // Opens link inside app WebView
  void _openWebView(BuildContext context, String title, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WebViewPage(title: title, url: url)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final checklist = checklistData[checklistKey];

    if (checklist == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Checklist Not Found")),
        body: const Center(child: Text("This checklist does not exist.")),
      );
    }

    final title = checklist["title"];
    final description = checklist["description"];
    final steps = checklist["steps"] as List<dynamic>?;
    final documents = checklist["documents"] as List<dynamic>?;
    final usefulLinks = checklist["usefulLinks"] as List<dynamic>?;
    final vocabulary = checklist["vocabulary"] as List<dynamic>?;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📝 Description
            if (description != null) ...[
              Text(
                description,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),
            ],

            // ✅ Steps Section
            if (steps != null && steps.isNotEmpty) ...[
              const Text(
                "Steps to Complete:",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
              const SizedBox(height: 8),
              ...steps.map((stepItem) {
                final Map<String, dynamic> step = stepItem as Map<String, dynamic>;
                final text = step["text"] ?? "";
                final searchQuery = step["searchQuery"];
                final searchHint = step["searchHint"];

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.check_circle_outline,
                        color: Colors.green),
                    title: Text(text),
                    trailing: searchQuery != null
                        ? IconButton(
                      icon: const Icon(Icons.search, color: Colors.blueAccent),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocationSearchPage(
                              searchType: searchQuery,
                            ),
                          ),
                        );
                      },
                    )
                        : null,
                  ),
                );
              }),
              const SizedBox(height: 24),
            ],

            // 📄 Documents Section
            if (documents != null && documents.isNotEmpty) ...[
              const Text(
                "Required Documents:",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
              const SizedBox(height: 8),
              ...documents.map((docItem) {
                final Map<String, dynamic> doc = docItem as Map<String, dynamic>;
                final title = doc["title"] ?? "";
                final isSampleForm = doc["isSampleForm"] == true;
                final samplePath = doc["samplePath"];

                return ListTile(
                  leading: const Icon(Icons.description, color: Colors.blueAccent),
                  title: GestureDetector(
                    onTap: isSampleForm && samplePath != null
                        ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PdfViewerPage(
                            pdfPath: samplePath,
                            title: title,
                          ),
                        ),
                      );
                    }
                        : null,
                    child: Text(
                      title,
                      style: TextStyle(
                        color: isSampleForm
                            ? Colors.redAccent
                            : Colors.black87,
                        decoration: isSampleForm
                            ? TextDecoration.underline
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
            ],

            // 🌐 Useful Links Section (in-app WebView)
            if (usefulLinks != null && usefulLinks.isNotEmpty) ...[
              const Text(
                "Useful Links:",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
              const SizedBox(height: 8),
              ...usefulLinks.map((linkItem) {
                final Map<String, dynamic> link = linkItem as Map<String, dynamic>;
                final linkTitle = link["title"] ?? "Open link";
                final url = link["url"] ?? "";

                return InkWell(
                  onTap: () => _openWebView(context, linkTitle, url),
                  child: ListTile(
                    leading: const Icon(Icons.link, color: Colors.blueAccent),
                    title: Text(
                      linkTitle,
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
            ],

            // 🗣 Vocabulary Section (single search link)
            if (vocabulary != null) ...[
              const Text(
                "Useful Vocabulary:",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
              const SizedBox(height: 12),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final query =
                    Uri.encodeComponent("Vocabulary related to $title German");
                    final url = "https://www.google.com/search?q=$query";
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url),
                          mode: LaunchMode.externalApplication);
                    }
                  },
                  icon: const Icon(Icons.language, color: Colors.white),
                  label: Text("Search Vocabulary for ${title.split(' ').last}"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }
}