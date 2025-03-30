class Todo {
  final int id;
  final String text;
  final bool isCompleted;
  final String completionState;

  Todo({
    required this.id,
    required this.text,
    this.isCompleted = false, //This should be false when first created
    this.completionState = 'todo'
  });


  Todo toogleCompletion () {
    return Todo(id: id, text: text, isCompleted: !isCompleted);
  }

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