import 'package:hive_flutter/hive_flutter.dart';
import '../models/todo.dart';

class LocalStorageService {
  static const String _boxName = 'todos';
  static Box<Todo>? _box;

  static Future<void> init() async {
    try {
      await Hive.initFlutter();
      Hive.registerAdapter(TodoAdapter());
      print('Initializing Hive');
      _box = await Hive.openBox<Todo>(_boxName);
    } catch (e) {
      print('Error initializing Hive: $e');
      // Create new box if error occurs
      _box = await Hive.openBox<Todo>(_boxName);
    }
  }

  static List<Todo> getTodos() {
    try {
      print('Getting todos');
      return _box?.values.toList() ?? [];
    } catch (e) {
      print('Error getting todos: $e');
      return [];
    }
  }

  static Future<void> saveTodos(List<Todo> todos) async {
    try {
      await _box?.clear();
      await _box?.addAll(todos);
    } catch (e) {
      print('Error saving todos: $e');
    }
  }

  static Future<void> clearBox() async {
    try {
      await _box?.clear();
    } catch (e) {
      print('Error clearing box: $e');
    }
  }

  static bool isInitialized() {
    return _box != null && _box!.isOpen;
  }
}