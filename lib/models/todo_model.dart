class Todo {
  String title;
  bool isDone;

  Todo({required this.title, this.isDone = false});

  // This converts JSON Map into a Todo Object
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      isDone: json['completed'],
    );
  }
}