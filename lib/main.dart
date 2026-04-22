import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'theme/app_colors.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'screens/otp_verification_page.dart';

// Screens
import 'screens/home_screen.dart';
import 'screens/Essentials/checklist_page.dart';
import 'screens/letter_scanner/letter_scanner_page.dart';
import 'screens/german_buzz_page.dart';
import 'screens/sim_card_page.dart';
import 'screens/accommodation_page.dart';
import 'screens/job_search_page.dart';
import 'screens/public_transport_page.dart';
import 'screens/profile_page.dart';

// Firebase initialization file (if you already have one)
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final storage = FlutterSecureStorage();
  final isVerified = 'true';
  //final isVerified = await storage.read(key: 'isVerified');

  runApp(MyGermanFreundApp(isVerified: isVerified == 'true'));
}


class MyGermanFreundApp extends StatelessWidget {
  final bool isVerified;

  const MyGermanFreundApp({super.key, required this.isVerified});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyGermanFreund',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          background: AppColors.background,
        ),
        scaffoldBackgroundColor: AppColors.background,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColors.border),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.primary),
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
        ),
      ),

      // 🔹 Initial Route
      home: isVerified ? const HomeScreen() : const OtpVerificationPage(),
      // 🔹 Named Routes
      routes: {
        '/home': (context) => const HomeScreen(),
        '/checklist': (context) => const ChecklistPage(),
        '/scanner': (context) => const LetterScannerPage(),
        '/buzz': (context) => const GermanBuzzPage(),
        '/education': (context) => const SimCardPage(),
        '/accommodation': (context) => const AccommodationPage(),
        '/jobsearch': (context) => const JobSearchPage(),
        '/publictransport': (context) => const PublicTransportPage(),
        //'/': (context) => const HomeScreen(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
