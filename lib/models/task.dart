class GravityTask {
  final String id;
  final String title;
  bool isDone;
  final DateTime createdAt;

  GravityTask({
    required this.id,
    required this.title,
    this.isDone = false,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'isDone': isDone,
    'createdAt': createdAt.toIso8601String(),
  };

  factory GravityTask.fromJson(Map<String, dynamic> json) => GravityTask(
    id: json['id'],
    title: json['title'],
    isDone: json['isDone'] ?? false,
    createdAt: DateTime.parse(json['createdAt']),
  );
}
