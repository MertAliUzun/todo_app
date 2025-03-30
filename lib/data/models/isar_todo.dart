import 'package:isar/isar.dart';
import '../../domain/models/todo.dart';

part 'isar_todo.g.dart'; //to generate isar todo object, run: dart run build_runner build

@collection
class TodoIsar {
  Id id = Isar.autoIncrement;
  late String text;
  late bool isCompleted;
  late String completionState;

  Todo toDomain() {
    return Todo(
      id: id,
      text: text,
      isCompleted: isCompleted,
      completionState: completionState,
    );
  }

  static TodoIsar fromDomain(Todo todo) {
    return TodoIsar()
      ..id = todo.id
      ..text = todo.text
      ..isCompleted = todo.isCompleted
      ..completionState = todo.completionState;
  }
}