import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/themes/space_theme.dart';
import '../themes/light_theme.dart';
import '../themes/dark_theme.dart';
import '../themes/neon_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppTheme { light, dark, neon, space }

class ThemeState {
  final AppTheme appTheme;
  final ThemeData themeData;
  ThemeState({required this.appTheme, required this.themeData});
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(AppTheme initialTheme)
      : super(ThemeState(
          appTheme: initialTheme,
          themeData: initialTheme == AppTheme.light
              ? lightTheme
              : initialTheme == AppTheme.neon
                  ? neonTheme
                  : initialTheme == AppTheme.dark
                    ? darkTheme
                    : spaceTheme,
        ));

  static Future<AppTheme> getInitialTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString('app_theme');
    if (themeString == 'light') return AppTheme.light;
    if (themeString == 'neon') return AppTheme.neon;
    if (themeString == 'dark') return AppTheme.dark;
    return AppTheme.space;
  }

  Future<void> changeTheme(AppTheme appTheme, {bool save = true}) async {
    switch (appTheme) {
      case AppTheme.light:
        emit(ThemeState(appTheme: appTheme, themeData: lightTheme));
        break;
      case AppTheme.dark:
        emit(ThemeState(appTheme: appTheme, themeData: darkTheme));
        break;
      case AppTheme.neon:
        emit(ThemeState(appTheme: appTheme, themeData: neonTheme));
        break;
      case AppTheme.space:
        emit(ThemeState(appTheme: appTheme, themeData: spaceTheme));
        break;
    }
    if (save) {
      final prefs = await SharedPreferences.getInstance();
      String themeStr = appTheme == AppTheme.light
          ? 'light'
          : appTheme == AppTheme.neon
              ? 'neon'
              : appTheme == AppTheme.dark
                ? 'dark'
                : 'space';
      await prefs.setString('app_theme', themeStr);
    }
  }
} 