


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/presentation/todo_cubit.dart';

class TodoView extends StatelessWidget {
  const TodoView({super.key});




  void _showAddTodoBox(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();
    final textController = TextEditingController();

    showDialog(context: context, builder: (context) => AlertDialog(
      content: TextField(controller: textController,),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        TextButton(onPressed: () {
          todoCubit.addTodo(textController.text);
          Navigator.of(context).pop();
        }, 
        child: const Text('Add'))
      ],
    )
    );
  }

  @override
  Widget build(BuildContext context) {

    final todoCubit = context.read<TodoCubit>();


    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddTodoBox(context),

      ),

      body: BlocBuilder<TodoCubit,List<Todo>>(builder: (context, todos) {
        return ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            //get individual todos from list
            final todo = todos[index];

            return ListTile(
              title: Text(todo.text),
              leading: Checkbox(
                value: todo.isCompleted,
                onChanged: (value) => todoCubit.toogleCompletion(todo),
                ),
              trailing: IconButton(
                icon: Icon(Icons.cancel), 
                onPressed: () => todoCubit.deleteTodo(todo),),
            );
          }
          );
      }
      ),
    );
  }
}