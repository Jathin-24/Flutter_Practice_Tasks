class Task {
  final int? id;
  final String title;
  final String description;
  final DateTime time;
  final bool isCompleted;
  final bool isRepeating;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.time,
    this.isCompleted = false,
    this.isRepeating = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'time': time.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
      'isRepeating': isRepeating ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      time: DateTime.parse(map['time']),
      isCompleted: map['isCompleted'] == 1,
      isRepeating: map['isRepeating'] == 1,
    );
  }
}
