class Trip {
  final String id;
  final String name;
  final String type;
  final DateTime startDate;
  final DateTime endDate;
  final String? destination;
  final String? notes;
  final List<String> bagIds;
  final bool isActive;
  final DateTime createdAt;

  Trip({
    required this.id,
    required this.name,
    required this.type,
    required this.startDate,
    required this.endDate,
    this.destination,
    this.notes,
    List<String>? bagIds,
    this.isActive = true,
    DateTime? createdAt,
  })  : bagIds = bagIds ?? [],
        createdAt = createdAt ?? DateTime.now();

  int get durationInDays => endDate.difference(startDate).inDays + 1;

  String get status {
    final now = DateTime.now();
    if (!isActive) return 'Cancelled';
    if (now.isBefore(startDate)) return 'Upcoming';
    if (now.isAfter(endDate)) return 'Completed';
    return 'Active';
  }

  bool get isCurrentlyActive {
    final now = DateTime.now();
    return isActive && now.isAfter(startDate) && now.isBefore(endDate);
  }
}