import 'package:flutter/material.dart';
import 'screens/anmeldung_page.dart';
import 'screens/ai_assistant_page.dart';
import 'screens/bureaucracy_page.dart';
import 'screens/dashboard_page.dart';
import 'screens/home_screen.dart';
import 'screens/otp_page.dart';
import 'screens/signup_page.dart';


// ... import other pages

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyGermanFreund',
        theme: ThemeData(
          fontFamily: 'Montserrat',
          primarySwatch: Colors.deepPurple,
          scaffoldBackgroundColor: Color(0xFFF8F9FB),
          appBarTheme: AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/onboarding': (context) => const OnboardingSignupPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/otp': (context) => const OtpCodePage(),
        '/bureaucratic': (context) => const BureaucraticGuidancePage(),
        '/checklists': (context) => const BureaucraticGuidancePage(),
        '/prefilled': (context) => const BureaucraticGuidancePage(),
        '/scanner': (context) => const BureaucraticGuidancePage(),
        '/aichat': (context) => const AiAssistantPage(),
        '/anmeldung': (context) => const AnmeldungPage(),
        '/ai-assistant': (context) => const AiAssistantPage(),
        // Add more routes here as you create new pages
      },
    );
  }
}