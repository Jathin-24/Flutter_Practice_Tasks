import 'package:flutter/foundation.dart';
import '../models/trip.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

/// Controller for managing trip-related operations
/// Uses ChangeNotifier for state management with Provider
class TripController extends ChangeNotifier {
  final StorageService _storageService;

  List<Trip> _trips = [];
  Trip? _selectedTrip;
  bool _isLoading = false;
  String? _error;

  TripController(this._storageService) {
    loadTrips();
  }

  // Getters
  List<Trip> get trips => _trips;
  Trip? get selectedTrip => _selectedTrip;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Get upcoming trips
  List<Trip> get upcomingTrips =>
      _trips.where((trip) => trip.isUpcoming).toList()
        ..sort((a, b) => a.startDate.compareTo(b.startDate));

  /// Get ongoing trips
  List<Trip> get ongoingTrips =>
      _trips.where((trip) => trip.isOngoing).toList();

  /// Get completed trips
  List<Trip> get completedTrips =>
      _trips.where((trip) => trip.isCompleted).toList()
        ..sort((a, b) => b.startDate.compareTo(a.startDate));

  /// Get active trips count
  int get activeTripCount => _trips.length;

  /// Load all trips from storage
  Future<void> loadTrips() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _trips = _storageService.getActiveTrips();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load trips: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add a new trip
  Future<bool> addTrip(Trip trip) async {
    try {
      _error = null;

      // Validate trip data
      if (trip.name.trim().isEmpty) {
        _error = 'Trip name cannot be empty';
        notifyListeners();
        return false;
      }

      if (trip.endDate != null && trip.endDate!.isBefore(trip.startDate)) {
        _error = 'End date cannot be before start date';
        notifyListeners();
        return false;
      }

      await _storageService.addTrip(trip);

      // Schedule notifications for the trip
      // await NotificationService.scheduleAllRemindersForTrip(trip);

      _trips = _storageService.getActiveTrips();
      notifyListeners();

      return true;
    } catch (e) {
      _error = 'Failed to add trip: $e';
      notifyListeners();
      return false;
    }
  }

  /// Update an existing trip
  Future<bool> updateTrip(Trip trip) async {
    try {
      _error = null;

      // Validate trip data
      if (trip.name.trim().isEmpty) {
        _error = 'Trip name cannot be empty';
        notifyListeners();
        return false;
      }

      if (trip.endDate != null && trip.endDate!.isBefore(trip.startDate)) {
        _error = 'End date cannot be before start date';
        notifyListeners();
        return false;
      }

      await _storageService.updateTrip(trip);

      // Update notifications
      // await NotificationService.cancelAllRemindersForTrip(trip.id);
      // await NotificationService.scheduleAllRemindersForTrip(trip);

      _trips = _storageService.getActiveTrips();

      // Update selected trip if it's the one being updated
      if (_selectedTrip?.id == trip.id) {
        _selectedTrip = trip;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to update trip: $e';
      notifyListeners();
      return false;
    }
  }

  /// Delete a trip
  Future<bool> deleteTrip(String tripId) async {
    try {
      _error = null;

      await _storageService.deleteTrip(tripId);

      // Cancel all notifications for this trip
      // await NotificationService.cancelAllRemindersForTrip(tripId);

      _trips = _storageService.getActiveTrips();

      // Clear selected trip if it's the one being deleted
      if (_selectedTrip?.id == tripId) {
        _selectedTrip = null;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to delete trip: $e';
      notifyListeners();
      return false;
    }
  }

  /// Select a trip
  void selectTrip(Trip trip) {
    _selectedTrip = trip;
    notifyListeners();
  }

  /// Clear selected trip
  void clearSelectedTrip() {
    _selectedTrip = null;
    notifyListeners();
  }

  /// Get trip by ID
  Trip? getTripById(String id) {
    try {
      return _trips.firstWhere((trip) => trip.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Search trips by name or destination
  List<Trip> searchTrips(String query) {
    if (query.isEmpty) return _trips;

    final lowerQuery = query.toLowerCase();
    return _trips.where((trip) {
      return trip.name.toLowerCase().contains(lowerQuery) ||
          (trip.destination?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  /// Get trips by type
  List<Trip> getTripsByType(TripType type) {
    return _trips.where((trip) => trip.type == type).toList();
  }

  /// Get trips by date range
  List<Trip> getTripsByDateRange(DateTime start, DateTime end) {
    return _trips.where((trip) {
      return trip.startDate.isAfter(start) &&
          trip.startDate.isBefore(end);
    }).toList();
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Refresh trips (reload from storage)
  Future<void> refresh() async {
    await loadTrips();
  }

  /// Get statistics
  Map<String, dynamic> getStatistics() {
    return {
      'total': _trips.length,
      'upcoming': upcomingTrips.length,
      'ongoing': ongoingTrips.length,
      'completed': completedTrips.length,
      'byType': {
        'flight': getTripsByType(TripType.flight).length,
        'train': getTripsByType(TripType.train).length,
        'bus': getTripsByType(TripType.bus).length,
        'car': getTripsByType(TripType.car).length,
        'other': getTripsByType(TripType.other).length,
      },
    };
  }

  @override
  void dispose() {
    super.dispose();
  }
}