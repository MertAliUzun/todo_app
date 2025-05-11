import 'package:isar/isar.dart';
import 'package:todo_app/data/models/isar_todo.dart';
import 'package:todo_app/domain/models/subtask.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/domain/repository/subtask_repo.dart';
import 'package:todo_app/data/models/isar_subtask.dart';

class IsarSubtaskRepo implements SubtaskRepo {
  final Isar db;
  
  IsarSubtaskRepo(this.db);

  @override
  Future<List<Subtask>> getSubtasks(Todo todo) async {
    final todoIsar = await db.todoIsars.get(todo.id);
    if (todoIsar == null || todoIsar.subtasks == null) {
      return [];
    }
    return todoIsar.subtasks!.map((subtaskIsar) => subtaskIsar.toDomain()).toList();
  }

  @override
  Future<void> addSubtask(Todo todo, Subtask subtask) async {
    return db.writeTxn(() async {
      final todoIsar = await db.todoIsars.get(todo.id);
      if (todoIsar != null) {
        todoIsar.subtasks ??= [];
        todoIsar.subtasks!.add(SubtaskIsar.fromDomain(subtask));
        await db.todoIsars.put(todoIsar);
      }
    });
  }

  @override
  Future<void> updateSubtask(Todo todo, Subtask subtask) async {
    return db.writeTxn(() async {
      final todoIsar = await db.todoIsars.get(todo.id);
      if (todoIsar != null && todoIsar.subtasks != null) {
        final index = todoIsar.subtasks!.indexWhere((s) => s.id == subtask.id);
        if (index != -1) {
          todoIsar.subtasks![index] = SubtaskIsar.fromDomain(subtask);
          await db.todoIsars.put(todoIsar);
        }
      }
    });
  }

  @override
  Future<void> deleteSubtask(Todo todo, Subtask subtask) async {
    return db.writeTxn(() async {
      final todoIsar = await db.todoIsars.get(todo.id);
      if (todoIsar != null && todoIsar.subtasks != null) {
        todoIsar.subtasks!.removeWhere((s) => s.id == subtask.id);
        await db.todoIsars.put(todoIsar);
      }
    });
  }

  @override
  Future<void> reorderSubtasks(Todo todo, List<Subtask> subtasks) async {
    return db.writeTxn(() async {
      final todoIsar = await db.todoIsars.get(todo.id);
      if (todoIsar != null) {
        todoIsar.subtasks = subtasks.map((subtask) => SubtaskIsar.fromDomain(subtask)).toList();
        await db.todoIsars.put(todoIsar);
      }
    });
  }
} 