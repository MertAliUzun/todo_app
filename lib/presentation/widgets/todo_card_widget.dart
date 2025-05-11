import 'package:flutter/material.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/domain/models/subtask.dart';
import 'package:todo_app/presentation/todo_cubit.dart';

class ExpandableTodoTile extends StatefulWidget {
  final Todo todo;
  final TodoCubit todoCubit;
  //final Function(bool isExpanded)? onExpansionChanged;

  const ExpandableTodoTile({
    Key? key,
    required this.todo,
    required this.todoCubit,
    //this.onExpansionChanged,
  }) : super(key: key);

  @override
  State<ExpandableTodoTile> createState() => _ExpandableTodoTileState();
}

class _ExpandableTodoTileState extends State<ExpandableTodoTile> {
  bool _isExpanded = false;

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
  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Görev Silme'),
        content: Text(
          'Bu görevi silmek istediğinize emin misiniz?\n\n"${widget.todo.text}"',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.todoCubit.deleteTodo(widget.todo);
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
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        
        setState(() {
          _isExpanded = !_isExpanded;
        });
         //widget.onExpansionChanged?.call(!_isExpanded);
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
                      _formatDate(widget.todo.createdAt),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: widget.todo.getPriorityColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: widget.todo.getPriorityColor()),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          widget.todo.getPriorityIcon(),
                          const SizedBox(width: 4),
                          Text(
                            widget.todo.getPriorityText(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: widget.todo.getPriorityColor(),
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
                        widget.todo.text,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                        ),
                        maxLines: _isExpanded ? null : 1,
                        overflow: _isExpanded ? null : TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.todo.categories != null && widget.todo.categories!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: widget.todo.categories!.map((category) {
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
              onPressed: _showDeleteConfirmationDialog,
              tooltip: 'Sil',
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 46, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.todo.subtasks != null && widget.todo.subtasks!.isNotEmpty) ...[
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
                    'Kategoriler: ${widget.todo.categories != null ? widget.todo.categories!.join(", ") : "Yok"}',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          if (_isExpanded)
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
    if (widget.todo.subtasks == null || widget.todo.subtasks!.isEmpty) {
      return SizedBox.shrink();
    }
    
    // Subtask'leri orderNo'ya göre sırala
    final sortedSubtasks = List<Subtask>.from(widget.todo.subtasks!);
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
        
        widget.todoCubit.reorderSubtasks(widget.todo, oldIndex, newIndex);
      },
      itemBuilder: (context, index) {
        final subtask = sortedSubtasks[index];
        return _buildSubtaskItem(subtask, index);
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
  
  Widget _buildSubtaskItem(Subtask subtask, int index) {
    return Container(
      key: ValueKey('subtask-${subtask.id}'),
      child: GestureDetector(
        onTap: () {
          // Alt göreve tıklanınca tamamlanma durumunu değiştir ve yayılımı engelle
          widget.todoCubit.toggleSubtaskCompletion(widget.todo, subtask);
        },
        behavior: HitTestBehavior.opaque, // Tüm alan tıklanabilir olsun
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  // Sadece ikona tıklanınca da tamamlanma durumunu değiştir
                  widget.todoCubit.toggleSubtaskCompletion(widget.todo, subtask);
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