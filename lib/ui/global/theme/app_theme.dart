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
    primaryColor: const Color.fromARGB(255, 24, 51, 254),
    backgroundColor: const Color.fromARGB(255, 250, 250, 250),
    scaffoldBackgroundColor: const Color.fromARGB(255, 250, 250, 250),
    colorScheme: const ColorScheme(
      primary: Color.fromARGB(255, 24, 51, 254),
      secondary: Color.fromARGB(255, 254, 104, 99),
      surface: Color.fromARGB(255, 250, 250, 250),
      background: Color.fromARGB(255, 250, 250, 250),
      error: Color.fromARGB(255, 254, 99, 101),
      onPrimary: Color.fromARGB(255, 250, 250, 250),
      onSecondary: Color.fromARGB(255, 250, 250, 250),
      onSurface: Color.fromARGB(255, 20, 20, 20),
      onBackground: Color.fromARGB(255, 20, 20, 20),
      onError: Color.fromARGB(255, 250, 250, 250),
      brightness: Brightness.light,
    ),
  ),
  AppTheme.dark: ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color.fromARGB(255, 24, 51, 254),
    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
    scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
    colorScheme: const ColorScheme(
      primary: Color.fromARGB(255, 24, 51, 254),
      secondary: Color.fromARGB(255, 254, 104, 99),
      surface: Color.fromARGB(255, 0, 0, 0),
      background: Color.fromARGB(255, 0, 0, 0),
      error: Color.fromARGB(255, 254, 99, 101),
      onPrimary: Color.fromARGB(255, 250, 250, 250),
      onSecondary: Color.fromARGB(255, 250, 250, 250),
      onSurface: Color.fromARGB(255, 250, 250, 250),
      onBackground: Color.fromARGB(255, 250, 250, 250),
      onError: Color.fromARGB(255, 250, 250, 250),
      brightness: Brightness.dark,
    ),
  ),
};
