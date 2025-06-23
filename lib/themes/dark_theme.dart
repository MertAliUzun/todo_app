import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.blueGrey[900],
  scaffoldBackgroundColor: Colors.grey[900],
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 0, 30, 20),
    foregroundColor: Colors.white,
  ),
  colorScheme: ColorScheme.dark(
    primary: Colors.teal,
    secondary: Colors.tealAccent,
    background: Colors.black,
    surface: Colors.grey.shade900,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onBackground: Colors.white,
    onSurface: Colors.white,
    secondaryContainer: Colors.grey[850],
  ),
  cardColor: Colors.grey[850],
  shadowColor: Colors.black.withOpacity(0.3),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.teal,
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
    bodySmall: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold),
  ),
  dividerColor: Colors.teal,
  hintColor: Colors.tealAccent,
  disabledColor: Colors.grey,
  iconTheme: const IconThemeData(color: Colors.tealAccent),
  useMaterial3: true,
); 