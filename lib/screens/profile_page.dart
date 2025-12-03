import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../theme/app_colors.dart';
import 'otp_verification_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final storage = const FlutterSecureStorage();
  String? _phoneNumber;

  @override
  void initState() {
    super.initState();
    _loadPhoneNumber();
  }

  Future<void> _loadPhoneNumber() async {
    final phone = await storage.read(key: 'phoneNumber');
    setState(() {
      _phoneNumber = phone;
    });
  }

  Future<void> _logout(BuildContext context) async {
    await storage.deleteAll(); // clears local verification data
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const OtpVerificationPage()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 1,
        backgroundColor: AppColors.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.primary.withOpacity(0.15),
              child: const Icon(
                Icons.person,
                size: 48,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              _phoneNumber ?? 'No phone number linked',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 40),

            ListTile(
              leading: const Icon(Icons.security_outlined, color: AppColors.primary),
              title: const Text(
                'Re-verify phone number',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              onTap: () => _logout(context),
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                'Logout and clear data',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Confirm Logout'),
                    content: const Text('This will clear your phone verification and local data. Continue?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) _logout(context);
              },
            ),
            const Spacer(),
            const Text(
              "MyGermanFreund v1.0.0",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

