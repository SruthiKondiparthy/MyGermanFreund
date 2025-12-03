import 'package:flutter/material.dart';
import '../data/mandatory_tasks_data.dart';
import '../models/mandatory_task.dart';
import '../widgets/custom_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class MandatoryTasksPage extends StatelessWidget {
  const MandatoryTasksPage({super.key});

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Mandatory Bureaucratic Tasks"),
      body: ListView.builder(
        itemCount: mandatoryTasks.length,
        itemBuilder: (context, index) {
          final MandatoryTask task = mandatoryTasks[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade50,
                child: Text("${task.order}"),
              ),
              title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${task.description}\n⏱ ${task.estimatedTime}"),
              isThreeLine: true,
              trailing: IconButton(
                icon: const Icon(Icons.open_in_new, color: Colors.blueAccent),
                onPressed: () => _launchURL(task.link),
              ),
            ),
          );
        },
      ),
    );
  }
}
