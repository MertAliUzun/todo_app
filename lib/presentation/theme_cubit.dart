import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../themes/light_theme.dart';
import '../themes/dark_theme.dart';

enum AppTheme { light, dark }

class ThemeState {
  final AppTheme appTheme;
  final ThemeData themeData;
  ThemeState({required this.appTheme, required this.themeData});
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit()
      : super(ThemeState(
          appTheme: AppTheme.dark,
          themeData: darkTheme,
        ));

  void changeTheme(AppTheme appTheme) {
    switch (appTheme) {
      case AppTheme.light:
        emit(ThemeState(appTheme: appTheme, themeData: lightTheme));
        break;
      case AppTheme.dark:
        emit(ThemeState(appTheme: appTheme, themeData: darkTheme));
        break;
    }
  }
} 