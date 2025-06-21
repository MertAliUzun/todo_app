import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, themeMode) {
                return DropdownButton<ThemeMode>(
                  value: themeMode,
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('Açık Tema'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text('Koyu Tema'),
                    ),
                  ],
                  onChanged: (ThemeMode? newMode) {
                    if (newMode != null) {
                      context.read<ThemeCubit>().changeTheme(newMode);
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