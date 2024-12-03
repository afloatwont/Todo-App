import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';
import '../views/todo_action_sheet.dart';

class TodoItem extends ConsumerWidget {
  final Todo todo;

  const TodoItem({required this.todo, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.01,
      ),
      child: ListTile(
        splashColor: Colors.transparent,
        title: Text(
          todo.title,
          style: TextStyle(
            fontSize: size.width * 0.05,
            fontWeight: FontWeight.w500,
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: todo.description != null ? Text(todo.description!) : null,
        trailing: Checkbox(
          value: todo.isCompleted,
          onChanged: (value) {
            final updatedTodo = Todo(
              id: todo.id,
              title: todo.title,
              description: todo.description,
              isCompleted: value ?? false,
              date: todo.date,
            );
            ref.read(todoProvider.notifier).updateTodo(updatedTodo);
          },
        ),
        onLongPress: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => TodoActionSheet(todo: todo),
          );
        },
        onTap: () {
          final updatedTodo = Todo(
            id: todo.id,
            title: todo.title,
            description: todo.description,
            isCompleted: !todo.isCompleted,
            date: todo.date,
          );
          ref.read(todoProvider.notifier).updateTodo(updatedTodo);
        },
      ),
    );
  }
}
