import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/domain/models/subtask.dart';
import 'package:todo_app/presentation/todo_cubit.dart';

class ExpandableTodoTile extends StatelessWidget {
  final Todo todo;
  final TodoCubit todoCubit;

  const ExpandableTodoTile({
    Key? key,
    required this.todo,
    required this.todoCubit,
  }) : super(key: key);

  String _formatDate(DateTime dateTime) {
    // Türkçe ay adları
    const Map<int, String> motnhs = {
      1: 'Jan',
      2: 'Feb',
      3: 'Mar',
      4: 'Apr',
      5: 'May',
      6: 'Jun',
      7: 'Jul',
      8: 'Agu',
      9: 'Sep',
      10: 'Oct',
      11: 'Nov',
      12: 'Dec',
    };
    
    return '${dateTime.day.toString().padLeft(2, '0')} ${motnhs[dateTime.month]} ${dateTime.year}';
  }

  // Silme işlemi için onay diyaloğu göster
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Görev Silme'),
        content: Text(
          'Bu görevi silmek istediğinize emin misiniz?\n\n"${todo.text}"',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              todoCubit.deleteTodo(todo);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Cubit'ten todo'nun genişletilme durumunu al
    final bool isExpanded = todoCubit.isTodoExpanded(todo.id);
    
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        // Genişletme durumunu Cubit üzerinden değiştir
        todoCubit.toggleTodoExpansion(todo.id);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              child: Icon(
                Icons.drag_indicator,
                color: Colors.grey[500],
                size: 35,
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDate(todo.createdAt),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: todo.getPriorityColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: todo.getPriorityColor()),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          todo.getPriorityIcon(),
                          const SizedBox(width: 4),
                          Text(
                            todo.getPriorityText(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: todo.getPriorityColor(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        todo.text,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                        ),
                        maxLines: isExpanded ? null : 1,
                        overflow: isExpanded ? null : TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (todo.categories != null && todo.categories!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: todo.categories!.map((category) {
                        return Chip(
                          label: Text(
                            category,
                            style: const TextStyle(
                              fontSize: 10,
                            ),
                          ),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          backgroundColor: Colors.grey[200],
                          padding: EdgeInsets.zero,
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => _showDeleteConfirmationDialog(context),
              tooltip: 'Sil',
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 46, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (todo.subtasks != null && todo.subtasks!.isNotEmpty) ...[
                    Row(
                      children: [
                        Text(
                          'Alt Görevler:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Sıralamak için basılı tutup sürükleyin',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    // Alt görevleri sıralaması için ReorderableListView kullanıyoruz
                    _buildReorderableSubtaskList(),
                    SizedBox(height: 16),
                  ],
                  
                  Text(
                    'Detaylar:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Kategoriler: ${todo.categories != null ? todo.categories!.join(", ") : "Yok"}',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(right: 16, bottom: 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Daraltmak için tıklayın',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildReorderableSubtaskList() {
    if (todo.subtasks == null || todo.subtasks!.isEmpty) {
      return SizedBox.shrink();
    }
    
    // Subtask'leri orderNo'ya göre sırala
    final sortedSubtasks = List<Subtask>.from(todo.subtasks!);
    sortedSubtasks.sort((a, b) => a.orderNo.compareTo(b.orderNo));
    
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: sortedSubtasks.length,
      onReorder: (oldIndex, newIndex) {
        // ReorderableListView yeni index değerini farklı hesaplıyor, düzeltme:
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        
        todoCubit.reorderSubtasks(todo, oldIndex, newIndex);
      },
      itemBuilder: (context, index) {
        final subtask = sortedSubtasks[index];
        return _buildSubtaskItem(subtask, index, context);
      },
      proxyDecorator: (Widget child, int index, Animation<double> animation) {
        // Sürükleme sırasında görünümü ayarla
        return Material(
          elevation: 4,
          color: Colors.transparent,
          shadowColor: Colors.grey.shade200,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return child!;
            },
            child: child,
          ),
        );
      }
    );
  }
  
  Widget _buildSubtaskItem(Subtask subtask, int index, BuildContext context) {
    return Container(
      key: ValueKey('subtask-${subtask.id}'),
      child: GestureDetector(
        onTap: () {
          // Alt göreve tıklanınca tamamlanma durumunu değiştir ve yayılımı engelle
          todoCubit.toggleSubtaskCompletion(todo, subtask);
        },
        behavior: HitTestBehavior.opaque, // Tüm alan tıklanabilir olsun
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  // Sadece ikona tıklanınca da tamamlanma durumunu değiştir
                  todoCubit.toggleSubtaskCompletion(todo, subtask);
                },
                child: Icon(
                  subtask.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
                  size: 20,
                  color: subtask.isCompleted ? Colors.green : Colors.grey,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  subtask.text,
                  style: TextStyle(
                    fontSize: 18,
                    decoration: subtask.isCompleted ? TextDecoration.lineThrough : null,
                    color: subtask.isCompleted ? Colors.grey : Colors.black,
                  ),
                ),
              ),
              Icon(
                Icons.drag_handle,
                size: 20,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 