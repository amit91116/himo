import 'package:flutter/material.dart';

enum AppTheme { light, dark }

String getThemeString(AppTheme appTheme) {
  switch (appTheme) {
    case AppTheme.light:
      return "light";
    case AppTheme.dark:
      return "dark";
  }
}

AppTheme getThemeEnum(String appTheme) {
  switch (appTheme) {
    case "light":
      return AppTheme.light;
    case "dark":
      return AppTheme.dark;
  }
  return AppTheme.light;
}

final appThemeData = {
  AppTheme.light: ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color.fromARGB(255, 39, 174, 25),
    backgroundColor: const Color.fromARGB(255, 217, 229, 220),
    scaffoldBackgroundColor: const Color.fromARGB(255, 236, 240, 238),
    colorScheme: const ColorScheme(
      primary: Color.fromARGB(255, 39, 174, 25),
      secondary: Color.fromARGB(255, 254, 104, 99),
      surface: Color.fromARGB(255, 236, 240, 238),
      background: Color.fromARGB(255, 217, 229, 220),
      error: Color.fromARGB(255, 254, 99, 101),
      onPrimary: Color.fromARGB(255, 33, 47, 40),
      onSecondary: Color.fromARGB(255, 33, 47, 40),
      onSurface: Color.fromARGB(255, 33, 47, 40),
      onBackground: Color.fromARGB(255, 33, 47, 40),
      onError: Color.fromARGB(255, 250, 250, 250),
      brightness: Brightness.light,
    ),
  ),
  AppTheme.dark: ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color.fromARGB(255, 39, 174, 25),
    backgroundColor: const Color.fromARGB(255, 20, 29, 26),
    scaffoldBackgroundColor: const Color.fromARGB(255, 33, 47, 40),
    colorScheme: const ColorScheme(
      primary: Color.fromARGB(255, 39, 174, 25),
      secondary: Color.fromARGB(255, 254, 104, 99),
      surface: Color.fromARGB(255, 33, 47, 40),
      background: Color.fromARGB(255, 20, 29, 26),
      error: Color.fromARGB(255, 254, 99, 101),
      onPrimary: Color.fromARGB(255, 33, 47, 40),
      onSecondary: Color.fromARGB(255, 33, 47, 40),
      onSurface: Color.fromARGB(255, 188, 199, 195),
      onBackground: Color.fromARGB(255, 188, 199, 195),
      onError: Color.fromARGB(255, 250, 250, 250),
      brightness: Brightness.dark,
    ),
  ),
};
