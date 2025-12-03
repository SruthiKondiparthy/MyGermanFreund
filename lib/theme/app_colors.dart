import 'package:flutter/material.dart';

/// 🎨 Centralized color palette for MyGermanFreund.
class AppColors {
  // --- Core Brand Colors ---
  static const Color primary = Color(0xFF1565C0); // Blue accent
  static const Color secondary = Color(0xFF5E92F3); // Light blue accent
  static const Color accent = Color(0xFF2196F3);

  // --- Backgrounds & Surfaces ---
  static const Color background = Color(0xFFF9FAFB); // App background
  static const Color surface = Color(0xFFFFFFFF); // Card surfaces, panels
  static const Color border = Color(0xFFE5E7EB); // Subtle gray border

  // --- Text Colors ---
  static const Color textPrimary = Color(0xFF1E1E1E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);

  // --- Status / Utility Colors ---
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);

  // --- Optional Transparency Helpers ---
  static const Color overlay = Color(0x1A000000); // 10% black overlay
  static const Color shadow = Color(0x33000000); // 20% black for shadows
}
