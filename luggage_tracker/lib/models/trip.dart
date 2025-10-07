class Trip {
  final int? id;
  final String name;
  final String destination;
  final DateTime createdAt;
  final bool isCompleted;

  Trip({
    this.id,
    required this.name,
    required this.destination,
    required this.createdAt,
    this.isCompleted = false,
  });

  // Convert Trip to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'destination': destination,
      'createdAt': createdAt.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  // Create Trip from Map
  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'],
      name: map['name'],
      destination: map['destination'],
      createdAt: DateTime.parse(map['createdAt']),
      isCompleted: map['isCompleted'] == 1,
    );
  }

  // Create a copy with updated fields
  Trip copyWith({
    int? id,
    String? name,
    String? destination,
    DateTime? createdAt,
    bool? isCompleted,
  }) {
    return Trip(
      id: id ?? this.id,
      name: name ?? this.name,
      destination: destination ?? this.destination,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}