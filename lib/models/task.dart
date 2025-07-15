class Task {
  final String id;
  final String title;
  final String description;
  bool completed;
  final int ownerId;
  final DateTime createdAt;
  DateTime? dueDate;
  int priority;
  String category;

  Task({
    required this.id,
    required this.title,
    this.description = '', // Do not use 'required' for optional fields
    this.completed = false,
    required this.ownerId,
    required this.createdAt,
    this.dueDate,
    this.priority = 1,
    this.category = '',
  });

  Task copyWith({
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
      ownerId: ownerId,
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
    'ownerId': ownerId,
    'createdAt': createdAt.toIso8601String(),
    'dueDate': dueDate?.toIso8601String(),
    'priority': priority,
    'category': category,
  };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
    id: map['id'],
    title: map['title'],
    description: map['description'] ?? '',
    completed: map['completed'] ?? false,
    ownerId: map['owner_id'],
    createdAt: DateTime.parse(map['created_at']),
    dueDate: map['due_date'] != null ? DateTime.parse(map['due_date']) : null,
    priority: map['priority'] ?? 1,
    category: map['category'] ?? '',
  );
}
