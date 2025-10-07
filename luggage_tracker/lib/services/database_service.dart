import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/trip.dart';
import '../models/luggage_item.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'luggage_tracker.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create trips table
    await db.execute('''
      CREATE TABLE trips(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        destination TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        isCompleted INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Create luggage_items table
    await db.execute('''
      CREATE TABLE luggage_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tripId INTEGER NOT NULL,
        imagePath TEXT NOT NULL,
        capturedAt TEXT NOT NULL,
        isPresent INTEGER,
        FOREIGN KEY (tripId) REFERENCES trips (id) ON DELETE CASCADE
      )
    ''');
  }

  // TRIP OPERATIONS

  Future<int> createTrip(Trip trip) async {
    final db = await database;
    return await db.insert('trips', trip.toMap());
  }

  Future<List<Trip>> getAllTrips() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'trips',
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => Trip.fromMap(maps[i]));
  }

  Future<Trip?> getTripById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'trips',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Trip.fromMap(maps.first);
  }

  Future<int> updateTrip(Trip trip) async {
    final db = await database;
    return await db.update(
      'trips',
      trip.toMap(),
      where: 'id = ?',
      whereArgs: [trip.id],
    );
  }

  Future<int> deleteTrip(int id) async {
    final db = await database;
    return await db.delete(
      'trips',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // LUGGAGE ITEM OPERATIONS

  Future<int> addLuggageItem(LuggageItem item) async {
    final db = await database;
    return await db.insert('luggage_items', item.toMap());
  }

  Future<List<LuggageItem>> getLuggageItemsByTrip(int tripId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'luggage_items',
      where: 'tripId = ?',
      whereArgs: [tripId],
      orderBy: 'capturedAt ASC',
    );
    return List.generate(maps.length, (i) => LuggageItem.fromMap(maps[i]));
  }

  Future<int> updateLuggageItem(LuggageItem item) async {
    final db = await database;
    return await db.update(
      'luggage_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteLuggageItem(int id) async {
    final db = await database;
    return await db.delete(
      'luggage_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get count of luggage items for a trip
  Future<int> getLuggageCount(int tripId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM luggage_items WHERE tripId = ?',
      [tripId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}