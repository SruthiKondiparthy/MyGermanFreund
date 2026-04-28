import 'package:flutter/material.dart';

class AnmeldungPage extends StatelessWidget {
  const AnmeldungPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
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
            padding: const EdgeInsets.symmetric(horizontal: 8),
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
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Master German Bureaucracy with Ease! 🇩🇪",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              "Step-by-step guidance on Anmeldung!!",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 14),
            _StepCard(
                stepTitle: "Step 1: Find a Permanent Address",
                instructions: [
                  "Before registering, you need a fixed address in Germany.",
                  "✅ Sign a rental contract or get a sublet agreement.",
                  "✅ Ensure your landlord can provide a Wohnungsgeberbestätigung.",
                ]
            ),
            SizedBox(height: 12),
            _StepCard(
                stepTitle: "Step 2: Get an Appointment at the Bürgeramt",
                instructions: [
                  "Book an appointment with your local Bürgeramt (city office).",
                  "✅ Slots may be limited; book as early as possible.",
                  "✅ Bring all required documents for the appointment.",
                ]
            ),
            const Spacer(),
            Text(
              "Would you like AI to book appointments and pre-fill your forms ?",
              style: TextStyle(
                color: Color(0xFF135113),
                fontWeight: FontWeight.w700,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text("Sign Up", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 15),
            // Put your custom bottom nav here if desired
          ],
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String stepTitle;
  final List<String> instructions;

  const _StepCard({
    required this.stepTitle,
    required this.instructions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      margin: EdgeInsets.symmetric(vertical: 3),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stepTitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          ...instructions.map((txt) => Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              txt,
              style: TextStyle(
                  fontSize: 14,
                  color: txt.startsWith("✅") ? Colors.green[900] : Colors.black87
              ),
            ),
          )),
        ],
      ),
    );
  }
}