import 'package:flutter/material.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/presentation/todo_cubit.dart';

class ExpandableTodoTile extends StatefulWidget {
  final Todo todo;
  final TodoCubit todoCubit;

  const ExpandableTodoTile({
    Key? key,
    required this.todo,
    required this.todoCubit,
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

  Color _getPriorityColor() {
    switch (widget.todo.priority) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _getPriorityText() {
    switch (widget.todo.priority) {
      case 0:
        return 'Düşük';
      case 1:
        return 'Orta';
      case 2:
        return 'Yüksek';
      default:
        return 'Orta';
    }
  }

  Icon _getPriorityIcon() {
    switch (widget.todo.priority) {
      case 0:
        return Icon(Icons.arrow_downward, color: _getPriorityColor(), size: 16);
      case 1:
        return Icon(Icons.arrow_forward, color: _getPriorityColor(), size: 16);
      case 2:
        return Icon(Icons.arrow_upward, color: _getPriorityColor(), size: 16);
      default:
        return Icon(Icons.arrow_forward, color: _getPriorityColor(), size: 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
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
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.todo.text,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                      ),
                      maxLines: _isExpanded ? null : 1,
                      overflow: _isExpanded ? null : TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getPriorityColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _getPriorityColor()),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _getPriorityIcon(),
                              const SizedBox(width: 4),
                              Text(
                                _getPriorityText(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: _getPriorityColor(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => widget.todoCubit.deleteTodo(widget.todo),
              tooltip: 'Sil',
            ),

          ),
          //Burada todo.text yerine subtaskleri göster
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 46, right: 16, bottom: 16),
              child: Text(
                'test',
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.4,
                ),
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
} 