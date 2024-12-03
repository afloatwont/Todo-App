import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';
import 'package:uuid/uuid.dart';

class TodoBottomSheet extends ConsumerStatefulWidget {
  const TodoBottomSheet({super.key});

  @override
  _TodoBottomSheetState createState() => _TodoBottomSheetState();
}

class _TodoBottomSheetState extends ConsumerState<TodoBottomSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        size.width * 0.05,
        padding.top + 16,
        size.width * 0.05,
        bottomInsets + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: InputBorder.none,
            ),
          ),
          SizedBox(height: size.height * 0.02),
          TextField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Description (Optional)',
              border: InputBorder.none,
            ),
          ),
          SizedBox(height: size.height * 0.02),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final title = _titleController.text;
                if (title.isNotEmpty) {
                  final todo = Todo(
                    id: const Uuid().v4(),
                    title: title,
                    description: _descriptionController.text.isEmpty
                        ? null
                        : _descriptionController.text,
                    date: _selectedDate,
                  );
                  ref.read(todoProvider.notifier).addTodo(todo);
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
              ),
              child: const Text('Add ToDo'),
            ),
          ),
        ],
      ),
    );
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }
}
