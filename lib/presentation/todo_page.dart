import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/presentation/todo_cubit.dart';
import 'package:todo_app/presentation/todo_view.dart';
import 'package:todo_app/presentation/widgets/app_drawer.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();
    
    // When the page is built, update the cubit's index
    WidgetsBinding.instance.addPostFrameCallback((_) {
      todoCubit.changeIndex(_selectedIndex);
    });
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        scrolledUnderElevation: 0,
        title: BlocBuilder<TodoCubit, List<Todo>>( //IN FUTURE change this to number of todos
          builder: (context, _) {
            final currentCategory = todoCubit.selectedCategory;
            return Text(
              currentCategory ?? 'Tüm Görevler',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            );
          },
        ),
        centerTitle: true,
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