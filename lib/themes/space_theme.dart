import 'package:flutter/material.dart';

final ThemeData spaceTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.blueGrey[900],
  scaffoldBackgroundColor: Color(0xFF0A0F1C),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0F172A),
    foregroundColor: Colors.white,
  ),
  bottomAppBarTheme: const BottomAppBarThemeData(
    color: Color(0xFF0F172A),
  ),
  
  colorScheme: ColorScheme.dark(
    primary: Color(0x3860A5FA),
    secondary: Colors.tealAccent,
    background: Colors.black,
    surface: Colors.grey.shade900,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onBackground: Colors.white,
    onSurface: Colors.white,
    secondaryContainer: Color(0x3860A5FA),
    onSecondaryContainer: Color(0xFF121F2F),
    primaryContainer: Color(0xFF6366F1),
    primaryFixed: Colors.redAccent,
    tertiary: Colors.green,
    onTertiary: Colors.orange,
    tertiaryContainer: Colors.red,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0x3860A5FA),
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
    bodySmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  ),
  cardColor: Color(0x3860A5FA),
  shadowColor: Colors.black.withOpacity(0.3),
  dividerColor: Colors.teal,
  hintColor: Color(0xFF00F5D4),
  disabledColor: Colors.grey,
  focusColor: Color(0xFF00F5D4),
  buttonTheme: ButtonThemeData(
    buttonColor: Color(0xFF38BDF8), 
  ),
  inputDecorationTheme: InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFF38BDF8),
      ),
    ),
    floatingLabelStyle: TextStyle(
      color: Color(0xFF38BDF8),
    ),
  ),
  iconTheme: const IconThemeData(color: Color(0xFF60A5FA)),
  useMaterial3: true,
); 