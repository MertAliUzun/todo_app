import 'package:todo_app/domain/models/subtask.dart';
import 'package:todo_app/domain/models/todo.dart';

abstract class SubtaskRepo {
  // Get all subtasks for a todo
  Future<List<Subtask>> getSubtasks(Todo todo);
  
  // Add a new subtask to a todo
  Future<void> addSubtask(Todo todo, Subtask subtask);
  
  // Update a subtask
  Future<void> updateSubtask(Todo todo, Subtask subtask);
  
  // Delete a subtask
  Future<void> deleteSubtask(Todo todo, Subtask subtask);
  
  // Reorder subtasks
  Future<void> reorderSubtasks(Todo todo, List<Subtask> subtasks);
} 