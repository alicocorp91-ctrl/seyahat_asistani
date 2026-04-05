import 'package:flutter/material.dart';
import '../models/enums.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color primaryPink = Color(0xFFE91E63); // Ana pembe
  static const Color surfaceDark = Color(0xFF121212);
  static const Color cardDark = Color(0xFF1E1E1E);

  static ThemeData getTheme(Gender gender) {
    final bool isFemale = gender == Gender.female;
    final Color mainColor = isFemale ? primaryPink : primaryBlue;
    final Color containerColor = isFemale ? const Color(0xFF880E4F) : const Color(0xFF0D47A1);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: surfaceDark,
      colorScheme: ColorScheme.dark(
        primary: mainColor,
        secondary: mainColor,
        surface: surfaceDark,
        onSurface: Colors.white,
        primaryContainer: containerColor,
        onPrimaryContainer: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), 
          side: BorderSide(color: Colors.white.withValues(alpha: 0.05))
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) => 
          states.contains(WidgetState.selected) ? mainColor : Colors.transparent),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  static ThemeData get darkTheme => getTheme(Gender.male);
  static ThemeData get lightTheme => getTheme(Gender.male);
}
