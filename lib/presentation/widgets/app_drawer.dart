import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../todo_cubit.dart';
import '../theme_cubit.dart';
import '../../domain/models/todo.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final todoCubit = context.read<TodoCubit>();
    
    // Önceden tanımlanmış kategoriler
    final List<String> categories = ['None', 'İş', 'Okul', 'Kişisel', 'Alışveriş', 'Sağlık'];

    return Drawer(
      child: Container(
        color: theme.drawerTheme.backgroundColor ?? theme.scaffoldBackgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.task_alt,
                    color: theme.colorScheme.onPrimary,
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Todo Uygulaması',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // Kategori Filtreleme Bölümü
            _buildSectionHeader(context, 'Kategori Filtreleme'),
            BlocBuilder<TodoCubit, List<Todo>>(
              builder: (context, _) {
                final currentCategory = todoCubit.selectedCategory;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      value: currentCategory,
                      isExpanded: true,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      dropdownColor: theme.colorScheme.secondaryContainer,
                      items: categories.map((String category) {
                        return DropdownMenuItem<String?>(
                          value: category,
                          child: Text(
                            category,
                            style: theme.textTheme.bodyLarge,
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newCategory) {
                        todoCubit.changeCategory(newCategory);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
            ),
            
            const Divider(),
            
            // Sıralama Bölümü
            _buildSectionHeader(context, 'Sıralama'),
            BlocBuilder<TodoCubit, List<Todo>>(
              builder: (context, _) {
                final currentSort = todoCubit.sortCriteria;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<SortBy>(
                      value: currentSort,
                      isExpanded: true,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      dropdownColor: theme.colorScheme.secondaryContainer,
                      items: [
                        DropdownMenuItem<SortBy>(
                          value: SortBy.name,
                          child: Row(
                            children: [
                              Icon(Icons.sort_by_alpha, size: 20),
                              const SizedBox(width: 8),
                              Text('İsme Göre', style: theme.textTheme.bodyLarge),
                            ],
                          ),
                        ),
                        DropdownMenuItem<SortBy>(
                          value: SortBy.date,
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, size: 20),
                              const SizedBox(width: 8),
                              Text('Tarihe Göre', style: theme.textTheme.bodyLarge),
                            ],
                          ),
                        ),
                        DropdownMenuItem<SortBy>(
                          value: SortBy.priority,
                          child: Row(
                            children: [
                              Icon(Icons.priority_high, size: 20),
                              const SizedBox(width: 8),
                              Text('Önceliğe Göre', style: theme.textTheme.bodyLarge),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (SortBy? newSort) {
                        if (newSort != null) {
                          todoCubit.changeSortCriteria(newSort);
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
            
            const Divider(),
            
            // Tema Seçimi Bölümü
            _buildSectionHeader(context, 'Tema Seçimi'),
            BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, themeState) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<AppTheme>(
                      value: themeState.appTheme,
                      isExpanded: true,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      dropdownColor: theme.colorScheme.secondaryContainer,
                      items: [
                        DropdownMenuItem<AppTheme>(
                          value: AppTheme.light,
                          child: Row(
                            children: [
                              Icon(Icons.light_mode, size: 20),
                              const SizedBox(width: 8),
                              Text('Açık Tema', style: theme.textTheme.bodyLarge),
                            ],
                          ),
                        ),
                        DropdownMenuItem<AppTheme>(
                          value: AppTheme.dark,
                          child: Row(
                            children: [
                              Icon(Icons.dark_mode, size: 20),
                              const SizedBox(width: 8),
                              Text('Koyu Tema', style: theme.textTheme.bodyLarge),
                            ],
                          ),
                        ),
                        DropdownMenuItem<AppTheme>(
                          value: AppTheme.neon,
                          child: Row(
                            children: [
                              Icon(Icons.flash_on, size: 20),
                              const SizedBox(width: 8),
                              Text('Neon Tema', style: theme.textTheme.bodyLarge),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (AppTheme? newTheme) async {
                        if (newTheme != null) {
                          await context.read<ThemeCubit>().changeTheme(newTheme);
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }


} 