class LuggageItem {
  final int? id;
  final int tripId;
  final String imagePath;
  final DateTime capturedAt;
  final bool? isPresent; // null = not reviewed, true = present, false = missing

  LuggageItem({
    this.id,
    required this.tripId,
    required this.imagePath,
    required this.capturedAt,
    this.isPresent,
  });

  // Convert LuggageItem to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tripId': tripId,
      'imagePath': imagePath,
      'capturedAt': capturedAt.toIso8601String(),
      'isPresent': isPresent == null ? null : (isPresent! ? 1 : 0),
    };
  }

  // Create LuggageItem from Map
  factory LuggageItem.fromMap(Map<String, dynamic> map) {
    return LuggageItem(
      id: map['id'],
      tripId: map['tripId'],
      imagePath: map['imagePath'],
      capturedAt: DateTime.parse(map['capturedAt']),
      isPresent: map['isPresent'] == null
          ? null
          : map['isPresent'] == 1,
    );
  }

  // Create a copy with updated fields
  LuggageItem copyWith({
    int? id,
    int? tripId,
    String? imagePath,
    DateTime? capturedAt,
    bool? isPresent,
  }) {
    return LuggageItem(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      imagePath: imagePath ?? this.imagePath,
      capturedAt: capturedAt ?? this.capturedAt,
      isPresent: isPresent ?? this.isPresent,
    );
  }
}