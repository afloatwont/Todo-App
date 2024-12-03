import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';
import '../viewmodels/todo_viewmodel.dart';

final todoProvider = StateNotifierProvider<TodoViewModel, List<Todo>>((ref) {
  return TodoViewModel();
});