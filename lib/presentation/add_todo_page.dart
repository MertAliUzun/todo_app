import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/presentation/todo_cubit.dart';
import 'package:todo_app/presentation/services/ai_service.dart';
import 'package:todo_app/presentation/widgets/typing_effect_widget.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController _aiPromptController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _customCategoryController = TextEditingController();
  final TextEditingController _subtaskController = TextEditingController();
  int _selectedPriority = 1;
  List<String> _subtasks = [];
  Set<String> _selectedCategories = {};
  final List<String> _predefinedCategories = ['İş', 'Okul', 'Kişisel', 'Alışveriş', 'Sağlık'];
  bool _isAddingCustomCategory = false;

  // Typing effect state
  bool _isTypingTask = false;
  bool _isTypingSubtasks = false;
  int _typingSubtaskIndex = 0;
  List<String> _typingSubtasks = [];
  Todo? _pendingGeneratedTodo;

  // --- Animasyonlu yazma için ek state ---
  bool _isAnimating = false;

  @override
  void dispose() {
    _aiPromptController.dispose();
    _textController.dispose();
    _customCategoryController.dispose();
    _subtaskController.dispose();
    super.dispose();
  }

  void _startTypingWithGeneratedTodo(Todo generatedTodo) async {
    setState(() {
      _isTypingTask = true;
      _isTypingSubtasks = false;
      _typingSubtaskIndex = 0;
      _pendingGeneratedTodo = generatedTodo;
      _textController.text = '';
      _subtasks = [];
      _isAnimating = true;
    });
    await _typeTextToController(_textController, generatedTodo.text);
    setState(() {
      _isTypingTask = false;
    });
    if (generatedTodo.subtasks != null && generatedTodo.subtasks!.isNotEmpty) {
      setState(() {
        _isTypingSubtasks = true;
        _typingSubtasks = generatedTodo.subtasks!.map((s) => s.text).toList();
        _typingSubtaskIndex = 0;
      });
      for (int i = 0; i < _typingSubtasks.length; i++) {
        await _typeSubtaskAnimated(_typingSubtasks[i]);
      }
      setState(() {
        _isTypingSubtasks = false;
      });
    }
    _fillOtherFieldsFromGeneratedTodo(generatedTodo);
    setState(() {
      _pendingGeneratedTodo = null;
      _isAnimating = false;
    });
  }

  Future<void> _typeTextToController(TextEditingController controller, String text) async {
    controller.text = '';
    for (int i = 0; i < text.length; i++) {
      await Future.delayed(const Duration(milliseconds: 35));
      controller.text += text[i];
      controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
      if (!_isAnimating) break; // Kullanıcı müdahale ettiyse dur
      setState(() {});
    }
  }

  Future<void> _typeSubtaskAnimated(String subtaskText) async {
    String current = '';
    for (int i = 0; i < subtaskText.length; i++) {
      await Future.delayed(const Duration(milliseconds: 30));
      current += subtaskText[i];
      if (!_isAnimating) return;
      setState(() {
        if (_subtasks.length == _typingSubtaskIndex) {
          _subtasks.add(current);
        } else {
          _subtasks[_typingSubtaskIndex] = current;
        }
      });
    }
    setState(() {
      _typingSubtaskIndex++;
    });
  }

  void _fillOtherFieldsFromGeneratedTodo(Todo? generatedTodo) {
    if (generatedTodo == null) return;
    setState(() {
      _selectedPriority = generatedTodo.priority;
      _selectedCategories = generatedTodo.categories != null
          ? generatedTodo.categories!.toSet()
          : {};
    });
  }

  void _fillFormWithGeneratedTodo(Todo generatedTodo) {
    _startTypingWithGeneratedTodo(generatedTodo);
  }

  void _generateTodoWithAI() {
    if (_aiPromptController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen AI için bir açıklama yazın')),
      );
      return;
    }
    context.read<AiTodoBloc>().add(
      GenerateTodoEvent(prompt: _aiPromptController.text.trim()),
    );
  }

  void _onUserEdit() {
    // Kullanıcı elle düzenleme yaparsa animasyonları durdur
    if (_isAnimating) {
      setState(() {
        _isTypingTask = false;
        _isTypingSubtasks = false;
        _pendingGeneratedTodo = null;
        _isAnimating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final todoCubit = context.read<TodoCubit>();

    return Scaffold(
      appBar:  AppBar(
        title: const Text('Yeni Görev Ekle'), 
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.colorScheme.onPrimary,
        scrolledUnderElevation: 0,
      ),
      body: BlocListener<AiTodoBloc, AiTodoState>(
        listener: (context, state) {
          if (state is AiTodoSuccess) {
            _fillFormWithGeneratedTodo(state.todo);
          } else if (state is AiTodoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Hata: ${state.message}')),
            );
          }
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Görev adı
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Görev Adı',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            labelText: 'Görev',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (_) => _onUserEdit(),
                          enabled: !_isTypingTask && !_isTypingSubtasks && !_isAnimating,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Öncelik seçimi
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Öncelik',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () { setState(() => _selectedPriority = 0); _onUserEdit(); },
                              style: TextButton.styleFrom(
                                backgroundColor: _selectedPriority == 0 ? Colors.blue.withOpacity(0.2) : null,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color: _selectedPriority == 0 ? Colors.blue : Colors.transparent,
                                  ),
                                ),
                              ),
                              child: const Text('Düşük', style: TextStyle(color: Colors.green, fontSize: 18),),
                            ),
                            TextButton(
                              onPressed: () { setState(() => _selectedPriority = 1); _onUserEdit(); },
                              style: TextButton.styleFrom(
                                backgroundColor: _selectedPriority == 1 ? Colors.blue.withOpacity(0.2) : null,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color: _selectedPriority == 1 ? Colors.blue : Colors.transparent,
                                  ),
                                ),
                              ),
                              child: const Text('Orta', style: TextStyle(color: Colors.orange, fontSize: 18),),
                            ),
                            TextButton(
                              onPressed: () { setState(() => _selectedPriority = 2); _onUserEdit(); },
                              style: TextButton.styleFrom(
                                backgroundColor: _selectedPriority == 2 ? Colors.blue.withOpacity(0.2) : null,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color: _selectedPriority == 2 ? Colors.blue : Colors.transparent,
                                  ),
                                ),
                              ),
                              child: const Text('Yüksek', style: TextStyle(color: Colors.red, fontSize: 18),),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Alt görevler
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alt Görevler',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24
                          ),
                        ),
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
                                onChanged: (_) => _onUserEdit(),
                                enabled: !_isTypingTask && !_isTypingSubtasks && !_isAnimating,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: IconTheme(data: theme.iconTheme, child: Icon(Icons.add, size: 32,)),
                              onPressed: !_isTypingTask && !_isTypingSubtasks && !_isAnimating ? () {
                                if (_subtaskController.text.isNotEmpty) {
                                  setState(() {
                                    _subtasks.add(_subtaskController.text);
                                    _subtaskController.clear();
                                  });
                                  _onUserEdit();
                                }
                              } : null,
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
                                String subtask = entry.value;
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                  dense: true,
                                  title: Text(subtask),
                                  leading: IconTheme(data: theme.iconTheme, child: Icon(Icons.linear_scale_sharp, size: 20,)),
                                  trailing: !_isTypingTask && !_isTypingSubtasks && !_isAnimating ? IconButton(
                                    icon: const Icon(Icons.close, size: 20),
                                    onPressed: () {
                                      setState(() {
                                        _subtasks.removeAt(index);
                                      });
                                      _onUserEdit();
                                    },
                                  ) : null,
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Kategoriler
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kategoriler',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24
                          ),
                        ),
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
                                onSelected: !_isTypingTask && !_isTypingSubtasks && !_isAnimating ? (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedCategories.add(category);
                                    } else {
                                      _selectedCategories.remove(category);
                                    }
                                  });
                                  _onUserEdit();
                                } : null,
                                selectedColor: Colors.blue.withOpacity(0.2),
                                showCheckmark: false,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(
                                    color: isSelected ? Colors.blue : Colors.grey,
                                  ),
                                ),
                              );
                            }),
                            ..._selectedCategories
                                .where((cat) => !_predefinedCategories.contains(cat))
                                .map((category) {
                              return InputChip(
                                label: Text(category),
                                onDeleted: !_isTypingTask && !_isTypingSubtasks && !_isAnimating ? () {
                                  setState(() {
                                    _selectedCategories.remove(category);
                                  });
                                  _onUserEdit();
                                } : null,
                                backgroundColor: Colors.blue.withOpacity(0.2),
                                deleteIconColor: Colors.blue,
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                   SizedBox(height: 64),
                    // Ekle butonu
                    ElevatedButton(
                      onPressed: () {
                        if (_textController.text.trim().isEmpty && !_isTypingTask) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Lütfen görev ismi giriniz')),
                          );
                        } else if (_isTypingTask || _isTypingSubtasks || _isAnimating) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Lütfen AI ile doldurma işlemi tamamlansın')), 
                          );
                        } else {
                          todoCubit.addTodo(
                            _textController.text,
                            _selectedPriority,
                            categories: _selectedCategories.isNotEmpty 
                                ? _selectedCategories.toList() 
                                : null,
                            subtaskTexts: _subtasks.isNotEmpty
                                ? _subtasks
                                : null,
                          );
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Center(child: Text('TO-DO Ekle', style: theme.textTheme.bodySmall,)),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            // AI promptu en alta sabitle
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: theme.scaffoldBackgroundColor,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: BlocBuilder<AiTodoBloc, AiTodoState>(
                  builder: (context, state) {
                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _aiPromptController,
                            decoration: InputDecoration(
                              hintText: 'AI\'ya Ne Yapmak İstediğinizi Anlatın',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              fillColor: theme.colorScheme.surface,
                              suffixIcon: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: ElevatedButton.icon(
                                  onPressed: state is AiTodoLoading ? null : _generateTodoWithAI,
                                  icon: state is AiTodoLoading 
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        )
                                      : IconTheme(data:theme.iconTheme, child: const Icon(Icons.auto_awesome)),
                                  label: Text(
                                    '',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 