class Bag {
  final String id;
  final String tripId;
  final String name;
  final String type;
  final String? color;
  final String? size;
  final String? description;
  final List<String> imagePaths;
  final bool isVerified;
  final DateTime? lastVerifiedAt;
  final String? notes;
  final DateTime createdAt;

  Bag({
    required this.id,
    required this.tripId,
    required this.name,
    required this.type,
    this.color,
    this.size,
    this.description,
    List<String>? imagePaths,
    this.isVerified = false,
    this.lastVerifiedAt,
    this.notes,
    DateTime? createdAt,
  })  : imagePaths = imagePaths ?? [],
        createdAt = createdAt ?? DateTime.now();

  String? get primaryImage => imagePaths.isNotEmpty ? imagePaths.first : null;

  bool get needsVerification {
    if (!isVerified || lastVerifiedAt == null) return true;
    return DateTime.now().difference(lastVerifiedAt!).inHours > 24;
  }

  String get verificationStatus {
    if (!isVerified) return 'Not Verified';
    if (needsVerification) return 'Needs Re-verification';
    return 'Verified';
  }
}