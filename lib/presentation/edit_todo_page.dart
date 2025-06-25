import 'package:flutter/material.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/domain/models/subtask.dart';
import 'package:todo_app/presentation/todo_cubit.dart';

class EditTodoPage extends StatefulWidget {
  final Todo todo;
  final TodoCubit todoCubit;

  const EditTodoPage({Key? key, required this.todo, required this.todoCubit}) : super(key: key);

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  late TextEditingController _textController;
  late int _selectedPriority;
  late Set<String> _selectedCategories;
  late List<Subtask> _subtasks;
  final TextEditingController _subtaskController = TextEditingController();
  final List<String> _predefinedCategories = ['İş', 'Okul', 'Kişisel', 'Alışveriş', 'Sağlık'];
  List<String> _newSubtasks = [];

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.todo.text);
    _selectedPriority = widget.todo.priority;
    _selectedCategories = widget.todo.categories != null ? widget.todo.categories!.toSet() : {};
    _subtasks = widget.todo.subtasks != null ? List<Subtask>.from(widget.todo.subtasks!) : [];
  }

  @override
  void dispose() {
    _textController.dispose();
    _subtaskController.dispose();
    super.dispose();
  }

  void _addSubtask() {
    if (_subtaskController.text.isNotEmpty) {
      setState(() {
        _newSubtasks.add(_subtaskController.text);
        _subtaskController.clear();
      });
    }
  }

  void _deleteSubtask(int index, {bool isNew = false}) {
    setState(() {
      if (isNew) {
        _newSubtasks.removeAt(index);
      } else {
        _subtasks.removeAt(index);
      }
    });
  }

  void _onUpdate() async {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen görev ismi giriniz')),
      );
      return;
    }
    final updatedTodo = widget.todo.copyWith(
      text: _textController.text,
      priority: _selectedPriority,
      categories: _selectedCategories.isNotEmpty ? _selectedCategories.toList() : null,
      subtasks: _subtasks,
    );
    await widget.todoCubit.editTodo(updatedTodo, newSubtaskTexts: _newSubtasks);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Görev Düzenle'),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.colorScheme.onPrimary,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Görev adı
              Text(
                'Görev Adı',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Görev',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              // Öncelik seçimi
              Text('Öncelik', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => setState(() => _selectedPriority = 0),
                    style: TextButton.styleFrom(
                      backgroundColor: _selectedPriority == 0 ? Colors.blue.withOpacity(0.2) : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: _selectedPriority == 0 ? Colors.blue : Colors.transparent),
                      ),
                    ),
                    child: const Text('Düşük', style: TextStyle(color: Colors.green, fontSize: 18)),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _selectedPriority = 1),
                    style: TextButton.styleFrom(
                      backgroundColor: _selectedPriority == 1 ? Colors.blue.withOpacity(0.2) : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: _selectedPriority == 1 ? Colors.blue : Colors.transparent),
                      ),
                    ),
                    child: const Text('Orta', style: TextStyle(color: Colors.orange, fontSize: 18)),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _selectedPriority = 2),
                    style: TextButton.styleFrom(
                      backgroundColor: _selectedPriority == 2 ? Colors.blue.withOpacity(0.2) : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: _selectedPriority == 2 ? Colors.blue : Colors.transparent),
                      ),
                    ),
                    child: const Text('Yüksek', style: TextStyle(color: Colors.red, fontSize: 18)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Alt görevler
              Text('Alt Görevler', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _subtaskController,
                      decoration: const InputDecoration(
                        labelText: 'Alt görev ekle',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.add, size: 32),
                    onPressed: _addSubtask,
                  ),
                ],
              ),
              if (_subtasks.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _subtasks.asMap().entries.map((entry) {
                      int index = entry.key;
                      String subtask = entry.value.text;
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        dense: true,
                        title: Text(subtask),
                        leading: Icon(Icons.linear_scale_sharp, size: 20),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: () => _deleteSubtask(index),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              if (_newSubtasks.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _newSubtasks.asMap().entries.map((entry) {
                      int index = entry.key;
                      String subtask = entry.value;
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        dense: true,
                        title: Text(subtask),
                        leading: Icon(Icons.fiber_new, size: 20, color: Colors.blue),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: () => _deleteSubtask(index, isNew: true),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              const SizedBox(height: 24),
              // Kategoriler
              Text('Kategoriler', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ..._predefinedCategories.map((category) {
                    final isSelected = _selectedCategories.contains(category);
                    return FilterChip(
                      label: Text(category, style: theme.textTheme.titleMedium),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedCategories.add(category);
                          } else {
                            _selectedCategories.remove(category);
                          }
                        });
                      },
                      selectedColor: Colors.blue.withOpacity(0.2),
                      showCheckmark: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: isSelected ? Colors.blue : Colors.grey),
                      ),
                    );
                  }),
                  ..._selectedCategories
                      .where((cat) => !_predefinedCategories.contains(cat))
                      .map((category) {
                    return InputChip(
                      label: Text(category),
                      onDeleted: () {
                        setState(() {
                          _selectedCategories.remove(category);
                        });
                      },
                      backgroundColor: Colors.blue.withOpacity(0.2),
                      deleteIconColor: Colors.blue,
                    );
                  }),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _onUpdate,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Center(child: Text('Güncelle', style: theme.textTheme.titleMedium)),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 