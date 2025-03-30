import 'package:todo_app/domain/models/todo.dart';

abstract class TodoRepo {
  //get list of Todo
  Future<List<Todo>> getTodo();
  //get list of Todo where completion state is todo
  Future<List<Todo>> getStateTodo();
  //get list of Todo where completion state is inProgress
  Future<List<Todo>> getStateInProgress();
  //get list of Todo where completion state is done
  Future<List<Todo>> getStateDone();
  //add a new Todo
  Future<void> addTodo(Todo newTodo);
  //update a Todo
  Future<void> updateTodo(Todo todo);
  //delete a Todo
  Future<void> deleteTodo(Todo todo);
}