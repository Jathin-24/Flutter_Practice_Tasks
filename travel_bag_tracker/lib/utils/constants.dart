import 'package:flutter/material.dart';

/// App-wide constants and configuration
class AppConstants {
  // App Info
  static const String appName = 'Travel Bag Tracker';
  static const String appVersion = '1.0.0';

  // Feature Flags
  static const bool enableAIRecognition = false; // Future feature
  static const bool enableGPSTracking = false; // Future feature
  static const bool enableBluetoothTracking = false; // Future feature
  static const bool enableTravelServices = false; // Future feature

  // Notification Settings
  static const Duration defaultReminderBefore = Duration(hours: 2);
  static const Duration departureReminderBefore = Duration(hours: 4);
  static const Duration finalCheckBefore = Duration(minutes: 30);

  // Image Settings
  static const int maxImageWidth = 1920;
  static const int maxImageHeight = 1080;
  static const int imageQuality = 85;
  static const int maxAdditionalPhotos = 5;

  // UI Settings
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration snackBarDuration = Duration(seconds: 3);

  // Storage Keys
  static const String darkModeKey = 'darkMode';
  static const String notificationsEnabledKey = 'notificationsEnabled';
  static const String firstLaunchKey = 'firstLaunch';
}

/// Color constants for the app
class AppColors {
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFF64B5F6);

  static const Color accent = Color(0xFFFF9800);
  static const Color accentDark = Color(0xFFF57C00);
  static const Color accentLight = Color(0xFFFFB74D);

  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color cardBackground = Colors.white;

  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);

  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFE0E0E0);

  // Status Colors
  static const Color upcoming = Color(0xFF2196F3);
  static const Color ongoing = Color(0xFF4CAF50);
  static const Color completed = Color(0xFF757575);

  static const Color verified = Color(0xFF4CAF50);
  static const Color unverified = Color(0xFFFF9800);
}

/// Text style constants
class AppTextStyles {
  static const TextStyle headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle subtitle1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle subtitle2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

/// Padding and spacing constants
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);

  static const EdgeInsets horizontalPaddingMD = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets verticalPaddingMD = EdgeInsets.symmetric(vertical: md);
}

/// Border radius constants
class AppRadius {
  static const double sm = 4.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
  static const double xxl = 24.0;
  static const double circular = 999.0;

  static const BorderRadius radiusSM = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusMD = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusLG = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radiusXL = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius radiusXXL = BorderRadius.all(Radius.circular(xxl));
}

/// Icon size constants
class AppIconSize {
  static const double sm = 16.0;
  static const double md = 24.0;
  static const double lg = 32.0;
  static const double xl = 48.0;
  static const double xxl = 64.0;
}

/// Elevation constants
class AppElevation {
  static const double none = 0.0;
  static const double sm = 1.0;
  static const double md = 2.0;
  static const double lg = 4.0;
  static const double xl = 8.0;
}

/// Message constants
class AppMessages {
  // Success messages
  static const String tripAdded = 'Trip added successfully';
  static const String tripUpdated = 'Trip updated successfully';
  static const String tripDeleted = 'Trip deleted successfully';

  static const String bagAdded = 'Bag added successfully';
  static const String bagUpdated = 'Bag updated successfully';
  static const String bagDeleted = 'Bag deleted successfully';
  static const String bagVerified = 'Bag verified successfully';
  static const String bagUnverified = 'Bag unverified';

  // Error messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'Network error. Please check your connection.';
  static const String errorImagePicker = 'Failed to pick image. Please try again.';
  static const String errorPermissionCamera = 'Camera permission is required';
  static const String errorPermissionStorage = 'Storage permission is required';

  // Validation messages
  static const String validationNameRequired = 'Name is required';
  static const String validationDateInvalid = 'Invalid date';
  static const String validationEndBeforeStart = 'End date cannot be before start date';

  // Info messages
  static const String noBagsYet = 'No bags added yet. Tap + to add your first bag.';
  static const String noTripsYet = 'No trips yet. Start by creating your first trip!';
  static const String allBagsVerified = 'All bags verified! You\'re ready to go.';
  static const String unverifiedBagsWarning = 'You have unverified bags. Please verify all bags before departure.';
}

/// Route names
class AppRoutes {
  static const String home = '/';
  static const String newTrip = '/new-trip';
  static const String editTrip = '/edit-trip';
  static const String tripDetails = '/trip-details';
  static const String addBag = '/add-bag';
  static const String editBag = '/edit-bag';
  static const String bagDetails = '/bag-details';
  static const String verification = '/verification';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
}