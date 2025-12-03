import 'package:flutter/material.dart';

class PublicTransportPage extends StatelessWidget {
  const PublicTransportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🚆 Public Transport")),
      body: const Center(
        child: Text(
          "Learn how to get a transport card and use city transit apps.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
