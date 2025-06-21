import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.deepPurple,
  scaffoldBackgroundColor: Colors.yellow[50],
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.deepPurple,
    foregroundColor: Colors.white,
  ),
  colorScheme: ColorScheme.light(
    primary: Colors.deepPurple,
    secondary: Colors.pink,
    background: Colors.yellow,
    surface: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onBackground: Colors.black,
    onSurface: Colors.black,
    secondaryContainer: Colors.grey[900]
  ),
  cardColor: Colors.white,
  shadowColor: Colors.deepPurple.withOpacity(0.2),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.deepPurple,
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.deepPurple),
    bodyMedium: TextStyle(color: Colors.black87),
    bodySmall: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold),
  ),
  dividerColor: Colors.pinkAccent,
  hintColor: Colors.deepPurpleAccent,
  disabledColor: Colors.grey,
  iconTheme: const IconThemeData(color: Colors.deepPurple),
  useMaterial3: true,
); 