import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/presentation/todo_cubit.dart';
import 'package:todo_app/presentation/widgets/todo_card_widget.dart';
import 'package:todo_app/presentation/add_todo_page.dart';

class TodoView extends StatefulWidget {
  final int selectedIndex;

  const TodoView({super.key, required this.selectedIndex});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  @override
  Widget build(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
        elevation: 6,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddTodoPage()),
          );
        },
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