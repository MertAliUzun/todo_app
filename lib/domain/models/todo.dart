import 'package:flutter/material.dart';

class Todo {
  final int id;
  final String text;
  final String completionState;
  final DateTime createdAt;
  final int priority;
  final List<String>? categories;

  Todo({
    required this.id,
    required this.text,
    this.completionState = 'todo',
    required this.createdAt,
    required this.priority,
    this.categories,
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

// Todo model'i için extension metotlar
extension TodoExtensions on Todo {
  // Önceliğe göre renk döndüren metot
  Color getPriorityColor() {
    switch (priority) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
  
  // Öncelik metnini döndüren metot
  String getPriorityText() {
    switch (priority) {
      case 0:
        return 'Düşük';
      case 1:
        return 'Orta';
      case 2:
        return 'Yüksek';
      default:
        return 'Orta';
    }
  }
  
  // Öncelik ikonunu döndüren metot
  Icon getPriorityIcon() {
    switch (priority) {
      case 0:
        return Icon(Icons.arrow_downward, color: getPriorityColor(), size: 16);
      case 1:
        return Icon(Icons.arrow_forward, color: getPriorityColor(), size: 16);
      case 2:
        return Icon(Icons.arrow_upward, color: getPriorityColor(), size: 16);
      default:
        return Icon(Icons.arrow_forward, color: getPriorityColor(), size: 16);
    }
  }
}