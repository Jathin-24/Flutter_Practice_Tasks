import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../models/bag.dart';
import '../models/trip.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

/// Controller for managing bag/luggage operations
/// Handles CRUD operations, photo management, and verification
class BagController extends ChangeNotifier {
  final StorageService _storageService;
  final ImagePicker _imagePicker = ImagePicker();

  List<Bag> _bags = [];
  Bag? _selectedBag;
  bool _isLoading = false;
  String? _error;

  BagController(this._storageService) {
    loadBags();
  }

  // Getters
  List<Bag> get bags => _bags;
  Bag? get selectedBag => _selectedBag;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Get bags for a specific trip
  List<Bag> getBagsForTrip(String tripId) {
    return _bags.where((bag) => bag.tripId == tripId).toList();
  }

  /// Get verified bags for a trip
  List<Bag> getVerifiedBagsForTrip(String tripId) {
    return _bags
        .where((bag) => bag.tripId == tripId && bag.isVerified)
        .toList();
  }

  /// Get unverified bags for a trip
  List<Bag> getUnverifiedBagsForTrip(String tripId) {
    return _bags
        .where((bag) => bag.tripId == tripId && !bag.isVerified)
        .toList();
  }

  /// Get verification rate for a trip
  double getVerificationRate(String tripId) {
    final tripBags = getBagsForTrip(tripId);
    if (tripBags.isEmpty) return 0.0;

    final verifiedCount = tripBags.where((b) => b.isVerified).length;
    return verifiedCount / tripBags.length;
  }

  /// Load all bags from storage
  Future<void> loadBags() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _bags = _storageService.getAllBags();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load bags: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add a new bag
  Future<bool> addBag(Bag bag) async {
    try {
      _error = null;

      // Validate bag data
      if (bag.name.trim().isEmpty) {
        _error = 'Bag name cannot be empty';
        notifyListeners();
        return false;
      }

      await _storageService.addBag(bag);
      _bags = _storageService.getAllBags();

      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to add bag: $e';
      notifyListeners();
      return false;
    }
  }

  /// Update an existing bag
  Future<bool> updateBag(Bag bag) async {
    try {
      _error = null;

      if (bag.name.trim().isEmpty) {
        _error = 'Bag name cannot be empty';
        notifyListeners();
        return false;
      }

      await _storageService.updateBag(bag);
      _bags = _storageService.getAllBags();

      // Update selected bag if it's the one being updated
      if (_selectedBag?.id == bag.id) {
        _selectedBag = bag;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to update bag: $e';
      notifyListeners();
      return false;
    }
  }

  /// Delete a bag
  Future<bool> deleteBag(String bagId) async {
    try {
      _error = null;

      // Get bag before deletion to clean up photos
      final bag = _storageService.getBagById(bagId);
      if (bag != null) {
        // Delete associated photos
        await _deletePhotos(bag);
      }

      await _storageService.deleteBag(bagId);
      _bags = _storageService.getAllBags();

      // Clear selected bag if it's the one being deleted
      if (_selectedBag?.id == bagId) {
        _selectedBag = null;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to delete bag: $e';
      notifyListeners();
      return false;
    }
  }

  /// Delete photos associated with a bag
  Future<void> _deletePhotos(Bag bag) async {
    try {
      for (final photoPath in bag.allPhotoPaths) {
        final file = File(photoPath);
        if (await file.exists()) {
          await file.delete();
        }
      }
    } catch (e) {
      // print('Error deleting photos: $e');
    }
  }

  /// Take or pick a photo for a bag
  Future<String?> pickImage({bool fromCamera = true}) async {
    try {
      final XFile? image = fromCamera
          ? await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      )
          : await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) return null;

      // Save image to app directory
      final savedPath = await _saveImageToAppDirectory(image.path);
      return savedPath;
    } catch (e) {
      _error = 'Failed to pick image: $e';
      notifyListeners();
      return null;
    }
  }

  /// Save image to app's document directory
  Future<String> _saveImageToAppDirectory(String imagePath) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = 'bag_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savedImagePath = '${appDir.path}/$fileName';

    final imageFile = File(imagePath);
    await imageFile.copy(savedImagePath);

    return savedImagePath;
  }

  /// Add photo to bag
  Future<bool> addPhotoToBag(String bagId, String photoPath) async {
    try {
      final bag = _storageService.getBagById(bagId);
      if (bag == null) {
        _error = 'Bag not found';
        notifyListeners();
        return false;
      }

      if (bag.photoPath == null) {
        // Set as main photo
        await updateBag(bag.copyWith(photoPath: photoPath));
      } else {
        // Add as additional photo
        final additionalPhotos = bag.additionalPhotoPaths ?? [];
        additionalPhotos.add(photoPath);
        await updateBag(bag.copyWith(additionalPhotoPaths: additionalPhotos));
      }

      return true;
    } catch (e) {
      _error = 'Failed to add photo: $e';
      notifyListeners();
      return false;
    }
  }

  /// Verify a bag
  Future<bool> verifyBag(String bagId) async {
    try {
      _error = null;

      await _storageService.verifyBag(bagId);
      _bags = _storageService.getAllBags();

      // Update selected bag if it's the one being verified
      if (_selectedBag?.id == bagId) {
        _selectedBag = _storageService.getBagById(bagId);
      }

      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to verify bag: $e';
      notifyListeners();
      return false;
    }
  }

  /// Unverify a bag
  Future<bool> unverifyBag(String bagId) async {
    try {
      _error = null;

      await _storageService.unverifyBag(bagId);
      _bags = _storageService.getAllBags();

      // Update selected bag if it's the one being unverified
      if (_selectedBag?.id == bagId) {
        _selectedBag = _storageService.getBagById(bagId);
      }

      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to unverify bag: $e';
      notifyListeners();
      return false;
    }
  }

  /// Toggle bag verification
  Future<bool> toggleBagVerification(String bagId) async {
    final bag = _storageService.getBagById(bagId);
    if (bag == null) return false;

    return bag.isVerified
        ? await unverifyBag(bagId)
        : await verifyBag(bagId);
  }

  /// Check if all bags are verified for a trip
  bool areAllBagsVerified(String tripId) {
    final tripBags = getBagsForTrip(tripId);
    if (tripBags.isEmpty) return true;
    return tripBags.every((bag) => bag.isVerified);
  }

  /// Send alert for unverified bags
  Future<void> sendUnverifiedBagsAlert(Trip trip) async {
    final unverifiedBags = getUnverifiedBagsForTrip(trip.id);
    if (unverifiedBags.isNotEmpty) {
      // await NotificationService.sendUnverifiedBagsAlert(
      //   trip: trip,
      //   unverifiedCount: unverifiedBags.length,
      // );
    }
  }

  /// Select a bag
  void selectBag(Bag bag) {
    _selectedBag = bag;
    notifyListeners();
  }

  /// Clear selected bag
  void clearSelectedBag() {
    _selectedBag = null;
    notifyListeners();
  }

  /// Get bag by ID
  Bag? getBagById(String id) {
    try {
      return _bags.firstWhere((bag) => bag.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Search bags by name or notes
  List<Bag> searchBags(String query, {String? tripId}) {
    var searchBags = tripId != null
        ? getBagsForTrip(tripId)
        : _bags;

    if (query.isEmpty) return searchBags;

    final lowerQuery = query.toLowerCase();
    return searchBags.where((bag) {
      return bag.name.toLowerCase().contains(lowerQuery) ||
          (bag.notes?.toLowerCase().contains(lowerQuery) ?? false) ||
          (bag.color?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Refresh bags (reload from storage)
  Future<void> refresh() async {
    await loadBags();
  }

  /// Get statistics for a trip
  Map<String, dynamic> getTripStatistics(String tripId) {
    final tripBags = getBagsForTrip(tripId);
    final verified = tripBags.where((b) => b.isVerified).length;
    final unverified = tripBags.length - verified;

    return {
      'total': tripBags.length,
      'verified': verified,
      'unverified': unverified,
      'verificationRate': getVerificationRate(tripId),
      'withPhotos': tripBags.where((b) => b.hasPhotos).length,
      'byType': {
        'suitcase': tripBags.where((b) => b.type == BagType.suitcase).length,
        'backpack': tripBags.where((b) => b.type == BagType.backpack).length,
        'duffelBag': tripBags.where((b) => b.type == BagType.duffelBag).length,
        'carryon': tripBags.where((b) => b.type == BagType.carryon).length,
        'handbag': tripBags.where((b) => b.type == BagType.handbag).length,
        'other': tripBags.where((b) => b.type == BagType.other).length,
      },
    };
  }

  @override
  void dispose() {
    super.dispose();
  }
}