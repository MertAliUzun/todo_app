import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tema Seçimi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, themeState) {
                return DropdownButton<AppTheme>(
                  dropdownColor: theme.colorScheme.secondaryContainer,
                  value: themeState.appTheme,
                  items: [
                    DropdownMenuItem(
                      value: AppTheme.light,
                      child: Text('Açık Tema', style: theme.textTheme.bodyLarge,),
                    ),
                    DropdownMenuItem(
                      value: AppTheme.dark,
                      child: Text('Koyu Tema', style: theme.textTheme.bodyLarge,),
                    ),
                  ],
                  onChanged: (AppTheme? newTheme) {
                    if (newTheme != null) {
                      context.read<ThemeCubit>().changeTheme(newTheme);
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}   