import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_int_id/safe_int_id.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/domain/repository/todo_repo.dart';

enum SortBy { name, date, priority }

class TodoCubit extends Cubit<List<Todo>> {
  final TodoRepo todoRepo;
  int currentIndex = 0;
  SortBy _sortCriteria = SortBy.date; // Varsayılan sıralama ölçütü

  TodoCubit(this.todoRepo) : super([]) {
    loadTodos();
  }

  SortBy get sortCriteria => _sortCriteria;

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
    
    // Sıralama kriterine göre listeyi sırala
    sortTodos(todoList);
    
    emit(todoList);
  }

  // Görevleri belirtilen ölçüte göre sırala
  void sortTodos(List<Todo> todoList) {
    switch (_sortCriteria) {
      case SortBy.name:
        todoList.sort((a, b) => a.text.compareTo(b.text));
        break;
      case SortBy.date:
        todoList.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Yeniden eskiye
        break;
      case SortBy.priority:
        todoList.sort((a, b) => b.priority.compareTo(a.priority)); // Yüksekten düşüğe
        break;
    }
  }

  // Sıralama kriterini değiştir
  void changeSortCriteria(SortBy criteria) {
    _sortCriteria = criteria;
    loadTodos();
  }

  void changeIndex(int index) {
    currentIndex = index;
    loadTodos();
  }

  Future<void> addTodo(String _text, int _priority, {List<String>? categories}) async {
    //create a new todo with a unique id
    final id = safeIntId.getId();
    final newTodo = Todo(
      id: id, 
      text: _text, 
      createdAt: DateTime.now(), 
      priority: _priority,
      categories: categories,
    );
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