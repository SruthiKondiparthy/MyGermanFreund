import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class GermanBuzzPage extends StatelessWidget {
  const GermanBuzzPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "German Buzz"),
      body: const Center(
        child: Text(
          "This is the German Buzz page (news, trends, tips).",
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}