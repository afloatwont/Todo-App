// views/todo_action_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';

class TodoActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const TodoActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, color: color ?? Colors.black, size: 28),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: color ?? Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TodoActionSheet extends ConsumerStatefulWidget {
  final Todo todo;
  const TodoActionSheet({required this.todo, super.key});

  @override
  _TodoActionSheetState createState() => _TodoActionSheetState();
}

class _TodoActionSheetState extends ConsumerState<TodoActionSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          TodoActionButton(
            icon: Icons.edit,
            label: 'Edit Todo',
            color: Colors.white,
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.black87,
                builder: (context) => EditTodoBottomSheet(todo: widget.todo),
              );
            },
          ),
          Divider(height: 1, color: Colors.grey[800]),
          TodoActionButton(
            icon: widget.todo.isCompleted 
                ? Icons.check_circle
                : Icons.radio_button_unchecked,
            label: widget.todo.isCompleted 
                ? 'Mark as Incomplete'
                : 'Mark as Complete',
            color: widget.todo.isCompleted ? Colors.green : Colors.blue,
            onTap: () {
              final updatedTodo = Todo(
                id: widget.todo.id,
                title: widget.todo.title,
                description: widget.todo.description,
                isCompleted: !widget.todo.isCompleted,
                date: widget.todo.date,
              );
              ref.read(todoProvider.notifier).updateTodo(updatedTodo);
              Navigator.pop(context);
            },
          ),
          Divider(height: 1, color: Colors.grey[800]),
          TodoActionButton(
            icon: Icons.delete,
            label: 'Delete Todo',
            color: Colors.redAccent,
            onTap: () {
              ref.read(todoProvider.notifier).deleteTodo(widget.todo.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class EditTodoBottomSheet extends ConsumerStatefulWidget {
  final Todo todo;
  const EditTodoBottomSheet({required this.todo, super.key});

  @override
  _EditTodoBottomSheetState createState() => _EditTodoBottomSheetState();
}

class _EditTodoBottomSheetState extends ConsumerState<EditTodoBottomSheet> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.title);
    _descriptionController = TextEditingController(text: widget.todo.description);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        size.width * 0.05,
        16,
        size.width * 0.05,
        bottomInsets + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          TextField(
            controller: _titleController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Title',
              labelStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none,
            ),
          ),
          SizedBox(height: size.height * 0.02),
          TextField(
            controller: _descriptionController,
            style: const TextStyle(color: Colors.white),
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Description (Optional)',
              labelStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none,
            ),
          ),
          SizedBox(height: size.height * 0.04),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final updatedTodo = Todo(
                  id: widget.todo.id,
                  title: _titleController.text,
                  description: _descriptionController.text.isEmpty 
                      ? null 
                      : _descriptionController.text,
                  isCompleted: widget.todo.isCompleted,
                  date: widget.todo.date,
                );
                ref.read(todoProvider.notifier).updateTodo(updatedTodo);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: const StadiumBorder(),
                padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
              ),
              child: const Text('Update Todo'),
            ),
          ),
        ],
      ),
    );
  }
}