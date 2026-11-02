import 'package:flutter/material.dart';

/// The app's shared palette. Keep color values here rather than in screens.
abstract final class AppColors {
  static const primary = Color(0xFF25635B);
  static const onPrimary = Color(0xFFFFFFFF);
  static const background = Color(0xFFF7F8FA);
  static const surface = Color(0xFFFFFFFF);
  static const text = Color(0xFF20252B);
  static const muted = Color(0xFF69747D);
  static const border = Color(0xFFE2E7EA);
  static const selected = Color(0xFFE4F1EE);
  static const error = Color(0xFFB3261E);
  static const favourite = Color(0xFFC74653);
  static const rating = Color(0xFFB57900);
  static const offline = Color(0xFFFFF1CF);
  static const cameraBackground = Color(0xFF111820);
  static const transparent = Color(0x00000000);

  static const scheme = ColorScheme.light(
    primary: primary,
    onPrimary: onPrimary,
    secondary: primary,
    onSecondary: onPrimary,
    secondaryContainer: selected,
    onSecondaryContainer: primary,
    surface: surface,
    onSurface: text,
    onSurfaceVariant: muted,
    outline: border,
    error: error,
    onError: onPrimary,
  );
}
