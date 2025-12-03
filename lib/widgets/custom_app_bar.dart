import 'package:flutter/material.dart';

/// A reusable app bar with both Back and Home navigation buttons.
/// Automatically shows:
/// - Back button if possible
/// - Home button always
PreferredSizeWidget customAppBar(BuildContext context, String title) {
  return AppBar(
    title: Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
    ),
    centerTitle: true,
    backgroundColor: Colors.blueAccent,
    elevation: 2,
    leading: Navigator.canPop(context)
        ? IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      tooltip: "Back",
      onPressed: () {
        Navigator.pop(context);
      },
    )
        : null,
    actions: [
      IconButton(
        icon: const Icon(Icons.home, color: Colors.white),
        tooltip: "Home",
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/',
                (route) => false, // clears all intermediate pages
          );
        },
      ),
    ],
  );
}
