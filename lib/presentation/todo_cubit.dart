

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_int_id/safe_int_id.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/domain/repository/todo_repo.dart';
import 'package:uuid/uuid.dart';

class TodoCubit extends Cubit<List<Todo>> {
  final TodoRepo todoRepo;

  TodoCubit(this.todoRepo) : super([]) {
    loadTodos();
  }

  Future<void> loadTodos() async {
    //fetch list from repo
    final todoList = await todoRepo.getTodo();

    //emit the fetched list as the new state
    emit(todoList);
  }

  Future<void> addTodo(String text) async {
    //create a new todo with a unique id
    /*var uuid = const Uuid();
    String id = uuid.v4();
    */
    final id = safeIntId.getId();
    final newTodo = Todo(id: id, text: text); //DateTime.now().millisecondsSinceEpoch

    //save to db
    await todoRepo.addTodo(newTodo);
    //reload

    loadTodos();
  }

  Future<void> deleteTodo(Todo todo) async {
    //delete todo
    await todoRepo.deleteTodo(todo);
    //reload
    loadTodos();
  }

  Future<void> toogleCompletion(Todo todo) async {
    //toggle selected todo
    final updatedTodo = todo.toogleCompletion();
    //save toggled todo to db
    await todoRepo.updateTodo(updatedTodo);
    //reload
    loadTodos();
  }
}