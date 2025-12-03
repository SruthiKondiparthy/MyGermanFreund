import 'package:flutter/material.dart';

class JobSearchPage extends StatelessWidget {
  const JobSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("💼 Job Search")),
      body: const Center(
        child: Text(
          "Find German job portals and prepare your CV for applications.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
