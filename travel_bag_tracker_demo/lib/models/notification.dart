class AppNotification {
  final String id;
  final String title;
  final String body;
  final String type;
  final DateTime scheduledFor;
  final bool isRead;
  final String? tripId;
  final String? bagId;
  final Map<String, dynamic>? payload;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.scheduledFor,
    this.isRead = false,
    this.tripId,
    this.bagId,
    this.payload,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isOverdue => DateTime.now().isAfter(scheduledFor) && !isRead;

  String get timeDescription {
    final now = DateTime.now();
    final difference = scheduledFor.difference(now);

    if (difference.isNegative) {
      final pastDifference = now.difference(scheduledFor);
      if (pastDifference.inDays > 0) {
        return '${pastDifference.inDays} days ago';
      } else if (pastDifference.inHours > 0) {
        return '${pastDifference.inHours} hours ago';
      } else {
        return '${pastDifference.inMinutes} minutes ago';
      }
    } else {
      if (difference.inDays > 0) {
        return 'in ${difference.inDays} days';
      } else if (difference.inHours > 0) {
        return 'in ${difference.inHours} hours';
      } else {
        return 'in ${difference.inMinutes} minutes';
      }
    }
  }
}