import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/presentation/todo_cubit.dart';
import 'package:todo_app/presentation/widgets/todo_card_widget.dart';

class TodoView extends StatefulWidget {
  final int selectedIndex;

  const TodoView({super.key, required this.selectedIndex});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  void _showAddTodoBox(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();
    final textController = TextEditingController();
    int selectedPriority = 1; // Default olarak Medium (1) seçili

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Yeni Görev Ekle'),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      labelText: 'Görev',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      Text('Priority',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24
                      ),
                      ),
                      const SizedBox(height: 16,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                selectedPriority = 0;
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: selectedPriority == 0 ? Colors.blue.withOpacity(0.2) : null,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: selectedPriority == 0 ? Colors.blue : Colors.transparent,
                                ),
                              ),
                            ),
                            child: const Text('Düşük'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                selectedPriority = 1;
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: selectedPriority == 1 ? Colors.blue.withOpacity(0.2) : null,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: selectedPriority == 1 ? Colors.blue : Colors.transparent,
                                ),
                              ),
                            ),
                            child: const Text('Orta'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                selectedPriority = 2;
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: selectedPriority == 2 ? Colors.blue.withOpacity(0.2) : null,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: selectedPriority == 2 ? Colors.blue : Colors.transparent,
                                ),
                              ),
                            ),
                            child: const Text('Yüksek'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('İptal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    todoCubit.addTodo(textController.text, selectedPriority);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ekle'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 6,
        child: const Icon(Icons.add),
        onPressed: () => _showAddTodoBox(context),
      ),
      body: DragTarget<Todo>(
        onAcceptWithDetails: (todo) {
          todoCubit.updateTodoState(todo.data, widget.selectedIndex);
        },
        builder: (context, candidateData, rejectedData) {
          return BlocBuilder<TodoCubit, List<Todo>>(
            builder: (context, todos) {
              return todos.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_alt,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Henüz görev yok',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return Draggable<Todo>(
                        data: todo,
                        feedback: Material(
                          elevation: 8,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).colorScheme.primary,
                                  Theme.of(context).colorScheme.secondary,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Text(
                              todo.text,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.3,
                          child: _buildTodoCard(context, todo, todoCubit),
                        ),
                        child: _buildTodoCard(context, todo, todoCubit),
                      );
                    },
                  );
            },
          );
        },
      ),
    );
  }

  Widget _buildTodoCard(BuildContext context, Todo todo, TodoCubit todoCubit) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpandableTodoTile(todo: todo, todoCubit: todoCubit),
    );
  }
}