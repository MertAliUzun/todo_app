class Todo {
  final int id;
  final String text;
  final bool isCompleted;

  Todo({
    required this.id,
    required this.text,
    this.isCompleted = false, //This should be false when first created
  });


  Todo toogleCompletion () {
    return Todo(id: id, text: text, isCompleted: !isCompleted);
  }
}