import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/presentation/todo_cubit.dart';
import 'package:todo_app/presentation/todo_view.dart';

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

    return Scaffold(
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
                todoCubit.updateTodoState(todo, 0);
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
                todoCubit.updateTodoState(todo, 1);
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
                todoCubit.updateTodoState(todo, 2);
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