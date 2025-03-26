import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static const Color kPrimary = Color(0xFFD1A661);
  static const Color kWhite = Color(0xFFFEFEFE);
  static LinearGradient customOnboardingGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      const Color(0xFF110C1D).withOpacity(0.0),
      const Color(0xFF110C1D),
    ],
  );
}

class LoginAppColors {
  static const Color kPrimary = Color(0xFFD1A661);
  static const Color kWhite = Color(0xFFFEFEFE);
  static const Color kGrey60 = Color(0xFF9CA4AB);
  static const Color kGrey70 = Color(0xFF78828A);
  static const Color kGrey100 = Color(0xFF171725);
}