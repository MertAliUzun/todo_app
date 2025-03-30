import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_int_id/safe_int_id.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/domain/repository/todo_repo.dart';

class TodoCubit extends Cubit<List<Todo>> {
  final TodoRepo todoRepo;
  int currentIndex = 0;

  TodoCubit(this.todoRepo) : super([]) {
    loadTodos();
  }

  Future<void> loadTodos() async {
    List<Todo> todoList;
    switch (currentIndex) {
      case 0:
        todoList = await todoRepo.getStateTodo();
        break;
      case 1:
        todoList = await todoRepo.getStateInProgress();
        break;
      case 2:
        todoList = await todoRepo.getStateDone();
        break;
      default:
        todoList = await todoRepo.getTodo();
    }
    emit(todoList);
  }

  void changeIndex(int index) {
    currentIndex = index;
    loadTodos();
  }

  Future<void> addTodo(String text) async {
    //create a new todo with a unique id
    final id = safeIntId.getId();
    final newTodo = Todo(id: id, text: text);  //DateTime.now().millisecondsSinceEpoch
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
    await todoRepo.updateTodo(updatedTodo);
    loadTodos();
  }

  Future<void> updateTodoState(Todo todo, int targetIndex) async {
    Todo updatedTodo;
    switch (targetIndex) {
      case 0:
        updatedTodo = todo.stateToTodo();
        break;
      case 1:
        updatedTodo = todo.stateToInProgress();
        break;
      case 2:
        updatedTodo = todo.stateToDone();
        break;
      default:
        return;
    }
    await todoRepo.updateTodo(updatedTodo);
    //reload
    loadTodos();
  }
}