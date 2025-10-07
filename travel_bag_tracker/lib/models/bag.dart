import 'package:hive/hive.dart';

part 'bag.g.dart';

/// Enum for different types of bags
@HiveType(typeId: 3)
enum BagType {
  @HiveField(0)
  suitcase,

  @HiveField(1)
  backpack,

  @HiveField(2)
  duffelBag,

  @HiveField(3)
  carryon,

  @HiveField(4)
  handbag,

  @HiveField(5)
  other,
}

/// Extension to get display names for bag types
extension BagTypeExtension on BagType {
  String get displayName {
    switch (this) {
      case BagType.suitcase:
        return 'Suitcase';
      case BagType.backpack:
        return 'Backpack';
      case BagType.duffelBag:
        return 'Duffel Bag';
      case BagType.carryon:
        return 'Carry-on';
      case BagType.handbag:
        return 'Handbag';
      case BagType.other:
        return 'Other';
    }
  }

  String get icon {
    switch (this) {
      case BagType.suitcase:
        return '🧳';
      case BagType.backpack:
        return '🎒';
      case BagType.duffelBag:
        return '👜';
      case BagType.carryon:
        return '💼';
      case BagType.handbag:
        return '👛';
      case BagType.other:
        return '📦';
    }
  }
}

/// Enum for bag sizes
@HiveType(typeId: 4)
enum BagSize {
  @HiveField(0)
  small,

  @HiveField(1)
  medium,

  @HiveField(2)
  large,

  @HiveField(3)
  extraLarge,
}

/// Extension to get display names for bag sizes
extension BagSizeExtension on BagSize {
  String get displayName {
    switch (this) {
      case BagSize.small:
        return 'Small';
      case BagSize.medium:
        return 'Medium';
      case BagSize.large:
        return 'Large';
      case BagSize.extraLarge:
        return 'Extra Large';
    }
  }
}

/// Model class for a Bag/Luggage item
/// Stores all information about a piece of luggage including photos, verification status
@HiveType(typeId: 2)
class Bag extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String tripId;

  @HiveField(2)
  String name;

  @HiveField(3)
  BagType type;

  @HiveField(4)
  BagSize size;

  @HiveField(5)
  String? color;

  @HiveField(6)
  String? notes;

  @HiveField(7)
  String? photoPath;

  @HiveField(8)
  bool isVerified;

  @HiveField(9)
  DateTime createdAt;

  @HiveField(10)
  DateTime updatedAt;

  @HiveField(11)
  DateTime? verifiedAt;

  @HiveField(12)
  String? weight; // e.g., "23 kg"

  @HiveField(13)
  String? tagNumber; // Luggage tag number

  @HiveField(14)
  List<String>? additionalPhotoPaths; // Multiple photos

  @HiveField(15)
  String? qrCodeData; // For QR code scanning (future feature)

  @HiveField(16)
  String? rfidTag; // For RFID tracking (future feature)

  @HiveField(17)
  Map<String, dynamic>? aiRecognitionData; // For AI features (future)

  /// Constructor
  Bag({
    required this.id,
    required this.tripId,
    required this.name,
    required this.type,
    required this.size,
    this.color,
    this.notes,
    this.photoPath,
    this.isVerified = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.verifiedAt,
    this.weight,
    this.tagNumber,
    this.additionalPhotoPaths,
    this.qrCodeData,
    this.rfidTag,
    this.aiRecognitionData,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Copy with method for creating modified copies
  Bag copyWith({
    String? id,
    String? tripId,
    String? name,
    BagType? type,
    BagSize? size,
    String? color,
    String? notes,
    String? photoPath,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? verifiedAt,
    String? weight,
    String? tagNumber,
    List<String>? additionalPhotoPaths,
    String? qrCodeData,
    String? rfidTag,
    Map<String, dynamic>? aiRecognitionData,
  }) {
    return Bag(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      name: name ?? this.name,
      type: type ?? this.type,
      size: size ?? this.size,
      color: color ?? this.color,
      notes: notes ?? this.notes,
      photoPath: photoPath ?? this.photoPath,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      weight: weight ?? this.weight,
      tagNumber: tagNumber ?? this.tagNumber,
      additionalPhotoPaths: additionalPhotoPaths ?? this.additionalPhotoPaths,
      qrCodeData: qrCodeData ?? this.qrCodeData,
      rfidTag: rfidTag ?? this.rfidTag,
      aiRecognitionData: aiRecognitionData ?? this.aiRecognitionData,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripId': tripId,
      'name': name,
      'type': type.name,
      'size': size.name,
      'color': color,
      'notes': notes,
      'photoPath': photoPath,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'verifiedAt': verifiedAt?.toIso8601String(),
      'weight': weight,
      'tagNumber': tagNumber,
      'additionalPhotoPaths': additionalPhotoPaths,
      'qrCodeData': qrCodeData,
      'rfidTag': rfidTag,
      'aiRecognitionData': aiRecognitionData,
    };
  }

  /// Create from JSON
  factory Bag.fromJson(Map<String, dynamic> json) {
    return Bag(
      id: json['id'],
      tripId: json['tripId'],
      name: json['name'],
      type: BagType.values.firstWhere((e) => e.name == json['type']),
      size: BagSize.values.firstWhere((e) => e.name == json['size']),
      color: json['color'],
      notes: json['notes'],
      photoPath: json['photoPath'],
      isVerified: json['isVerified'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      verifiedAt: json['verifiedAt'] != null
          ? DateTime.parse(json['verifiedAt'])
          : null,
      weight: json['weight'],
      tagNumber: json['tagNumber'],
      additionalPhotoPaths: json['additionalPhotoPaths'] != null
          ? List<String>.from(json['additionalPhotoPaths'])
          : null,
      qrCodeData: json['qrCodeData'],
      rfidTag: json['rfidTag'],
      aiRecognitionData: json['aiRecognitionData'] != null
          ? Map<String, dynamic>.from(json['aiRecognitionData'])
          : null,
    );
  }

  /// Get all photo paths including main and additional photos
  List<String> get allPhotoPaths {
    final paths = <String>[];
    if (photoPath != null) paths.add(photoPath!);
    if (additionalPhotoPaths != null) paths.addAll(additionalPhotoPaths!);
    return paths;
  }

  /// Check if bag has any photos
  bool get hasPhotos => photoPath != null ||
      (additionalPhotoPaths != null &&
          additionalPhotoPaths!.isNotEmpty);

  /// Get verification status as string
  String get verificationStatus => isVerified ? 'Verified' : 'Unverified';

  @override
  String toString() {
    return 'Bag(id: $id, name: $name, type: ${type.displayName}, '
        'size: ${size.displayName}, verified: $isVerified)';
  }
}