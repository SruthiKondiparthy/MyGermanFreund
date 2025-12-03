import 'package:firebase_auth/firebase_auth.dart';

/// Handles phone number verification and OTP sign-in using Firebase Auth.
class PhoneAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;

  /// Sends OTP to the given [phoneNumber].
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential credential) onVerified,
    required void Function(FirebaseAuthException e) onError,
    required void Function(String verificationId, int? resendToken) onCodeSent,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {
        onVerified(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        onError(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        onCodeSent(verificationId, resendToken);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  /// Submits the OTP code manually.
  Future<UserCredential> signInWithSmsCode(String smsCode) async {
    if (_verificationId == null) {
      throw Exception('No verification ID. Please request OTP first.');
    }

    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: smsCode,
    );
    return await _auth.signInWithCredential(credential);
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Returns the currently signed-in Firebase user.
  User? get currentUser => _auth.currentUser;
}

