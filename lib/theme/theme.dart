import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agri_connect/theme/custom_theme/elevated_button_theme.dart';

// Define the Sarabun (or Montserrat) text theme and adapt text colors
TextTheme sarabunTextTheme(ColorScheme colorScheme) {
  return GoogleFonts.montserratTextTheme().copyWith(
    bodyLarge: TextStyle(color: colorScheme.onSurface),  // Replaces bodyText1
    bodyMedium: TextStyle(color: colorScheme.onSurface), // Replaces bodyText2
    headlineLarge: TextStyle(color: colorScheme.primary), // Replaces headline1
    headlineMedium: TextStyle(color: colorScheme.primary), // Replaces headline2
    titleLarge: TextStyle(color: colorScheme.onSecondary), // Replaces subtitle1
    titleMedium: TextStyle(color: colorScheme.onSecondary), // Replaces subtitle2
  );
}

// Light theme configuration
ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: Colors.black,
    secondary: Colors.grey.withOpacity(0.5),
    surface: Colors.grey.shade100,
    onSurface: Colors.black,
    onSecondary: Colors.grey,
  ),
  elevatedButtonTheme: EElevatedButtonTheme.lightElevatedButtonTheme,
  textTheme: sarabunTextTheme(const ColorScheme.light(
    primary: Colors.black,
    onSurface: Colors.black,
    onSecondary: Colors.grey,
  )),
);

// Dark theme configuration
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: Colors.white,
    secondary: Colors.transparent,
    surface: Colors.grey.shade900,
    onSurface: Colors.white,
    onSecondary: Colors.grey,
  ),
  elevatedButtonTheme: EElevatedButtonTheme.darkElevatedButtonTheme,
  textTheme: sarabunTextTheme(const ColorScheme.dark(
    primary: Colors.white,
    onSurface: Colors.white,
    onSecondary: Colors.grey,
  )),
);
