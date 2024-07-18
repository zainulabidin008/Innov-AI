// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppGradient {
  static LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.white.withOpacity(0.2),
      AppColors.white.withOpacity(0.3),
    ],
  );

  static LinearGradient darkWhiteGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.white.withOpacity(0.4),
      AppColors.white.withOpacity(0.5),
    ],
  );

  static LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: const [
      AppColors.greenn,
      AppColors.greenn,
    ],
  );

  static LinearGradient whiteGradient = LinearGradient(
    colors: [
      AppColors.white.withOpacity(0),
      AppColors.white,
      AppColors.white.withOpacity(0),
    ],
  );

  static LinearGradient reversePurpleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: const [
      Color(0xff4039A3),
      AppColors.greenn,
    ],
  );

  static LinearGradient horizontalPurpleGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: const [
      Color(0xff4941B0),
      AppColors.greenn,
    ],
  );

  static LinearGradient reverseHorizontalPurpleGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: const [
      AppColors.greenn,
      Color(0xff4941B0),
    ],
  );
}
