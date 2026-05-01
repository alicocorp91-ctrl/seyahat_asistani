import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppThemeMode {
  classicDark,
  midnightBlue,
  forestGreen,
  deepPurple,
  sunsetOrange,
  oceanBreeze;

  String get label {
    switch (this) {
      case AppThemeMode.classicDark:
        return 'Klasik Karanlık';
      case AppThemeMode.midnightBlue:
        return 'Gece Mavisi';
      case AppThemeMode.forestGreen:
        return 'Orman Yeşili';
      case AppThemeMode.deepPurple:
        return 'Derin Mor';
      case AppThemeMode.sunsetOrange:
        return 'Gün Batımı';
      case AppThemeMode.oceanBreeze:
        return 'Okyanus Esintisi';
    }
  }

  Color get primaryColor {
    switch (this) {
      case AppThemeMode.classicDark:
        return Colors.blueAccent;
      case AppThemeMode.midnightBlue:
        return const Color(0xFF1976D2);
      case AppThemeMode.forestGreen:
        return const Color(0xFF43A047);
      case AppThemeMode.deepPurple:
        return const Color(0xFF7E57C2);
      case AppThemeMode.sunsetOrange:
        return const Color(0xFFFB8C00);
      case AppThemeMode.oceanBreeze:
        return const Color(0xFF00ACC1);
    }
  }

  Color get onPrimaryColor => Colors.white;
  Color get backgroundColor => const Color(0xFF121212);
  Color get surfaceColor => const Color(0xFF1E1E1E);
}

class AppTheme {
  AppTheme._();

  static const Color _scaffoldBg = Color(0xFF121212);
  static const Color _surfaceColor = Color(0xFF1E1E1E);
  static const Color _cardBorderColor = Color(0x0DFFFFFF);
  static const Color _dividerColor = Color(0x1AFFFFFF);
  static const Color _unselectedColor = Color(0x8AFFFFFF);

  static ThemeData getTheme(AppThemeMode mode) {
    final Color primary = mode.primaryColor;

    // ✅ FIX 1: const eklendi (prefer_const_constructors - satır 72)
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: _scaffoldBg,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _scaffoldBg,

      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: primary,
        surface: _surfaceColor,
        onSurface: Colors.white,
        // ✅ FIX 2: withOpacity → withValues(alpha:) (satır 91)
        primaryContainer: primary.withValues(alpha: 0.15),
        onPrimaryContainer: Colors.white,
        error: const Color(0xFFCF6679),
        onError: Colors.white,
      ),

      // ✅ AppBar teması
      appBarTheme: const AppBarTheme(
        // ✅ FIX 3: const eklendi (prefer_const_constructors - satır 99)
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
        ),
      ),

      // ✅ Card teması
      cardTheme: CardThemeData(
        color: _surfaceColor,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: _cardBorderColor),
        ),
      ),

      // ✅ TabBar teması
      tabBarTheme: TabBarThemeData(
        indicatorColor: primary,
        labelColor: primary,
        unselectedLabelColor: _unselectedColor,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 13,
        ),
      ),

      // ✅ FAB teması
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // ✅ FilledButton teması
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 14,
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),

      // ✅ ElevatedButton teması
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _surfaceColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            // ✅ FIX 4: withOpacity → withValues(alpha:) (satır 180)
            side: BorderSide(color: primary.withValues(alpha: 0.5)),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 14,
          ),
        ),
      ),

      // ✅ TextButton teması
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // ✅ OutlinedButton teması
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          // ✅ FIX 5: withOpacity → withValues(alpha:) (satır 203)
          side: BorderSide(color: primary.withValues(alpha: 0.5)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 14,
          ),
        ),
      ),

      // ✅ Input decoration teması
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _cardBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _cardBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFCF6679)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFCF6679),
            width: 2,
          ),
        ),
        labelStyle: const TextStyle(color: _unselectedColor),
        hintStyle: const TextStyle(color: _unselectedColor),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),

      // ✅ Checkbox teması
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primary;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: const BorderSide(color: _unselectedColor, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      // ✅ Switch teması
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return _unselectedColor;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primary;
          return _surfaceColor;
        }),
      ),

      // ✅ Divider teması
      dividerTheme: const DividerThemeData(
        color: _dividerColor,
        thickness: 1,
        space: 1,
      ),

      // ✅ BottomSheet teması
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: _surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
      ),

      // ✅ Dialog teması
      dialogTheme: DialogThemeData(
        backgroundColor: _surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: const TextStyle(
          color: _unselectedColor,
          fontSize: 14,
        ),
      ),

      // ✅ SnackBar teması
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _surfaceColor,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: _cardBorderColor),
        ),
        behavior: SnackBarBehavior.floating,
        actionTextColor: primary,
      ),

      // ✅ ListTile teması
      listTileTheme: const ListTileThemeData(
        iconColor: _unselectedColor,
        textColor: Colors.white,
        subtitleTextStyle: TextStyle(
          color: _unselectedColor,
          fontSize: 13,
        ),
      ),

      // ✅ Chip teması
      chipTheme: ChipThemeData(
        backgroundColor: _surfaceColor,
        side: const BorderSide(color: _cardBorderColor),
        labelStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // ✅ ProgressIndicator teması
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primary,
        // ✅ FIX 6: withOpacity → withValues(alpha:) (satır 343)
        linearTrackColor: primary.withValues(alpha: 0.2),
      ),
    );
  }
}
