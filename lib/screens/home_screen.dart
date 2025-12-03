import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isMenuOpen = false;
  String _dailyTip = '';

  final List<String> _tips = [
    "Register your address within 14 days of moving in!",
    "Learn basic German greetings — they open many doors!",
    "Cash is still king in many parts of Germany.",
    "Always carry your health insurance card.",
    "Recycling is serious — sort your garbage properly!",
    "Most stores close early on Sundays.",
    "Keep a copy of all your official documents.",
  ];

  @override
  void initState() {
    super.initState();
    _dailyTip = (_tips..shuffle()).first;
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // 🔹 Top Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu, size: 28),
                        onPressed: _toggleMenu,
                      ),
                      const SizedBox(width: 8),
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage('assets/logo.png'),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "MyGermanFreund",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),

                // 🔹 Welcome + Tip
                const SizedBox(height: 8),
                const Text(
                  "Welcome to Germany !!!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    color: Colors.blue.shade50,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          const Icon(Icons.lightbulb_outline, color: Colors.amber),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _dailyTip,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 🔹 Essentials & Buzz
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTopButton("Essentials", Icons.checklist_rtl, () {
                      Navigator.pushNamed(context, '/checklist');
                    }),
                    _buildTopButton("Buzz", Icons.language, () {
                      Navigator.pushNamed(context, '/buzz');
                    }),
                  ],
                ),

                const Divider(height: 30, thickness: 1),

                // 🔹 Grid Section
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    children: [
                      _buildCategoryCard("Jobs", Icons.work, '/jobsearch'),
                      _buildCategoryCard("House", Icons.home, '/accommodation'),
                      _buildCategoryCard("Schools", Icons.school, '/education'),
                      _buildCategoryCard("Hospital", Icons.local_hospital, '/health'),
                      _buildCategoryCard("Garbage", Icons.delete_outline, '/garbage'),
                      _buildCategoryCard("Transport", Icons.directions_bus, '/transport'),
                      _buildCategoryCard("Events", Icons.event, '/events'),
                      _buildCategoryCard("Culture", Icons.flag, '/culture'),
                      _buildCategoryCard("Community", Icons.people, '/community'),
                    ],
                  ),
                ),

                // 🔹 Bottom Row (Quiz, Scan, Chat)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildBottomButton("Quiz", Icons.quiz, '/quiz'),
                      FloatingActionButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/scanner');
                        },
                        backgroundColor: Colors.blueAccent,
                        child: const Icon(Icons.document_scanner, size: 30),
                      ),
                      _buildBottomButton("Chat", Icons.chat_bubble_outline, '/chat'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Side Menu
          if (_isMenuOpen)
            GestureDetector(
              onTap: _toggleMenu,
              child: Container(color: Colors.black.withOpacity(0.3)),
            ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            top: 0,
            bottom: 0,
            left: _isMenuOpen ? 0 : -220,
            child: SafeArea(
              child: Container(
                width: 220,
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: const Text("About"),
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _toggleMenu,
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      title: const Text("Profile"),
                      onTap: () => Navigator.pushNamed(context, '/profile'),
                    ),
                    ListTile(
                      title: const Text("Settings"),
                      onTap: () => Navigator.pushNamed(context, '/settings'),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text("Subscriptions"),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopButton(String label, IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.blueAccent),
      label: Text(label, style: const TextStyle(color: Colors.black)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 3,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.blueAccent),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.blueAccent, width: 0.8),
        ),
        elevation: 2,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.blueAccent, size: 28),
              const SizedBox(height: 6),
              Text(title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton(String label, IconData icon, String route) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 30, color: Colors.blueAccent),
          onPressed: () => Navigator.pushNamed(context, route),
        ),
        Text(label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }
}