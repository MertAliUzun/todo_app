import 'package:todo_app/domain/models/todo.dart';

abstract class TodoRepo {
  //get list of Todo
  Future<List<Todo>> getTodo();
  //add a new Todo
  Future<void> addTodo(Todo newTodo);
  //update a Todo
  Future<void> updateTodo(Todo todo);
  //delete a Todo
  Future<void> deleteTodo(Todo todo);
}