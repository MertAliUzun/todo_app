import 'package:isar/isar.dart';
import '../../domain/models/subtask.dart';

part 'isar_subtask.g.dart'; //to generate isar subtask object, run: dart run build_runner build

@embedded
class SubtaskIsar {
  late int id;
  late String text;
  late bool isCompleted;
  late int orderNo;

  Subtask toDomain() {
    return Subtask(
      id: id,
      text: text,
      isCompleted: isCompleted,
      orderNo: orderNo,
    );
  }

  static SubtaskIsar fromDomain(Subtask subtask) {
    return SubtaskIsar()
      ..id = subtask.id
      ..text = subtask.text
      ..isCompleted = subtask.isCompleted
      ..orderNo = subtask.orderNo;
  }
} 