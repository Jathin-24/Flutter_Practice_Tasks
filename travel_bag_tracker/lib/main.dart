import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'models/trip.dart';
import 'models/bag.dart';
import 'models/notification_model.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';
import 'controllers/trip_controller.dart';
import 'controllers/bag_controller.dart';
import 'views/home_screen.dart';
import 'utils/constants.dart';

/// Main entry point for the Travel Bag Tracker app
/// Initializes Hive storage, notifications, and state management
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Register Hive adapters for custom objects
  Hive.registerAdapter<Trip>(TripAdapter());
  Hive.registerAdapter<TripType>(TripTypeAdapter());

  Hive.registerAdapter<Bag>(BagAdapter());
  Hive.registerAdapter<BagType>(BagTypeAdapter());
  Hive.registerAdapter<BagSize>(BagSizeAdapter());

  Hive.registerAdapter<NotificationModel>(NotificationModelAdapter());
  Hive.registerAdapter<NotificationType>(NotificationTypeAdapter()); // <-- VERY IMPORTANT! Don't forget enums


  // Open Hive boxes
  await Hive.openBox<Trip>('trips');
  await Hive.openBox<Bag>('bags');
  await Hive.openBox<NotificationModel>('notifications');
  await Hive.openBox('settings');

  // Initialize timezone for notifications
  tz.initializeTimeZones();

  // Initialize notification service
  // await NotificationService.initialize();

  // Add dummy data for testing (only if boxes are empty)
  await _addDummyDataIfNeeded();

  runApp(const TravelBagTrackerApp());
}

/// Adds dummy data for testing if the database is empty
Future<void> _addDummyDataIfNeeded() async {
  final tripBox = Hive.box<Trip>('trips');

  if (tripBox.isEmpty) {
    // Create sample trips
    final trip1 = Trip(
      id: 'trip_001',
      name: 'Tokyo Business Trip',
      type: TripType.flight,
      startDate: DateTime.now().add(const Duration(days: 2)),
      endDate: DateTime.now().add(const Duration(days: 7)),
      destination: 'Tokyo, Japan',
      notes: 'Annual business conference',
    );

    final trip2 = Trip(
      id: 'trip_002',
      name: 'Paris Vacation',
      type: TripType.train,
      startDate: DateTime.now().add(const Duration(days: 15)),
      endDate: DateTime.now().add(const Duration(days: 20)),
      destination: 'Paris, France',
      notes: 'Family vacation',
    );

    await tripBox.add(trip1);
    await tripBox.add(trip2);

    // Create sample bags for trip1
    final bagBox = Hive.box<Bag>('bags');

    final bag1 = Bag(
      id: 'bag_001',
      tripId: trip1.id,
      name: 'Black Suitcase',
      type: BagType.suitcase,
      size: BagSize.large,
      color: 'Black',
      notes: 'Main luggage with clothes',
      photoPath: null, // No actual photo in dummy data
      isVerified: false,
    );

    final bag2 = Bag(
      id: 'bag_002',
      tripId: trip1.id,
      name: 'Laptop Backpack',
      type: BagType.backpack,
      size: BagSize.small,
      color: 'Gray',
      notes: 'Contains laptop and documents',
      photoPath: null,
      isVerified: false,
    );

    await bagBox.add(bag1);
    await bagBox.add(bag2);
  }
}

/// Root widget of the application
class TravelBagTrackerApp extends StatelessWidget {
  const TravelBagTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide trip controller for state management
        ChangeNotifierProvider(
          create: (_) => TripController(StorageService()),
        ),
        // Provide bag controller for state management
        ChangeNotifierProvider(
          create: (_) => BagController(StorageService()),
        ),
      ],
      child: MaterialApp(
        title: 'Travel Bag Tracker',
        debugShowCheckedModeBanner: false,
        theme: _buildLightTheme(),
        darkTheme: _buildDarkTheme(),
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }

  /// Light theme configuration
  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  /// Dark theme configuration
  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
      ),
    );
  }
}