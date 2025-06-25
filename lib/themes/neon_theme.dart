import 'package:flutter/material.dart';

const _primaryDark = Color.fromRGBO(34, 40, 49, 1); // #222831
const _secondaryDark = Color.fromRGBO(57, 62, 70, 1); // #393E46
const _accent = Color.fromRGBO(0, 173, 181, 1); // #00ADB5
const _light = Color.fromRGBO(238, 238, 238, 1); // #EEEEEE

final ThemeData neonTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: _primaryDark,
  scaffoldBackgroundColor: _secondaryDark,
  appBarTheme: const AppBarTheme(
    backgroundColor: _primaryDark,
    foregroundColor: _accent,
    elevation: 0,
    iconTheme: IconThemeData(color: _accent),
    titleTextStyle: TextStyle(color: _accent, fontWeight: FontWeight.bold, fontSize: 20),
  ),
  colorScheme: const ColorScheme.dark(
    primary: _accent,
    secondary: _accent,
    background: _secondaryDark,
    surface: _primaryDark,
    onPrimary: _light,
    onSecondary: _accent,
    onBackground: _light,
    onSurface: _light,
    secondaryContainer: _secondaryDark,
  ),
  cardColor: _primaryDark,
  shadowColor: Colors.black.withOpacity(0.3),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: _accent,
    foregroundColor: _primaryDark,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: _light, fontWeight: FontWeight.w600),
    bodyMedium: TextStyle(color: _light),
    bodySmall: TextStyle(color: _accent, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(color: _accent, fontWeight: FontWeight.bold),
  ),
  dividerColor: _accent,
  hintColor: _accent,
  disabledColor: Colors.grey,
  iconTheme: const IconThemeData(color: _accent),
  useMaterial3: true,
); 