import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  // Get the app's document directory for storing images
  Future<Directory> get _appDirectory async {
    final appDir = await getApplicationDocumentsDirectory();
    final luggageDir = Directory('${appDir.path}/luggage_images');

    if (!await luggageDir.exists()) {
      await luggageDir.create(recursive: true);
    }

    return luggageDir;
  }

  // Save and compress an image
  Future<String> saveImage(String sourcePath) async {
    try {
      final Directory appDir = await _appDirectory;
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String extension = path.extension(sourcePath);
      final String fileName = 'luggage_$timestamp$extension';
      final String targetPath = '${appDir.path}/$fileName';

      // Compress and save the image
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        sourcePath,
        targetPath,
        quality: 70,
        minWidth: 1024,
        minHeight: 1024,
      );

      if (compressedFile == null) {
        // If compression fails, copy the original
        final File sourceFile = File(sourcePath);
        await sourceFile.copy(targetPath);
        return targetPath;
      }

      return compressedFile.path;
    } catch (e) {
      // print('Error saving image: $e');
      rethrow;
    }
  }

  // Delete an image
  Future<void> deleteImage(String imagePath) async {
    try {
      final File file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // print('Error deleting image: $e');
    }
  }

  // Delete all images for a trip
  Future<void> deleteAllImagesForTrip(List<String> imagePaths) async {
    for (String imagePath in imagePaths) {
      await deleteImage(imagePath);
    }
  }

  // Check if image exists
  Future<bool> imageExists(String imagePath) async {
    final File file = File(imagePath);
    return await file.exists();
  }

  // Get image file
  File getImageFile(String imagePath) {
    return File(imagePath);
  }
}