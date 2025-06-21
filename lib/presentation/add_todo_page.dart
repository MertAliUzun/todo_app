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
  bool _isManualMode = false;
  bool _isGenerating = false;

  @override
  void dispose() {
    _aiPromptController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _isManualMode = !_isManualMode;
    });
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Görev Ekle'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: BlocListener<AiTodoBloc, AiTodoState>(
        listener: (context, state) {
          if (state is AiTodoSuccess) {
            _showGeneratedTodoDialog(state.todo);
          } else if (state is AiTodoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Hata: ${state.message}')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Mod seçimi
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        _isManualMode ? Icons.edit : Icons.auto_awesome,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _isManualMode ? 'Manuel Ekleme' : 'AI ile Oluştur',
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      Switch(
                        value: _isManualMode,
                        onChanged: (value) => _toggleMode(),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              if (!_isManualMode) ...[
                // AI modu
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'AI\'ya Ne Yapmak İstediğinizi Anlatın',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: TextField(
                          controller: _aiPromptController,
                          maxLines: null,
                          expands: true,
                          decoration: InputDecoration(
                            hintText: 'Örnek: "Yarın sabah 8\'de kalkıp spor yapmak istiyorum" veya "Bu hafta sonu ev temizliği yapacağım"',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: theme.colorScheme.surface,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      BlocBuilder<AiTodoBloc, AiTodoState>(
                        builder: (context, state) {
                          return ElevatedButton.icon(
                            onPressed: state is AiTodoLoading ? null : _generateTodoWithAI,
                            icon: state is AiTodoLoading 
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.auto_awesome),
                            label: Text(
                              state is AiTodoLoading ? 'Oluşturuluyor...' : 'AI ile Oluştur',
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Manuel mod
                Expanded(
                  child: _ManualTodoForm(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showGeneratedTodoDialog(Todo generatedTodo) {
    final todoCubit = context.read<TodoCubit>();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI Tarafından Oluşturulan Görev'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Görev: '),
                Expanded(
                  child: TypingEffectWidget(
                    text: generatedTodo.text,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Öncelik: '),
                TypingEffectWidget(
                  text: generatedTodo.getPriorityText(),
                  style: TextStyle(
                    color: generatedTodo.getPriorityColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (generatedTodo.categories != null && generatedTodo.categories!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Kategoriler: '),
                  Expanded(
                    child: TypingEffectWidget(
                      text: generatedTodo.categories!.join(', '),
                    ),
                  ),
                ],
              ),
            ],
            if (generatedTodo.subtasks != null && generatedTodo.subtasks!.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text('Alt Görevler:'),
              ...generatedTodo.subtasks!.map((subtask) => 
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 4),
                  child: Row(
                    children: [
                      const Text('• '),
                      Expanded(
                        child: TypingEffectWidget(
                          text: subtask.text,
                          duration: const Duration(milliseconds: 30),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              todoCubit.addTodo(
                generatedTodo.text,
                generatedTodo.priority,
                categories: generatedTodo.categories,
                subtaskTexts: generatedTodo.subtasks?.map((s) => s.text).toList(),
              );
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }
}

class _ManualTodoForm extends StatefulWidget {
  @override
  State<_ManualTodoForm> createState() => _ManualTodoFormState();
}

class _ManualTodoFormState extends State<_ManualTodoForm> {
  final textController = TextEditingController();
  final customCategoryController = TextEditingController();
  int selectedPriority = 1;
  List<String> subtasks = [];
  final subtaskController = TextEditingController();
  final List<String> predefinedCategories = ['İş', 'Okul', 'Kişisel', 'Alışveriş', 'Sağlık'];
  Set<String> selectedCategories = {};
  bool isAddingCustomCategory = false;

  @override
  void dispose() {
    textController.dispose();
    customCategoryController.dispose();
    subtaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final todoCubit = context.read<TodoCubit>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: textController,
            decoration: const InputDecoration(
              labelText: 'Görev',
              border: OutlineInputBorder(),
            ),
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
                    onPressed: () => setState(() => selectedPriority = 0),
                    style: TextButton.styleFrom(
                      backgroundColor: selectedPriority == 0 ? Colors.blue.withOpacity(0.2) : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: selectedPriority == 0 ? Colors.blue : Colors.transparent,
                        ),
                      ),
                    ),
                    child: const Text('Düşük'),
                  ),
                  TextButton(
                    onPressed: () => setState(() => selectedPriority = 1),
                    style: TextButton.styleFrom(
                      backgroundColor: selectedPriority == 1 ? Colors.blue.withOpacity(0.2) : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: selectedPriority == 1 ? Colors.blue : Colors.transparent,
                        ),
                      ),
                    ),
                    child: const Text('Orta'),
                  ),
                  TextButton(
                    onPressed: () => setState(() => selectedPriority = 2),
                    style: TextButton.styleFrom(
                      backgroundColor: selectedPriority == 2 ? Colors.blue.withOpacity(0.2) : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: selectedPriority == 2 ? Colors.blue : Colors.transparent,
                        ),
                      ),
                    ),
                    child: const Text('Yüksek'),
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
                      controller: subtaskController,
                      decoration: const InputDecoration(
                        labelText: 'Alt görev ekle',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (subtaskController.text.isNotEmpty) {
                        setState(() {
                          subtasks.add(subtaskController.text);
                          subtaskController.clear();
                        });
                      }
                    },
                  ),
                ],
              ),
              
              if (subtasks.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: subtasks.asMap().entries.map((entry) {
                      int index = entry.key;
                      String subtask = entry.value;
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        dense: true,
                        title: Text(subtask),
                        leading: const Icon(Icons.check_box_outline_blank, size: 20),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: () {
                            setState(() {
                              subtasks.removeAt(index);
                            });
                          },
                        ),
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
                  ...predefinedCategories.map((category) {
                    final isSelected = selectedCategories.contains(category);
                    return FilterChip(
                      label: Text(category, style: theme.textTheme.bodySmall),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedCategories.add(category);
                          } else {
                            selectedCategories.remove(category);
                          }
                        });
                      },
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
                  
                  ...selectedCategories
                      .where((cat) => !predefinedCategories.contains(cat))
                      .map((category) {
                    return InputChip(
                      label: Text(category),
                      onDeleted: () {
                        setState(() {
                          selectedCategories.remove(category);
                        });
                      },
                      backgroundColor: Colors.blue.withOpacity(0.2),
                      deleteIconColor: Colors.blue,
                    );
                  }),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Ekle butonu
          ElevatedButton(
            onPressed: () {
              if (textController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lütfen görev ismi giriniz')),
                );
              } else {
                todoCubit.addTodo(
                  textController.text,
                  selectedPriority,
                  categories: selectedCategories.isNotEmpty 
                      ? selectedCategories.toList() 
                      : null,
                  subtaskTexts: subtasks.isNotEmpty
                      ? subtasks
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
            child: const Text('Görevi Ekle'),
          ),
        ],
      ),
    );
  }
} 