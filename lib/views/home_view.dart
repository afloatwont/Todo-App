import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_item.dart';
import 'todo_bottom_sheet.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final todos = ref.watch(todoProvider);

    final groupedTodos = <DateTime, List<Todo>>{};
    for (var todo in todos) {
      final date = DateTime(todo.date.year, todo.date.month, todo.date.day);
      groupedTodos.putIfAbsent(date, () => []).add(todo);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo App'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
        itemCount: groupedTodos.length,
        itemBuilder: (context, index) {
          final entry = groupedTodos.entries.elementAt(index);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04,
                  vertical: size.height * 0.01,
                ),
                child: Text(
                  '${entry.key.toLocal()}'.split(' ')[0],
                  style: TextStyle(
                    fontSize: size.width * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...entry.value.map((todo) => TodoItem(todo: todo)).toList(),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => const TodoBottomSheet(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}