class Todo {
  final int id;
  final String text;
  final String completionState;
  final DateTime createdAt;

  Todo({
    required this.id,
    required this.text,
    this.completionState = 'todo',
    required this.createdAt,
  });



  Todo stateToTodo () {
    return Todo(id: id, text: text, completionState: 'todo', createdAt: DateTime.now());
  }

  Todo stateToInProgress () {
    return Todo(id: id, text: text, completionState: 'inProgress', createdAt: DateTime.now());
  }

  Todo stateToDone () {
    return Todo(id: id, text: text, completionState: 'done', createdAt: DateTime.now());
  }
}