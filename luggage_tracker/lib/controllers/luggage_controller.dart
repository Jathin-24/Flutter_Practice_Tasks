import 'package:get/get.dart';
import '../models/luggage_item.dart';
import '../services/database_service.dart';
import '../services/storage_service.dart';

class LuggageController extends GetxController {
  final DatabaseService _db = DatabaseService();
  final StorageService _storage = StorageService();

  var luggageItems = <LuggageItem>[].obs;
  var isLoading = false.obs;
  var currentIndex = 0.obs;

  // Load luggage items for a specific trip
  Future<void> loadLuggageItems(int tripId) async {
    try {
      isLoading.value = true;
      luggageItems.value = await _db.getLuggageItemsByTrip(tripId);
      currentIndex.value = 0;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load luggage items: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Add a new luggage item
  Future<bool> addLuggageItem(int tripId, String imagePath) async {
    try {
      // Save and compress the image
      final savedPath = await _storage.saveImage(imagePath);

      // Create luggage item
      final item = LuggageItem(
        tripId: tripId,
        imagePath: savedPath,
        capturedAt: DateTime.now(),
      );

      // Save to database
      final id = await _db.addLuggageItem(item);

      // Reload items
      await loadLuggageItems(tripId);

      Get.snackbar(
        'Success',
        'Luggage photo added!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add luggage photo: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  // Update luggage item status (present or missing)
  Future<void> updateLuggageStatus(int itemId, bool isPresent) async {
    try {
      final item = luggageItems.firstWhere((item) => item.id == itemId);
      final updatedItem = item.copyWith(isPresent: isPresent);
      await _db.updateLuggageItem(updatedItem);

      // Update local list
      final index = luggageItems.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        luggageItems[index] = updatedItem;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update luggage status: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Delete a luggage item
  Future<void> deleteLuggageItem(int itemId, int tripId) async {
    try {
      final item = luggageItems.firstWhere((item) => item.id == itemId);

      // Delete image from storage
      await _storage.deleteImage(item.imagePath);

      // Delete from database
      await _db.deleteLuggageItem(itemId);

      // Reload items
      await loadLuggageItems(tripId);

      Get.snackbar(
        'Success',
        'Luggage photo deleted',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete luggage item: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Get reviewed items count
  int getReviewedCount() {
    return luggageItems.where((item) => item.isPresent != null).length;
  }

  // Get present items
  List<LuggageItem> getPresentItems() {
    return luggageItems.where((item) => item.isPresent == true).toList();
  }

  // Get missing items
  List<LuggageItem> getMissingItems() {
    return luggageItems.where((item) => item.isPresent == false).toList();
  }

  // Check if all items are reviewed
  bool areAllItemsReviewed() {
    return luggageItems.every((item) => item.isPresent != null);
  }

  // Reset all reviews
  Future<void> resetReviews(int tripId) async {
    try {
      for (var item in luggageItems) {
        final updatedItem = item.copyWith(isPresent: null);
        await _db.updateLuggageItem(updatedItem);
      }
      await loadLuggageItems(tripId);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to reset reviews: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}