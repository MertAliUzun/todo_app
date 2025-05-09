import 'package:isar/isar.dart';
import '../../domain/models/todo.dart';

part 'isar_todo.g.dart'; //to generate isar todo object, run: dart run build_runner build

@collection
class TodoIsar {
  Id id = Isar.autoIncrement;
  late String text;
  late String completionState;
  late DateTime createdAt;
  late int priority;
  late List<String>? categories;

  Todo toDomain() {
    return Todo(
      id: id,
      text: text,
      completionState: completionState,
      createdAt: createdAt,
      priority: priority,
      categories: categories,
    );
  }

  static TodoIsar fromDomain(Todo todo) {
    return TodoIsar()
      ..id = todo.id
      ..text = todo.text
      ..completionState = todo.completionState
      ..createdAt = todo.createdAt
      ..priority = todo.priority
      ..categories = todo.categories;
  }
}