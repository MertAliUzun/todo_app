import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../themes/light_theme.dart';
import '../themes/dark_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppTheme { light, dark }

class ThemeState {
  final AppTheme appTheme;
  final ThemeData themeData;
  ThemeState({required this.appTheme, required this.themeData});
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(AppTheme initialTheme)
      : super(ThemeState(
          appTheme: initialTheme,
          themeData: initialTheme == AppTheme.light ? lightTheme : darkTheme,
        ));

  static Future<AppTheme> getInitialTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString('app_theme');
    if (themeString == 'light') return AppTheme.light;
    return AppTheme.dark;
  }

  Future<void> changeTheme(AppTheme appTheme, {bool save = true}) async {
    switch (appTheme) {
      case AppTheme.light:
        emit(ThemeState(appTheme: appTheme, themeData: lightTheme));
        break;
      case AppTheme.dark:
        emit(ThemeState(appTheme: appTheme, themeData: darkTheme));
        break;
    }
    if (save) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_theme', appTheme == AppTheme.light ? 'light' : 'dark');
    }
  }
} 