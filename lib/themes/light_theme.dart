import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blueGrey[500],
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey.shade300,
    foregroundColor: Colors.black,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black87),
    titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
  ),
  colorScheme: ColorScheme.light(
    primary: Colors.blueGrey,
    secondary: Colors.white70,
    background: Colors.white,
    surface: Colors.blueGrey.shade50,
    onPrimary: Colors.white70,
    onSecondary: Colors.white70,
    onBackground: Colors.black,
    onSurface: Colors.black,
    secondaryContainer: Colors.grey[950],
  ),
  cardColor: Colors.white,
  shadowColor: Colors.grey.withOpacity(0.08),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.blueGrey.shade50,
    foregroundColor: Colors.black,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
    bodyMedium: TextStyle(color: Colors.black87),
    bodySmall: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
  ),
  dividerColor: Colors.black,
  hintColor: Colors.black87,
  disabledColor: Colors.grey,
  iconTheme: IconThemeData(color: Colors.grey[800]),
  useMaterial3: true,
); 