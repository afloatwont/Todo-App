import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final bool isCompleted;

  @HiveField(4)
  final DateTime date;

  Todo({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    required this.date,
  });

  // // Add factory constructor for safer deserialization
  // factory Todo.fromJson(Map<String, dynamic> json) {
  //   return Todo(
  //     id: json['id'] as String,
  //     title: json['title'] as String,
  //     description: json['description'] as String?,
  //     isCompleted: json['isCompleted'] as bool,
  //     date: DateTime.parse(json['date'] as String),
  //   );
  // }
}
