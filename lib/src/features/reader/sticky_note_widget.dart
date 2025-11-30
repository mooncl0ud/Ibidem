import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sticky_note_repository.dart';

class StickyNoteWidget extends ConsumerWidget {
  final StickyNote note;
  final bool isEditable;
  final VoidCallback? onTap;
  final Function(double x, double y)? onDragEnd;

  const StickyNoteWidget({
    super.key,
    required this.note,
    this.isEditable = false,
    this.onTap,
    this.onDragEnd,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Color(int.parse(note.color));

    Widget noteIcon = GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: const Icon(Icons.edit_note, color: Colors.black87),
      ),
    );

    if (isEditable && onDragEnd != null) {
      return Draggable<StickyNote>(
        data: note,
        feedback: Material(color: Colors.transparent, child: noteIcon),
        childWhenDragging: Opacity(opacity: 0.5, child: noteIcon),
        onDragEnd: (details) {
          // Convert global position to relative position within the parent stack
          // This requires the parent Stack's RenderBox.
          // For simplicity, we'll rely on the parent to handle the coordinate conversion
          // or pass the global offset and let the parent handle it.
          // But here we are passing x, y.
          // Actually, Draggable doesn't give us relative coordinates easily without context.
          // We might need to handle drag logic in the parent Stack using Positioned and GestureDetector.
        },
        child: noteIcon,
      );
    }

    return noteIcon;
  }
}

class StickyNoteDialog extends StatefulWidget {
  final StickyNote? note;
  final bool isEditable;
  final Function(String content, String color) onSave;
  final VoidCallback? onDelete;

  const StickyNoteDialog({
    super.key,
    this.note,
    required this.isEditable,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<StickyNoteDialog> createState() => _StickyNoteDialogState();
}

class _StickyNoteDialogState extends State<StickyNoteDialog> {
  late TextEditingController _controller;
  String _selectedColor = '0xFFFFF59D'; // Default yellow

  final List<String> _colors = [
    '0xFFFFF59D', // Yellow
    '0xFF81D4FA', // Blue
    '0xFFA5D6A7', // Green
    '0xFFEF9A9A', // Red
    '0xFFCE93D8', // Purple
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.note?.content ?? '');
    if (widget.note != null) {
      _selectedColor = widget.note!.color;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(int.parse(_selectedColor)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.note?.authorName ?? '새 메모',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          if (widget.isEditable && widget.onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.black54),
              onPressed: widget.onDelete,
            ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            maxLines: 5,
            readOnly: !widget.isEditable,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '메모를 입력하세요...',
            ),
            style: const TextStyle(fontSize: 16),
          ),
          if (widget.isEditable) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _colors.map((color) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Color(int.parse(color)),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedColor == color
                            ? Colors.black
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('닫기', style: TextStyle(color: Colors.black87)),
        ),
        if (widget.isEditable)
          TextButton(
            onPressed: () {
              widget.onSave(_controller.text, _selectedColor);
              Navigator.pop(context);
            },
            child: const Text('저장', style: TextStyle(color: Colors.black87)),
          ),
      ],
    );
  }
}
