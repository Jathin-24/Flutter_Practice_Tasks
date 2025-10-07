import 'package:hive/hive.dart';

part 'trip.g.dart';

/// Enum for different types of trips
@HiveType(typeId: 1)
enum TripType {
  @HiveField(0)
  flight,

  @HiveField(1)
  train,

  @HiveField(2)
  bus,

  @HiveField(3)
  car,

  @HiveField(4)
  other,
}

/// Extension to get display names for trip types
extension TripTypeExtension on TripType {
  String get displayName {
    switch (this) {
      case TripType.flight:
        return 'Flight';
      case TripType.train:
        return 'Train';
      case TripType.bus:
        return 'Bus';
      case TripType.car:
        return 'Car';
      case TripType.other:
        return 'Other';
    }
  }

  String get icon {
    switch (this) {
      case TripType.flight:
        return '✈️';
      case TripType.train:
        return '🚆';
      case TripType.bus:
        return '🚌';
      case TripType.car:
        return '🚗';
      case TripType.other:
        return '🧳';
    }
  }
}

/// Model class for a Trip
/// Stores all information about a travel trip including destination, dates, and type
@HiveType(typeId: 0)
class Trip extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  TripType type;

  @HiveField(3)
  DateTime startDate;

  @HiveField(4)
  DateTime? endDate;

  @HiveField(5)
  String? destination;

  @HiveField(6)
  String? notes;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime updatedAt;

  @HiveField(9)
  bool isActive;

  @HiveField(10)
  String? departureLocation;

  @HiveField(11)
  String? transportNumber; // Flight number, train number, etc.

  /// Constructor
  Trip({
    required this.id,
    required this.name,
    required this.type,
    required this.startDate,
    this.endDate,
    this.destination,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isActive = true,
    this.departureLocation,
    this.transportNumber,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Copy with method for creating modified copies
  Trip copyWith({
    String? id,
    String? name,
    TripType? type,
    DateTime? startDate,
    DateTime? endDate,
    String? destination,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    String? departureLocation,
    String? transportNumber,
  }) {
    return Trip(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      destination: destination ?? this.destination,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      departureLocation: departureLocation ?? this.departureLocation,
      transportNumber: transportNumber ?? this.transportNumber,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'destination': destination,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
      'departureLocation': departureLocation,
      'transportNumber': transportNumber,
    };
  }

  /// Create from JSON
  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      name: json['name'],
      type: TripType.values.firstWhere((e) => e.name == json['type']),
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      destination: json['destination'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isActive: json['isActive'] ?? true,
      departureLocation: json['departureLocation'],
      transportNumber: json['transportNumber'],
    );
  }

  /// Check if trip is upcoming (starts in future)
  bool get isUpcoming => startDate.isAfter(DateTime.now());

  /// Check if trip is ongoing (between start and end date)
  bool get isOngoing {
    final now = DateTime.now();
    if (endDate != null) {
      return now.isAfter(startDate) && now.isBefore(endDate!);
    }
    return now.isAfter(startDate) &&
        now.isBefore(startDate.add(const Duration(days: 1)));
  }

  /// Check if trip is completed (end date has passed)
  bool get isCompleted {
    if (endDate != null) {
      return DateTime.now().isAfter(endDate!);
    }
    return DateTime.now().isAfter(startDate.add(const Duration(days: 1)));
  }

  /// Get trip duration in days
  int get durationInDays {
    if (endDate != null) {
      return endDate!.difference(startDate).inDays + 1;
    }
    return 1;
  }

  /// Get trip status as string
  String get status {
    if (isUpcoming) return 'Upcoming';
    if (isOngoing) return 'Ongoing';
    if (isCompleted) return 'Completed';
    return 'Unknown';
  }

  @override
  String toString() {
    return 'Trip(id: $id, name: $name, type: ${type.displayName}, '
        'startDate: $startDate, destination: $destination)';
  }
}