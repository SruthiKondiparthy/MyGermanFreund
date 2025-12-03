import 'package:flutter/material.dart';

class AccommodationPage extends StatelessWidget {
  const AccommodationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🏡 Find Accommodation")),
      body: const Center(
        child: Text(
          "Tips for finding an apartment or WG (shared flat) in Germany.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
