import 'package:hive/hive.dart';
import '../models/trip.dart';
import '../models/bag.dart';
import '../models/notification_model.dart';

/// Service class for managing local storage using Hive
/// Provides CRUD operations for trips, bags, and notifications
class StorageService {
  // Box names
  static const String _tripsBoxName = 'trips';
  static const String _bagsBoxName = 'bags';
  static const String _notificationsBoxName = 'notifications';
  static const String _settingsBoxName = 'settings';

  // Lazy getters for Hive boxes
  Box<Trip> get _tripsBox => Hive.box<Trip>(_tripsBoxName);
  Box<Bag> get _bagsBox => Hive.box<Bag>(_bagsBoxName);
  Box<NotificationModel> get _notificationsBox =>
      Hive.box<NotificationModel>(_notificationsBoxName);
  Box get _settingsBox => Hive.box(_settingsBoxName);

  // ==================== TRIP OPERATIONS ====================

  /// Get all trips
  List<Trip> getAllTrips() {
    return _tripsBox.values.toList();
  }

  /// Get all active trips (not deleted)
  List<Trip> getActiveTrips() {
    return _tripsBox.values.where((trip) => trip.isActive).toList();
  }

  /// Get a trip by ID
  Trip? getTripById(String id) {
    try {
      return _tripsBox.values.firstWhere((trip) => trip.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Add a new trip
  Future<void> addTrip(Trip trip) async {
    await _tripsBox.add(trip);
  }

  /// Update an existing trip
  Future<void> updateTrip(Trip trip) async {
    final index = _tripsBox.values.toList().indexWhere((t) => t.id == trip.id);
    if (index != -1) {
      await _tripsBox.putAt(index, trip.copyWith(updatedAt: DateTime.now()));
    }
  }

  /// Delete a trip (soft delete by marking as inactive)
  Future<void> deleteTrip(String tripId) async {
    final trip = getTripById(tripId);
    if (trip != null) {
      final index = _tripsBox.values.toList().indexWhere((t) => t.id == tripId);
      if (index != -1) {
        await _tripsBox.putAt(
          index,
          trip.copyWith(isActive: false, updatedAt: DateTime.now()),
        );
      }

      // Also delete associated bags
      await deleteBagsByTripId(tripId);
    }
  }

  /// Get upcoming trips
  List<Trip> getUpcomingTrips() {
    return getActiveTrips()
        .where((trip) => trip.isUpcoming)
        .toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
  }

  /// Get ongoing trips
  List<Trip> getOngoingTrips() {
    return getActiveTrips().where((trip) => trip.isOngoing).toList();
  }

  /// Get completed trips
  List<Trip> getCompletedTrips() {
    return getActiveTrips()
        .where((trip) => trip.isCompleted)
        .toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
  }

  // ==================== BAG OPERATIONS ====================

  /// Get all bags
  List<Bag> getAllBags() {
    return _bagsBox.values.toList();
  }

  /// Get bags for a specific trip
  List<Bag> getBagsByTripId(String tripId) {
    return _bagsBox.values.where((bag) => bag.tripId == tripId).toList();
  }

  /// Get a bag by ID
  Bag? getBagById(String id) {
    try {
      return _bagsBox.values.firstWhere((bag) => bag.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Add a new bag
  Future<void> addBag(Bag bag) async {
    await _bagsBox.add(bag);
  }

  /// Update an existing bag
  Future<void> updateBag(Bag bag) async {
    final index = _bagsBox.values.toList().indexWhere((b) => b.id == bag.id);
    if (index != -1) {
      await _bagsBox.putAt(index, bag.copyWith(updatedAt: DateTime.now()));
    }
  }

  /// Delete a bag
  Future<void> deleteBag(String bagId) async {
    final index = _bagsBox.values.toList().indexWhere((b) => b.id == bagId);
    if (index != -1) {
      await _bagsBox.deleteAt(index);
    }
  }

  /// Delete all bags for a trip
  Future<void> deleteBagsByTripId(String tripId) async {
    final bags = getBagsByTripId(tripId);
    for (var bag in bags) {
      await deleteBag(bag.id);
    }
  }

  /// Get verified bags for a trip
  List<Bag> getVerifiedBags(String tripId) {
    return getBagsByTripId(tripId).where((bag) => bag.isVerified).toList();
  }

  /// Get unverified bags for a trip
  List<Bag> getUnverifiedBags(String tripId) {
    return getBagsByTripId(tripId).where((bag) => !bag.isVerified).toList();
  }

  /// Verify a bag
  Future<void> verifyBag(String bagId) async {
    final bag = getBagById(bagId);
    if (bag != null) {
      final index = _bagsBox.values.toList().indexWhere((b) => b.id == bagId);
      if (index != -1) {
        await _bagsBox.putAt(
          index,
          bag.copyWith(
            isVerified: true,
            verifiedAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
      }
    }
  }

  /// Unverify a bag
  Future<void> unverifyBag(String bagId) async {
    final bag = getBagById(bagId);
    if (bag != null) {
      final index = _bagsBox.values.toList().indexWhere((b) => b.id == bagId);
      if (index != -1) {
        await _bagsBox.putAt(
          index,
          bag.copyWith(
            isVerified: false,
            verifiedAt: null,
            updatedAt: DateTime.now(),
          ),
        );
      }
    }
  }

  // ==================== NOTIFICATION OPERATIONS ====================

  /// Get all notifications
  List<NotificationModel> getAllNotifications() {
    return _notificationsBox.values.toList()
      ..sort((a, b) => b.scheduledTime.compareTo(a.scheduledTime));
  }

  /// Get unread notifications
  List<NotificationModel> getUnreadNotifications() {
    return _notificationsBox.values
        .where((notif) => !notif.isRead)
        .toList()
      ..sort((a, b) => b.scheduledTime.compareTo(a.scheduledTime));
  }

  /// Get notifications for a specific trip
  List<NotificationModel> getNotificationsByTripId(String tripId) {
    return _notificationsBox.values
        .where((notif) => notif.tripId == tripId)
        .toList()
      ..sort((a, b) => b.scheduledTime.compareTo(a.scheduledTime));
  }

  /// Add a notification
  Future<void> addNotification(NotificationModel notification) async {
    await _notificationsBox.add(notification);
  }

  /// Update a notification
  Future<void> updateNotification(NotificationModel notification) async {
    final index = _notificationsBox.values.toList()
        .indexWhere((n) => n.id == notification.id);
    if (index != -1) {
      await _notificationsBox.putAt(index, notification);
    }
  }

  /// Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    final notif = _notificationsBox.values
        .where((n) => n.id == notificationId)
        .firstOrNull;
    if (notif != null) {
      final index = _notificationsBox.values.toList()
          .indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        await _notificationsBox.putAt(
          index,
          notif.copyWith(isRead: true),
        );
      }
    }
  }

  /// Mark all notifications as read
  Future<void> markAllNotificationsAsRead() async {
    final notifications = getUnreadNotifications();
    for (var notif in notifications) {
      await markNotificationAsRead(notif.id);
    }
  }

  /// Delete a notification
  Future<void> deleteNotification(String notificationId) async {
    final index = _notificationsBox.values.toList()
        .indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      await _notificationsBox.deleteAt(index);
    }
  }

  /// Delete notifications for a trip
  Future<void> deleteNotificationsByTripId(String tripId) async {
    final notifications = getNotificationsByTripId(tripId);
    for (var notif in notifications) {
      await deleteNotification(notif.id);
    }
  }

  // ==================== SETTINGS OPERATIONS ====================

  /// Save a setting
  Future<void> saveSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  /// Get a setting
  dynamic getSetting(String key, {dynamic defaultValue}) {
    return _settingsBox.get(key, defaultValue: defaultValue);
  }

  /// Check if dark mode is enabled
  bool get isDarkMode => getSetting('darkMode', defaultValue: false);

  /// Set dark mode
  Future<void> setDarkMode(bool enabled) async {
    await saveSetting('darkMode', enabled);
  }

  // ==================== STATISTICS ====================

  /// Get total number of trips
  int get totalTrips => getActiveTrips().length;

  /// Get total number of bags
  int get totalBags => getAllBags().length;

  /// Get total number of unread notifications
  int get unreadNotificationCount => getUnreadNotifications().length;

  /// Get verification rate for a trip
  double getVerificationRate(String tripId) {
    final bags = getBagsByTripId(tripId);
    if (bags.isEmpty) return 0.0;
    final verifiedCount = bags.where((b) => b.isVerified).length;
    return verifiedCount / bags.length;
  }

  // ==================== DATA MANAGEMENT ====================

  /// Clear all data (use with caution)
  Future<void> clearAllData() async {
    await _tripsBox.clear();
    await _bagsBox.clear();
    await _notificationsBox.clear();
  }

  /// Export data to JSON
  Map<String, dynamic> exportData() {
    return {
      'trips': getAllTrips().map((t) => t.toJson()).toList(),
      'bags': getAllBags().map((b) => b.toJson()).toList(),
      'notifications': getAllNotifications().map((n) => n.toJson()).toList(),
      'exportedAt': DateTime.now().toIso8601String(),
    };
  }
}