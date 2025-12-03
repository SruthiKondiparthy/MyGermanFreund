import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../widgets/custom_app_bar.dart';

class LocationSearchPage extends StatefulWidget {
  final String searchType; // e.g. "Bürgeramt"
  const LocationSearchPage({super.key, required this.searchType});

  @override
  State<LocationSearchPage> createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends State<LocationSearchPage> {
  final TextEditingController _controller = TextEditingController();
  WebViewController? _webViewController;
  bool _showWebView = false;

  String? _lastSearchUrl; // store the last searched URL

  @override
  void initState() {
    super.initState();

    // If returning to this screen, reload the previous URL
    if (_lastSearchUrl != null) {
      _loadWebView(_lastSearchUrl!);
    }
  }

  /// Loads Google Search results into WebView
  void _searchGoogle() {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    final searchUrl =
        "https://www.google.com/search?q=${Uri.encodeComponent('${widget.searchType} $query')}";
    _lastSearchUrl = searchUrl; // save it

    _loadWebView(searchUrl);
  }

  /// Internal helper to configure and show WebView
  void _loadWebView(String url) {
    setState(() {
      _showWebView = true;
    });

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));
  }

  /// Go back to search input without losing the last query
  void _goBackToSearch() {
    setState(() {
      _showWebView = false;
    });

    // Prefill previous query from lastSearchUrl if exists
    if (_lastSearchUrl != null) {
      final decoded = Uri.decodeComponent(_lastSearchUrl!);
      final parts = decoded.split("q=");
      if (parts.length > 1) {
        _controller.text = parts[1]
            .replaceAll(widget.searchType, "")
            .trim(); // restore previous query text
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Search ${widget.searchType}"),
      body: _showWebView
          ? Column(
        children: [
          Expanded(
            child: WebViewWidget(controller: _webViewController!),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: _goBackToSearch,
              icon: const Icon(Icons.arrow_back),
              label: const Text("Back to Anmeldung"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      )
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "Find your nearest office by entering your city name or postal code:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Enter city name or postal code",
                prefixIcon: const Icon(Icons.location_city),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (_) => _searchGoogle(),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _searchGoogle,
              icon: const Icon(Icons.search),
              label: const Text("Search on Google"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

