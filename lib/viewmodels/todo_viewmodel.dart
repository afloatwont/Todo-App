import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';
import '../services/local_storage_service.dart';

class TodoViewModel extends StateNotifier<List<Todo>> {
  TodoViewModel() : super(LocalStorageService.getTodos());

  void addTodo(Todo todo) {
    state = [...state, todo];
    LocalStorageService.saveTodos(state);
  }

  void updateTodo(Todo updatedTodo) {
    state = [
      for (final todo in state)
        if (todo.id == updatedTodo.id) updatedTodo else todo
    ];
    LocalStorageService.saveTodos(state);
  }

  void deleteTodo(String id) {
    state = state.where((todo) => todo.id != id).toList();
    LocalStorageService.saveTodos(state);
  }
}