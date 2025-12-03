import 'package:flutter/material.dart';

class SimCardPage extends StatelessWidget {
  const SimCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("📱 Get a SIM Card")),
      body: const Center(
        child: Text(
          "Here you can find guides for choosing a mobile provider in Germany.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
