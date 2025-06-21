import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/presentation/todo_cubit.dart';
import 'package:todo_app/presentation/todo_view.dart';
import 'package:todo_app/presentation/settings_page.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  int _selectedIndex = 0;
  // Önceden tanımlanmış kategoriler
  final List<String> _categories = ['None','İş', 'Okul', 'Kişisel', 'Alışveriş', 'Sağlık'];

  @override
  Widget build(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();
    
    // When the page is built, update the cubit's index
    WidgetsBinding.instance.addPostFrameCallback((_) {
      todoCubit.changeIndex(_selectedIndex);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Row(
          children: [
            BlocBuilder<TodoCubit, List<Todo>>(
              builder: (context, _) {
                final currentCategory = todoCubit.selectedCategory;
                return PopupMenuButton<String?>(
                  offset: const Offset(0, 40), // Dropdown menünün konumu
                  tooltip: 'Kategori Filtrele',
                  onSelected: (String? category) {
                    todoCubit.changeCategory(category);
                  },
                  itemBuilder: (BuildContext context) {
                    final items = <PopupMenuEntry<String?>>[];
                    
                    // Önceden tanımlanmış kategorileri ekle
                    for (final category in _categories) {
                      items.add(
                        PopupMenuItem<String?>(
                          value: category,
                          child: Center(
                            child: Text(
                              category,
                              style: TextStyle(
                                fontWeight: currentCategory == category ? FontWeight.bold : FontWeight.normal,
                                color: currentCategory == category ? Colors.blue : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    
                    return items;
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        currentCategory ?? 'None',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          // Sıralama butonu
          PopupMenuButton<SortBy>(
            icon: const Icon(Icons.sort),
            offset: const Offset(0, 40), // Dropdown menünün konumu
            tooltip: 'Sırala',
            onSelected: (SortBy sortBy) {
              todoCubit.changeSortCriteria(sortBy);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortBy>>[
              const PopupMenuItem<SortBy>(
                value: SortBy.name,
                child: Row(
                  children: [
                    Icon(Icons.sort_by_alpha),
                    SizedBox(width: 8),
                    Text('İsme Göre'),
                  ],
                ),
              ),
              const PopupMenuItem<SortBy>(
                value: SortBy.date,
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 8),
                    Text('Tarihe Göre'),
                  ],
                ),
              ),
              const PopupMenuItem<SortBy>(
                value: SortBy.priority,
                child: Row(
                  children: [
                    Icon(Icons.priority_high),
                    SizedBox(width: 8),
                    Text('Önceliğe Göre'),
                  ],
                ),
              ),
            ],
          ),
          // Settings butonu
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Ayarlar',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: TodoView(selectedIndex: _selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          todoCubit.changeIndex(index);
        },
        items: [
          // Todo Tab
          BottomNavigationBarItem(
            icon: DragTarget<Todo>(
              onAccept: (todo) {
                todoCubit.updateTodoState(todo, 0); //uodate completion state to todo
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  decoration: BoxDecoration(
                    color: candidateData.isNotEmpty ? Colors.blue.withOpacity(0.3) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.list),
                );
              },
            ),
            label: 'Todo',
          ),
          // In Progress Tab
          BottomNavigationBarItem(
            icon: DragTarget<Todo>(
              onAccept: (todo) {
                todoCubit.updateTodoState(todo, 1); //uodate completion state to in progress
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  decoration: BoxDecoration(
                    color: candidateData.isNotEmpty ? Colors.orange.withOpacity(0.3) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.pending_actions),
                );
              },
            ),
            label: 'In Progress',
          ),
          // Done Tab
          BottomNavigationBarItem(
            icon: DragTarget<Todo>(
              onAccept: (todo) {
                todoCubit.updateTodoState(todo, 2); //uodate completion state to done
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  decoration: BoxDecoration(
                    color: candidateData.isNotEmpty ? Colors.green.withOpacity(0.3) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.check_circle),
                );
              },
            ),
            label: 'Done',
          ),
        ],
      ),
    );
  }
}