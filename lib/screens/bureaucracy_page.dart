import 'package:flutter/material.dart';

class BureaucraticGuidancePage extends StatelessWidget {
  const BureaucraticGuidancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bureaucracyCards = [
      {
        'title': 'Anmeldung / Address\nRegistration',
        'icon': 'assets/icons/MGF_Registration.png',
        'route': '/anmeldung',
      },
      {
        'title': 'Banking',
        'icon': 'assets/icons/MGF_Money.png',
        'route': '/banking',
      },
      {
        'title': 'Health Insurance',
        'icon': 'assets/icons/MGF_Healthcare.png',
        'route': '/insurance',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black87),
        title: SizedBox(
          height: 36,
          child: Image.asset('assets/MGF_Icon.png', fit: BoxFit.contain),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                const Text('DE', style: TextStyle(color: Colors.black)),
                Switch(
                  value: true,
                  onChanged: (_) {},
                  activeColor: Colors.green,
                ),
                const Text('EN', style: TextStyle(color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/MGF_guidence.png',
                      width: 85,
                      height: 85,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      "Navigate Germany’s complex bureaucracy with ease. Select a topic below to get step-by-step guidance, downloadable forms, FAQs, and AI assistance.",
                      style: TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              SizedBox(
                height: 92,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: bureaucracyCards.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final item = bureaucracyCards[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(item['route']!);
                      },
                      child: Container(
                        width: 320,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2D496),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            Image.asset(
                              item['icon']!,
                              width: 42,
                              height: 42,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Text(
                                item['title']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w500,
                                  height: 1.15,
                                ),
                              ),
                            ),
                            const SizedBox(width: 18),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                "Quick Actions",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),

              const SizedBox(height: 6),

              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "✅📄 Download Anmeldung Form (PDF for easy submission)",
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    "✅📅 Book an Appointment (Link to your city’s Bürgeramt)",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const Text(
                "Would you like AI to book appointments and pre-fill your forms ?",
                style: TextStyle(
                  color: Color(0xFF135113),
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/onboarding');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}