import 'package:get/get.dart';
import '../models/trip.dart';
import '../models/luggage_item.dart';
import '../services/database_service.dart';
import '../services/storage_service.dart';

class TripController extends GetxController {
  final DatabaseService _db = DatabaseService();
  final StorageService _storage = StorageService();

  var trips = <Trip>[].obs;
  var isLoading = false.obs;
  var currentTrip = Rx<Trip?>(null);

  @override
  void onInit() {
    super.onInit();
    loadTrips();
  }

  // Load all trips
  Future<void> loadTrips() async {
    try {
      isLoading.value = true;
      trips.value = await _db.getAllTrips();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load trips: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Create a new trip
  Future<int?> createTrip(String name, String destination) async {
    try {
      if (name.trim().isEmpty || destination.trim().isEmpty) {
        Get.snackbar(
          'Error',
          'Please fill in all fields',
          snackPosition: SnackPosition.BOTTOM,
        );
        return null;
      }

      final trip = Trip(
        name: name.trim(),
        destination: destination.trim(),
        createdAt: DateTime.now(),
      );

      final id = await _db.createTrip(trip);
      await loadTrips();

      Get.snackbar(
        'Success',
        'Trip created successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );

      return id;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create trip: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  // Set current trip
  void setCurrentTrip(Trip trip) {
    currentTrip.value = trip;
  }

  // Complete a trip
  Future<void> completeTrip(int tripId) async {
    try {
      final trip = await _db.getTripById(tripId);
      if (trip != null) {
        final updatedTrip = trip.copyWith(isCompleted: true);
        await _db.updateTrip(updatedTrip);
        await loadTrips();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to complete trip: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Delete a trip and all its luggage items
  Future<void> deleteTrip(int tripId) async {
    try {
      // Get all luggage items to delete their images
      final luggageItems = await _db.getLuggageItemsByTrip(tripId);
      final imagePaths = luggageItems.map((item) => item.imagePath).toList();

      // Delete all images
      await _storage.deleteAllImagesForTrip(imagePaths);

      // Delete luggage items
      for (var item in luggageItems) {
        await _db.deleteLuggageItem(item.id!);
      }

      // Delete trip
      await _db.deleteTrip(tripId);
      await loadTrips();

      Get.snackbar(
        'Success',
        'Trip deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete trip: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Get luggage count for a trip
  Future<int> getLuggageCount(int tripId) async {
    return await _db.getLuggageCount(tripId);
  }
}