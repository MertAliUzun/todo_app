import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/presentation/todo_cubit.dart';
import 'package:todo_app/presentation/widgets/todo_card_widget.dart';

class TodoView extends StatefulWidget {
  final int selectedIndex;

  const TodoView({super.key, required this.selectedIndex});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  void _showAddTodoBox(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();
    final textController = TextEditingController();
    final customCategoryController = TextEditingController();
    final theme = Theme.of(context);
    int selectedPriority = 1; // Default olarak Medium (1) seçili
    
    // Subtask listesi
    List<String> subtasks = [];
    final subtaskController = TextEditingController();
    
    // Önceden tanımlanmış kategoriler
    final List<String> predefinedCategories = ['İş', 'Okul', 'Kişisel', 'Alışveriş', 'Sağlık'];
    
    // Seçilen kategorileri tutmak için set
    Set<String> selectedCategories = {};

    Map<int, bool> expandedTodos = {};
    
    // Özel kategori ekleme modu
    bool isAddingCustomCategory = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Yeni Görev Ekle', style: theme.textTheme.bodyLarge,),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              backgroundColor: theme.colorScheme.background,
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Öncelik',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24
                        ),
                        ),
                        const SizedBox(height: 16,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedPriority = 0;
                                });
                              },
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
                              onPressed: () {
                                setState(() {
                                  selectedPriority = 1;
                                });
                              },
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
                              onPressed: () {
                                setState(() {
                                  selectedPriority = 2;
                                });
                              },
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
                    
                    // Alt görevler bölümü
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
                        
                        // Alt görev ekleme
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
                        
                        // Alt görev listesi
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
                        // Kategori chip'leri
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ...predefinedCategories.map((category) {
                              final isSelected = selectedCategories.contains(category);
                              return FilterChip(
                                label: Text(category, style: theme.textTheme.bodySmall,),
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
                            
                            // Seçilen özel kategoriler
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
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('İptal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (textController.text.trim().isEmpty) {
                        showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Uyarı'),
                            content: Text('Lütfen görev ismi giriniz'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Dialog'u kapatır
                                },
                                child: Text('Tamam'),
                              ),
                            ],
                          );
                        },
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
                  child: const Text('Ekle'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
        elevation: 6,
        child: const Icon(Icons.add),
        onPressed: () => _showAddTodoBox(context),
      ),
      body: DragTarget<Todo>(
        onAcceptWithDetails: (todo) {
          todoCubit.updateTodoState(todo.data, widget.selectedIndex);
        },
        builder: (context, candidateData, rejectedData) {
          return BlocBuilder<TodoCubit, List<Todo>>(
            builder: (context, todos) {
              // Geçerli sıralama kriterini göster
              final sortCriteria = context.watch<TodoCubit>().sortCriteria;
              final selectedCategory = context.watch<TodoCubit>().selectedCategory;
              final theme = Theme.of(context);
              
              return todos.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_alt,
                          size: 80,
                          color: theme.disabledColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Henüz görev yok',
                          style: TextStyle(
                            fontSize: 18,
                            color: theme.hintColor,
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      // Sıralama ve filtreleme bilgilerini gösteren banner
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        color: theme.dividerColor.withOpacity(0.05),
                        child: Row(
                          children: [
                            // Sıralama bilgisi
                            Icon(
                              sortCriteria == SortBy.name 
                                ? Icons.sort_by_alpha
                                : sortCriteria == SortBy.date
                                  ? Icons.calendar_today
                                  : Icons.priority_high,
                              size: 16,
                              color: theme.iconTheme.color,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Sıralama: ${sortCriteria == SortBy.name 
                                ? 'İsim' 
                                : sortCriteria == SortBy.date
                                  ? 'Tarih'
                                  : 'Öncelik'}',
                              style: TextStyle(
                                color: theme.textTheme.bodySmall?.color,
                                fontSize: 14,
                              ),
                            ),
                            
                            // Ayırıcı
                            if (selectedCategory != 'None') ...[
                              const SizedBox(width: 16),
                              Container(
                                height: 16,
                                width: 1,
                                color: theme.dividerColor,
                              ),
                              const SizedBox(width: 16),
                              
                              // Kategori filtresi bilgisi
                              Icon(
                                Icons.filter_list,
                                size: 16,
                                color: theme.iconTheme.color,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Filtre: $selectedCategory',
                                style: TextStyle(
                                  color: theme.textTheme.bodySmall?.color,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: todos.length,
                          itemBuilder: (context, index) {
                            final todo = todos[index];
                            
                            // Genişletilmiş veya daraltılmış durumu kontrol et
                            final isExpanded = todoCubit.isTodoExpanded(todo.id);
                            
                            // Eğer isExpanded true ise Draggable kullanma, direkt _buildTodoCard döndür
                            if (isExpanded) {
                              return _buildTodoCard(context, todo, todoCubit);
                            }
                            
                            // isExpanded false ise Draggable kullan
                            return Draggable<Todo>(
                              data: todo,
                              feedback: Material(
                                elevation: 8,
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        todo.getPriorityColor(),
                                        todo.getPriorityColor().withOpacity(0.7),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.shadowColor.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    todo.text,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              childWhenDragging: Opacity(
                                opacity: 0.3,
                                child: _buildTodoCard(context, todo, todoCubit),
                              ),
                              child: _buildTodoCard(context, todo, todoCubit),
                            );
                          },
                        ),
                      ),
                    ],
                  );
            },
          );
        },
      ),
    );
  }

  Widget _buildTodoCard(BuildContext context, Todo todo, TodoCubit todoCubit) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpandableTodoTile(
        todo: todo, 
        todoCubit: todoCubit,
      ),
    );
  }
}