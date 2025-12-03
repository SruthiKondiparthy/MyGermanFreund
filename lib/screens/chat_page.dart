import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat with your German Buddy")),
      body: const Center(
        child: Text("💬 AI German Chat Helper (coming soon)"),
      ),
    );
  }
}
