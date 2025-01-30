import 'package:flutter/material.dart';

class AppPalette {
  static const Color kPrimaryColor =
      Color.fromARGB(255, 255, 218, 7); // Amber color for Pravasi Tax
  static const Color kSecondaryColor = Color(0xFF2196F3); // Blue
  static const Color kBackgroundColor = Colors.white;
  static const Color kTextColor = Colors.black;
}

class AppTextStyle {
  static const TextStyle kDisplayTitleR = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppPalette.kTextColor,
    fontFamily: 'Roboto',
  );

  static const TextStyle kBodyTextR = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppPalette.kTextColor,
    fontFamily: 'Roboto',
  );
}
