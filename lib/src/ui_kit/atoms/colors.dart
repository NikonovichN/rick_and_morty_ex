import 'package:flutter/material.dart';

final class NamedColors {
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);

  static const accentBrown = Color(0xFF5E454B);
  static const secondary = Color(0xFFD8B384);
  static const error = Color(0xFFEC4458);
  static const lemonChiffon = Color(0xFFF3F0D7);
  static const oldBurgundy = Color(0xFF242020);
  static const lightGrey = Color(0xFFD9D9D9);
  static const darkGrey = Color(0xFF414141);
  static const snow = Color(0xFFF6F6F6);
  static const dirtySnow = Color(0xFFA9A9A9);

  static const selectedAccent = Color.fromARGB(255, 182, 140, 13);
}

class AppLightColorScheme extends ColorScheme {
  const AppLightColorScheme()
    : super(
        brightness: Brightness.light,
        shadow: const Color.fromARGB(146, 180, 180, 180),
        primary: NamedColors.accentBrown,
        onPrimary: NamedColors.white,
        secondary: NamedColors.secondary,
        onSecondary: NamedColors.white,
        error: NamedColors.error,
        onError: NamedColors.white,
        surface: NamedColors.white,
        onSurface: NamedColors.black,
      );
}

class AppDarkColorScheme extends ColorScheme {
  const AppDarkColorScheme()
    : super(
        brightness: Brightness.dark,
        shadow: const Color.fromARGB(95, 83, 76, 76),
        primary: NamedColors.black,
        onPrimary: NamedColors.lemonChiffon,
        secondary: NamedColors.secondary,
        onSecondary: NamedColors.white,
        error: NamedColors.error,
        onError: NamedColors.white,
        surface: NamedColors.darkGrey,
        onSurface: NamedColors.white,
      );
}
