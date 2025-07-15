class Task {
  final int id;
  final String title;
  final String? description;
  bool completed;
  final DateTime createdAt;
  DateTime? dueDate;
  int priority;
  String? category;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.completed =
        false, // "You don't have to pass this, it is optional. If you don't pass it however, it will be false by default."
    required this.createdAt,
    this.dueDate,
    this.priority = 1,
    this.category,
  });

  Task copyWith({
    // Copy method to create a new Task with some properties changed
    String? title,
    String? description,
    bool? completed,
    DateTime? dueDate,
    int? priority,
    String? category,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      createdAt: createdAt,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'completed': completed,
    'createdAt': createdAt.toIso8601String(),
    'dueDate': dueDate?.toIso8601String(),
    'priority': priority,
    'category': category,
  };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
    id: map['id'],
    title: map['title'],
    description: map['description'],
    completed: map['completed'],
    createdAt: DateTime.parse(map['created_at']),
    dueDate: map['due_date'] != null ? DateTime.parse(map['due_date']) : null,
    priority: map['priority'] ?? 1,
    category: map['category'] ?? '',
  );
}
