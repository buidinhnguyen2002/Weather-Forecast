import 'package:weather_dashboard/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  splashColor: Colors.transparent,
  colorScheme: const ColorScheme.light(
    background: AppColors.background,
    primary: AppColors.primaryColor,
    secondary: AppColors.secondaryColor,
    error: Colors.red,
    onPrimary: Colors.white,
    onError: Colors.white,
  ),
  textTheme: TextTheme(
    headlineLarge: GoogleFonts.rubik(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    headlineMedium: GoogleFonts.rubik(
      color: Colors.white,
      fontSize: 15,
      fontWeight: FontWeight.w400,
    ),
    headlineSmall: GoogleFonts.rubik(
      color: Colors.white,
      fontSize: 13,
    ),
    titleLarge: GoogleFonts.rubik(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    titleMedium: GoogleFonts.rubik(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    titleSmall: GoogleFonts.rubik(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),
  dividerColor: const Color.fromARGB(93, 189, 189, 187),
);
ThemeData darkMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  splashColor: Colors.transparent,
  colorScheme: const ColorScheme.light(
    background: AppColors.background,
    primary: AppColors.primaryColor,
    secondary: AppColors.secondaryColor,
    error: Colors.red,
    onPrimary: Colors.white,
    onError: Colors.white,
  ),
  textTheme: TextTheme(
    headlineLarge: GoogleFonts.rubik(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w700,
    ),
    headlineMedium: GoogleFonts.rubik(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: GoogleFonts.rubik(
      color: Colors.white,
      fontSize: 10,
    ),
    titleLarge: GoogleFonts.rubik(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    titleMedium: GoogleFonts.rubik(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    titleSmall: GoogleFonts.rubik(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),
  dividerColor: const Color.fromARGB(93, 189, 189, 187),
);
