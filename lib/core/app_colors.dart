import 'package:flutter/material.dart';

/// Shared semantic colors and minimal Material themes.
abstract final class AppColors {
  static const cameraBackground = Color(0xFF101715);
  static const transparent = Colors.transparent;

  static Color primary(BuildContext c) => Theme.of(c).colorScheme.primary;
  static Color surface(BuildContext c) =>
      Theme.of(c).colorScheme.surfaceContainerLow;
  static Color muted(BuildContext c) =>
      Theme.of(c).colorScheme.onSurfaceVariant;
  static Color error(BuildContext c) => Theme.of(c).colorScheme.error;
  static Color favourite(BuildContext c) => Theme.of(c).colorScheme.error;
  static Color rating(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark
      ? const Color(0xFFE6BD6A)
      : const Color(0xFF946600);
  static Color offline(BuildContext c) =>
      Theme.of(c).colorScheme.tertiaryContainer;

  static ThemeData theme(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF37685B),
      brightness: brightness,
      surface: dark ? const Color(0xFF111614) : const Color(0xFFFAFBF9),
    );
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: scheme.outlineVariant),
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.7,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLow,
        surfaceTintColor: transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.secondaryContainer,
        surfaceTintColor: transparent,
        height: 76,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 0.5,
      ),
    );
  }
}
