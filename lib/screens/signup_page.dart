import 'package:flutter/material.dart';

class OnboardingSignupPage extends StatefulWidget {
  const OnboardingSignupPage({super.key});

  @override
  State<OnboardingSignupPage> createState() => _OnboardingSignupPageState();
}

class _OnboardingSignupPageState extends State<OnboardingSignupPage> {
  int selectedRadio = 0;
  bool hasAppointment = false;
  bool agreed = false;
  String movingFrom = '';
  String otherRole = '';
  String stayDuration = '';

  final nameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Lets get you Started !!",
                style: TextStyle(
                  color: Color(0xFF934595),
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 6),
              Text(
                "Tell us a little about yourself to personalize your experience.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.pink.shade300,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "First name",
                  contentPadding: EdgeInsets.symmetric(horizontal: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "E-Mail",
                  contentPadding: EdgeInsets.symmetric(horizontal: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 18),

              Column(
                children: [
                  RadioListTile(
                    value: 1,
                    groupValue: selectedRadio,
                    onChanged: (v) => setState(() => selectedRadio = v as int),
                    title: Text("I'm a Student"),
                    contentPadding: EdgeInsets.zero,
                  ),
                  RadioListTile(
                    value: 2,
                    groupValue: selectedRadio,
                    onChanged: (v) => setState(() => selectedRadio = v as int),
                    title: Text("I'm an Employee"),
                    contentPadding: EdgeInsets.zero,
                  ),
                  RadioListTile(
                    value: 3,
                    groupValue: selectedRadio,
                    onChanged: (v) => setState(() => selectedRadio = v as int),
                    title: Text("I'm a Freelancer"),
                    contentPadding: EdgeInsets.zero,
                  ),
                  RadioListTile(
                    value: 4,
                    groupValue: selectedRadio,
                    onChanged: (v) => setState(() => selectedRadio = v as int),
                    title: Text("I'm moving with family"),
                    contentPadding: EdgeInsets.zero,
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 5,
                        groupValue: selectedRadio,
                        onChanged: (v) => setState(() => selectedRadio = v as int),
                      ),
                      Expanded(
                        child: TextField(
                          onChanged: (txt) => otherRole = txt,
                          enabled: selectedRadio == 5,
                          decoration: InputDecoration(
                            hintText: "Tell us about you !",
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text("Where are you moving from?*", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                ),
                value: movingFrom.isEmpty ? null : movingFrom,
                hint: Text("Select"),
                items: [
                  'Country A', 'Country B', 'Country C'
                ].map((country) => DropdownMenuItem(
                  value: country,
                  child: Text(country),
                )).toList(),
                onChanged: (val) => setState(() { movingFrom = val ?? ''; }),
              ),
              SizedBox(height: 12),
              Text("Choose from the list.", style: TextStyle(fontSize: 13, color: Colors.black54)),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Do you have an appointment for Anmeldung?'),
                value: hasAppointment,
                onChanged: (v) => setState(() => hasAppointment = v),
              ),
              SizedBox(height: 8),
              Text("How long do you plan to stay?"),
              SizedBox(height: 6),
              TextField(
                decoration: InputDecoration(
                  hintText: "<6 months, 6-12 months, 1+ year, Not sure yet",
                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onChanged: (v) => stayDuration = v,
              ),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: agreed,
                    onChanged: (v) => setState(() => agreed = v ?? false),
                  ),
                  Flexible(
                    child: Text("I agree to the Terms and Conditions and Privacy Policy."),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: agreed ? () {} : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 46),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)
                  ),
                ),
                child: Text("Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}