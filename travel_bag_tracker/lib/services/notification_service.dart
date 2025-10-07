// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import '../models/notification_model.dart';
// import '../models/trip.dart';
// import 'storage_service.dart';
//
// /// Service for managing push notifications
// /// Handles scheduling, displaying, and managing notifications
// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notifications =
//   FlutterLocalNotificationsPlugin();
//
//   static final StorageService _storageService = StorageService();
//
//   /// Initialize the notification service
//   static Future<void> initialize() async {
//     // Android initialization settings
//     const AndroidInitializationSettings androidSettings =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     // iOS initialization settings
//     const DarwinInitializationSettings iosSettings =
//     DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );
//
//     // Combined initialization settings
//     const InitializationSettings initSettings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );
//
//     // Initialize with settings
//     await _notifications.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: _onNotificationTapped,
//     );
//
//     // Request permissions for iOS
//     await _requestPermissions();
//   }
//
//   /// Request notification permissions (mainly for iOS)
//   static Future<void> _requestPermissions() async {
//     await _notifications
//         .resolvePlatformSpecificImplementation<
//         IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     await _notifications
//         .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestPermission();
//   }
//
//   /// Handle notification tap
//   static void _onNotificationTapped(NotificationResponse response) {
//     // Handle navigation based on payload
//     print('Notification tapped: ${response.payload}');
//     // TODO: Implement navigation to specific screen
//   }
//
//   /// Schedule a notification
//   static Future<void> scheduleNotification({
//     required int id,
//     required String title,
//     required String body,
//     required DateTime scheduledTime,
//     String? payload,
//   }) async {
//     // Android notification details
//     const AndroidNotificationDetails androidDetails =
//     AndroidNotificationDetails(
//       'travel_bag_tracker_channel',
//       'Luggage Reminders',
//       channelDescription: 'Notifications for luggage check reminders',
//       importance: Importance.high,
//       priority: Priority.high,
//       icon: '@mipmap/ic_launcher',
//     );
//
//     // iOS notification details
//     const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );
//
//     // Combined notification details
//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );
//
//     // Schedule the notification
//     await _notifications.zonedSchedule(
//       id,
//       title,
//       body,
//       tz.TZDateTime.from(scheduledTime, tz.local),
//       notificationDetails,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.absoluteTime,
//       payload: payload,
//     );
//   }
//
//   /// Show an immediate notification
//   static Future<void> showNotification({
//     required int id,
//     required String title,
//     required String body,
//     String? payload,
//   }) async {
//     const AndroidNotificationDetails androidDetails =
//     AndroidNotificationDetails(
//       'travel_bag_tracker_channel',
//       'Luggage Reminders',
//       channelDescription: 'Notifications for luggage check reminders',
//       importance: Importance.high,
//       priority: Priority.high,
//       icon: '@mipmap/ic_launcher',
//     );
//
//     const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );
//
//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );
//
//     await _notifications.show(
//       id,
//       title,
//       body,
//       notificationDetails,
//       payload: payload,
//     );
//   }
//
//   /// Cancel a specific notification
//   static Future<void> cancelNotification(int id) async {
//     await _notifications.cancel(id);
//   }
//
//   /// Cancel all notifications
//   static Future<void> cancelAllNotifications() async {
//     await _notifications.cancelAll();
//   }
//
//   /// Schedule luggage check reminder for a trip
//   static Future<void> scheduleLuggageCheckReminder({
//     required Trip trip,
//     Duration? beforeDeparture,
//   }) async {
//     // Default to 2 hours before departure
//     final reminderTime = trip.startDate.subtract(
//       beforeDeparture ?? const Duration(hours: 2),
//     );
//
//     // Only schedule if the reminder time is in the future
//     if (reminderTime.isAfter(DateTime.now())) {
//       final notificationId = trip.id.hashCode;
//
//       await scheduleNotification(
//         id: notificationId,
//         title: '🧳 Luggage Check Reminder',
//         body: 'Don\'t forget to check your luggage for ${trip.name}!',
//         scheduledTime: reminderTime,
//         payload: trip.id,
//       );
//
//       // Save notification to storage
//       final notification = NotificationModel(
//         id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
//         title: '🧳 Luggage Check Reminder',
//         body: 'Don\'t forget to check your luggage for ${trip.name}!',
//         scheduledTime: reminderTime,
//         tripId: trip.id,
//         isScheduled: true,
//         type: NotificationType.reminder,
//       );
//
//       await _storageService.addNotification(notification);
//     }
//   }
//
//   /// Schedule departure reminder
//   static Future<void> scheduleDepartureReminder({
//     required Trip trip,
//     Duration? beforeDeparture,
//   }) async {
//     final reminderTime = trip.startDate.subtract(
//       beforeDeparture ?? const Duration(hours: 4),
//     );
//
//     if (reminderTime.isAfter(DateTime.now())) {
//       final notificationId = '${trip.id}_departure'.hashCode;
//
//       await scheduleNotification(
//         id: notificationId,
//         title: '⏰ Departure Reminder',
//         body: 'Your ${trip.type.displayName} for ${trip.name} departs soon!',
//         scheduledTime: reminderTime,
//         payload: trip.id,
//       );
//
//       final notification = NotificationModel(
//         id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
//         title: '⏰ Departure Reminder',
//         body: 'Your ${trip.type.displayName} for ${trip.name} departs soon!',
//         scheduledTime: reminderTime,
//         tripId: trip.id,
//         isScheduled: true,
//         type: NotificationType.reminder,
//       );
//
//       await _storageService.addNotification(notification);
//     }
//   }
//
//   /// Send alert for unverified bags
//   static Future<void> sendUnverifiedBagsAlert({
//     required Trip trip,
//     required int unverifiedCount,
//   }) async {
//     await showNotification(
//       id: DateTime.now().millisecondsSinceEpoch,
//       title: '⚠️ Unverified Luggage Alert',
//       body: 'You have $unverifiedCount unverified bag(s) for ${trip.name}',
//       payload: trip.id,
//     );
//
//     // Save to storage
//     final notification = NotificationModel(
//       id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
//       title: '⚠️ Unverified Luggage Alert',
//       body: 'You have $unverifiedCount unverified bag(s) for ${trip.name}',
//       scheduledTime: DateTime.now(),
//       tripId: trip.id,
//       type: NotificationType.alert,
//     );
//
//     await _storageService.addNotification(notification);
//   }
//
//   /// Schedule all reminders for a trip
//   static Future<void> scheduleAllRemindersForTrip(Trip trip) async {
//     // Schedule luggage check 2 hours before
//     await scheduleLuggageCheckReminder(
//       trip: trip,
//       beforeDeparture: const Duration(hours: 2),
//     );
//
//     // Schedule departure reminder 4 hours before
//     await scheduleDepartureReminder(
//       trip: trip,
//       beforeDeparture: const Duration(hours: 4),
//     );
//
//     // Schedule final check 30 minutes before
//     await scheduleLuggageCheckReminder(
//       trip: trip,
//       beforeDeparture: const Duration(minutes: 30),
//     );
//   }
//
//   /// Cancel all reminders for a trip
//   static Future<void> cancelAllRemindersForTrip(String tripId) async {
//     // Cancel system notifications
//     await cancelNotification(tripId.hashCode);
//     await cancelNotification('${tripId}_departure'.hashCode);
//
//     // Delete from storage
//     await _storageService.deleteNotificationsByTripId(tripId);
//   }
//
//   /// Get pending notifications
//   static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
//     return await _notifications.pendingNotificationRequests();
//   }
//
//   /// Check if notifications are enabled
//   static Future<bool> areNotificationsEnabled() async {
//     final result = await _notifications
//         .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()
//         ?.areNotificationsEnabled();
//     return result ?? true;
//   }
//
//   /// Open app notification settings
//   static Future<void> openNotificationSettings() async {
//     // This functionality would need a platform channel implementation
//     // For now, we'll just show a message
//     print('Please enable notifications in your device settings');
//   }
// }