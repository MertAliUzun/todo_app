class Todo {
  final int id;
  final String text;
  final String completionState;

  Todo({
    required this.id,
    required this.text,
    this.completionState = 'todo'
  });



  Todo stateToTodo () {
    return Todo(id: id, text: text, completionState: 'todo');
  }

  Todo stateToInProgress () {
    return Todo(id: id, text: text, completionState: 'inProgress');
  }

  Todo stateToDone () {
    return Todo(id: id, text: text, completionState: 'done');
  }
}