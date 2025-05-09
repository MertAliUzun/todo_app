class Todo {
  final int id;
  final String text;
  final String completionState;
  final DateTime createdAt;
  final int priority;

  Todo({
    required this.id,
    required this.text,
    this.completionState = 'todo',
    required this.createdAt,
    required this.priority,
  });



  Todo stateToTodo () {
    return Todo(id: id, text: text, completionState: 'todo', createdAt: DateTime.now(), priority: priority);
  }

  Todo stateToInProgress () {
    return Todo(id: id, text: text, completionState: 'inProgress', createdAt: DateTime.now(), priority: priority);
  }

  Todo stateToDone () {
    return Todo(id: id, text: text, completionState: 'done', createdAt: DateTime.now(), priority: priority);
  }
}