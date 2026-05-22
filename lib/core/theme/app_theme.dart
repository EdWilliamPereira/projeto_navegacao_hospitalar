import 'package:flutter/material.dart';

/// Provides light and high-contrast themes.
/// High-contrast satisfies FR-10 and NFR-10 (≥ 4.5:1 ratio for small text).
class AppTheme {
  AppTheme._();

  static const Color _seedColor = Color(0xFF0066CC);

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    ),
    // Minimum 48×48 dp touch targets — WCAG 2.1 success criterion 2.5.5
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size(48, 48)),
      ),
    ),
    filledButtonTheme: const FilledButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size(48, 48)),
      ),
    ),
  );

  /// High-contrast dark theme — FR-10, NFR-10.
  /// Black background + white text guarantees ≥ 21:1 contrast ratio.
  static ThemeData get highContrast => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
      surface: Colors.black,
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.black,
    textTheme: Typography.material2021().white,
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size(48, 48)),
      ),
    ),
  );
}
