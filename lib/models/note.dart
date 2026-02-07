class NebulaNoteCard {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;

  NebulaNoteCard({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'createdAt': createdAt.toIso8601String(),
  };

  factory NebulaNoteCard.fromJson(Map<String, dynamic> json) => NebulaNoteCard(
    id: json['id'],
    title: json['title'],
    body: json['body'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}
