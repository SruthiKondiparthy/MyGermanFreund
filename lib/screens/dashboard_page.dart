import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black87),
        title: SizedBox(
          height: 36,
          child: Image.asset('assets/MGF_Icon.png', fit: BoxFit.contain),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Text('DE', style: TextStyle(color: Colors.black)),
                Switch(value: true, onChanged: (_) {}, activeColor: Colors.green),
                Text('EN', style: TextStyle(color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.menu, color: Colors.black54),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, size: 18),
                        hintText: "Search",
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text("Welcome Sruthi !", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                      ),
                      hint: Text("Select"),
                      items: [
                        'Anmeldung', 'Health Insurance', 'Banking'
                      ].map((service) => DropdownMenuItem(
                        value: service,
                        child: Text(service),
                      )).toList(),
                      onChanged: (val) {},
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text("Use Ctrl + Select", style: TextStyle(color: Colors.grey, fontSize: 12)),
              SizedBox(height: 20),
              Text("Dashboard", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 18),
              _DashboardItem(title: "Anmeldung"),
              _DashboardItem(title: "Health Insurance"),
              _DashboardItem(title: "Banking"),
              SizedBox(height: 28),
              Text("Upcoming Deadlines", style: TextStyle(fontWeight: FontWeight.w700)),
              SizedBox(height: 7),
              Text("March 10: Anmeldung", style: TextStyle(fontSize: 15)),
              Text("April 2:  Health Insurance", style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardItem extends StatelessWidget {
  final String title;
  const _DashboardItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Row(
        children: [
          Expanded(
            child: Slider(
              value: 0.6, min: 0, max: 1,
              onChanged: (v) {},
              inactiveColor: Colors.grey.shade300,
              activeColor: Colors.grey.shade600,
            ),
          ),
          SizedBox(width: 16),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              side: BorderSide(color: Colors.grey),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text("Details"),
          )
        ],
      ),
    );
  }
}