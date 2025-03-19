

import 'package:isar/isar.dart';
import 'package:todo_app/data/models/isar_todo.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/domain/repository/todo_repo.dart';

class IsarTodoRepo implements TodoRepo {
  final Isar db;
  
  IsarTodoRepo(this.db);

  @override
  Future<List<Todo>> getTodo() async {
    //fetch from db
    final todos = await db.todoIsars.where().findAll();

    //return list
    return todos.map((todoIsar) => todoIsar.toDomain()).toList();
  }

  @override
  Future<void> addTodo(Todo newTodo) async {
    //convert todo into isar todo
    final todoIsar = TodoIsar.fromDomain(newTodo);

    //store it in isar db
    return db.writeTxn(() => db.todoIsars.put(todoIsar));
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    //convert todo into isar todo
    final todoIsar = TodoIsar.fromDomain(todo);

    //store it in isar db
    return db.writeTxn(() => db.todoIsars.put(todoIsar));
  }

  @override
  Future<void> deleteTodo(Todo todo) async {
    await db.writeTxn(() => db.todoIsars.delete(todo.id));
  }
}