import 'package:flutter/material.dart';

enum AppThemeMode {
  classicDark,
  midnightBlue,
  forestGreen,
  deepPurple,
  sunsetOrange,
  oceanBreeze;

  String get label {
    switch (this) {
      case AppThemeMode.classicDark: return 'Klasik Karanlık';
      case AppThemeMode.midnightBlue: return 'Gece Mavisi';
      case AppThemeMode.forestGreen: return 'Orman Yeşili';
      case AppThemeMode.deepPurple: return 'Derin Mor';
      case AppThemeMode.sunsetOrange: return 'Gün Batımı';
      case AppThemeMode.oceanBreeze: return 'Okyanus Esintisi';
    }
  }

  Color get primaryColor {
    switch (this) {
      case AppThemeMode.classicDark: return Colors.blueAccent;
      case AppThemeMode.midnightBlue: return const Color(0xFF1976D2);
      case AppThemeMode.forestGreen: return const Color(0xFF43A047);
      case AppThemeMode.deepPurple: return const Color(0xFF7E57C2);
      case AppThemeMode.sunsetOrange: return const Color(0xFFFB8C00);
      case AppThemeMode.oceanBreeze: return const Color(0xFF00ACC1);
    }
  }
}

class AppTheme {
  static ThemeData getTheme(AppThemeMode mode) {
    final Color primaryColor = mode.primaryColor;
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: primaryColor,
        surface: const Color(0xFF1E1E1E),
        onSurface: Colors.white,
        primaryContainer: primaryColor.withAlpha(50),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), 
          side: BorderSide(color: Colors.white.withAlpha(13))
        ),
      ),
      tabBarTheme: TabBarThemeData(
        indicatorColor: primaryColor,
        labelColor: primaryColor,
        unselectedLabelColor: Colors.white54,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
