import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../data/checklist_data.dart';
import 'checklist_detail_page.dart';
import '../mandatory_tasks_page.dart';

class ChecklistPage extends StatelessWidget {
  const ChecklistPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Extract all checklist keys and titles dynamically from checklist_data.dart
    final checklistItems = checklistData.entries.map((entry) {
      return {
        "key": entry.key,
        "title": entry.value["title"] as String,
      };
    }).toList();

    return Scaffold(
      appBar: customAppBar(context, "Checklists"),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 👇 Static “Mandatory Tasks” card first
          /*Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.blue.shade50,
            elevation: 3,
            child: ListTile(
              contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              leading: const Icon(Icons.flag, color: Colors.blueAccent),
              title: const Text(
                "Mandatory Bureaucratic Tasks",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueAccent,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.blueAccent,
                size: 18,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MandatoryTasksPage()),
                );
              },
            ),
          ),

          const Divider(height: 20, thickness: 1),*/

          // 👇 Dynamic list from checklist_data.dart
          ...checklistItems.map((item) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: ListTile(
                contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                title: Text(
                  item["title"]!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.blueAccent, size: 18),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChecklistDetailPage(checklistKey: item["key"]!),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

