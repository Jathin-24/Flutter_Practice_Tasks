import 'package:hive/hive.dart';

part 'notification_model.g.dart';

/// Model class for Notifications
/// Stores notification data for luggage reminders and alerts
@HiveType(typeId: 5)
class NotificationModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String body;

  @HiveField(3)
  DateTime scheduledTime;

  @HiveField(4)
  String? tripId;

  @HiveField(5)
  bool isRead;

  @HiveField(6)
  bool isScheduled;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  String? payload; // Additional data

  @HiveField(9)
  NotificationType type;

  /// Constructor
  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledTime,
    this.tripId,
    this.isRead = false,
    this.isScheduled = false,
    DateTime? createdAt,
    this.payload,
    this.type = NotificationType.reminder,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Copy with method
  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? scheduledTime,
    String? tripId,
    bool? isRead,
    bool? isScheduled,
    DateTime? createdAt,
    String? payload,
    NotificationType? type,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      tripId: tripId ?? this.tripId,
      isRead: isRead ?? this.isRead,
      isScheduled: isScheduled ?? this.isScheduled,
      createdAt: createdAt ?? this.createdAt,
      payload: payload ?? this.payload,
      type: type ?? this.type,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'scheduledTime': scheduledTime.toIso8601String(),
      'tripId': tripId,
      'isRead': isRead,
      'isScheduled': isScheduled,
      'createdAt': createdAt.toIso8601String(),
      'payload': payload,
      'type': type.name,
    };
  }

  /// Create from JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      scheduledTime: DateTime.parse(json['scheduledTime']),
      tripId: json['tripId'],
      isRead: json['isRead'] ?? false,
      isScheduled: json['isScheduled'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      payload: json['payload'],
      type: NotificationType.values.firstWhere(
            (e) => e.name == json['type'],
        orElse: () => NotificationType.reminder,
      ),
    );
  }

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, '
        'scheduledTime: $scheduledTime, type: ${type.name})';
  }
}

/// Enum for notification types
@HiveType(typeId: 6)
enum NotificationType {
  @HiveField(0)
  reminder,

  @HiveField(1)
  alert,

  @HiveField(2)
  warning,

  @HiveField(3)
  info,
}

/// Extension for notification type display
extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.reminder:
        return 'Reminder';
      case NotificationType.alert:
        return 'Alert';
      case NotificationType.warning:
        return 'Warning';
      case NotificationType.info:
        return 'Info';
    }
  }

  String get icon {
    switch (this) {
      case NotificationType.reminder:
        return '⏰';
      case NotificationType.alert:
        return '🚨';
      case NotificationType.warning:
        return '⚠️';
      case NotificationType.info:
        return 'ℹ️';
    }
  }
}