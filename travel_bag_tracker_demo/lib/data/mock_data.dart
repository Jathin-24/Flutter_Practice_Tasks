import '../models/trip.dart';
import '../models/bag.dart';
import '../models/notification.dart';

class MockData {
  static List<Trip> get trips {
    final now = DateTime.now();
    return [
      Trip(
        id: '1',
        name: 'Paris Adventure',
        type: 'flight',
        startDate: now.add(const Duration(days: 5)),
        endDate: now.add(const Duration(days: 12)),
        destination: 'Paris, France',
        notes: 'Romantic getaway to the City of Light',
      ),
      Trip(
        id: '2',
        name: 'Business Trip NYC',
        type: 'flight',
        startDate: now.add(const Duration(days: 2)),
        endDate: now.add(const Duration(days: 4)),
        destination: 'New York City, NY',
        notes: 'Important client meetings',
      ),
      Trip(
        id: '3',
        name: 'Beach Vacation',
        type: 'flight',
        startDate: now.add(const Duration(days: 15)),
        endDate: now.add(const Duration(days: 22)),
        destination: 'Bali, Indonesia',
        notes: 'Sun, sand, and relaxation',
      ),
      Trip(
        id: '4',
        name: 'Road Trip',
        type: 'car',
        startDate: now.add(const Duration(days: 30)),
        endDate: now.add(const Duration(days: 37)),
        destination: 'California Coast',
        notes: 'Epic Pacific Coast Highway adventure',
      ),
      Trip(
        id: '5',
        name: 'European Rail Tour',
        type: 'train',
        startDate: now.subtract(const Duration(days: 7)),
        endDate: now.subtract(const Duration(days: 1)),
        destination: 'Multiple European Cities',
        notes: 'Amazing train journey through Europe',
      ),
    ];
  }

  static List<Bag> get bags {
    return [
      // Paris Adventure bags
      Bag(
        id: 'b1',
        tripId: '1',
        name: 'Main Suitcase',
        type: 'checked',
        color: 'Black',
        size: 'Large',
        description: 'Large rolling suitcase for main clothes',
        notes: 'Contains formal wear and shoes',
        imagePaths: ['assets/images/suitcase1.jpg'],
      ),
      Bag(
        id: 'b2',
        tripId: '1',
        name: 'Carry-on',
        type: 'carry-on',
        color: 'Navy Blue',
        size: 'Medium',
        description: 'Compact carry-on with essentials',
        notes: 'Laptop, chargers, and documents',
        isVerified: true,
        lastVerifiedAt: DateTime.now().subtract(const Duration(hours: 2)),
        imagePaths: ['assets/images/carryon1.jpg'],
      ),

      // Business Trip NYC bags
      Bag(
        id: 'b3',
        tripId: '2',
        name: 'Business Briefcase',
        type: 'personal',
        color: 'Brown',
        size: 'Small',
        description: 'Leather briefcase for business documents',
        notes: 'Important contracts and presentations',
        isVerified: true,
        lastVerifiedAt: DateTime.now().subtract(const Duration(minutes: 30)),
        imagePaths: ['assets/images/briefcase1.jpg'],
      ),

      // Beach Vacation bags
      Bag(
        id: 'b4',
        tripId: '3',
        name: 'Beach Bag',
        type: 'personal',
        color: 'Turquoise',
        size: 'Medium',
        description: 'Waterproof bag for beach essentials',
        notes: 'Swimwear, sunscreen, and towels',
        imagePaths: ['assets/images/beachbag1.jpg'],
      ),
      Bag(
        id: 'b5',
        tripId: '3',
        name: 'Vacation Suitcase',
        type: 'checked',
        color: 'Pink',
        size: 'Large',
        description: 'Colorful suitcase for vacation clothes',
        notes: 'Summer clothes and accessories',
        imagePaths: ['assets/images/suitcase2.jpg'],
      ),

      // Road Trip bags
      Bag(
        id: 'b6',
        tripId: '4',
        name: 'Travel Backpack',
        type: 'backpack',
        color: 'Gray',
        size: 'Large',
        description: 'Hiking backpack for road trip',
        notes: 'Outdoor gear and camping supplies',
        imagePaths: ['assets/images/backpack1.jpg'],
      ),

      // European Rail Tour bags
      Bag(
        id: 'b7',
        tripId: '5',
        name: 'Rail Travel Case',
        type: 'carry-on',
        color: 'Green',
        size: 'Medium',
        description: 'Compact case perfect for train travel',
        notes: 'Easy to carry between stations',
        isVerified: true,
        lastVerifiedAt: DateTime.now().subtract(const Duration(days: 2)),
        imagePaths: ['assets/images/railcase1.jpg'],
      ),
    ];
  }

  static List<AppNotification> get notifications {
    final now = DateTime.now();
    return [
      AppNotification(
        id: 'n1',
        title: 'Trip Reminder',
        body: 'Your Paris Adventure starts in 5 days! Time to start packing.',
        type: 'reminder',
        scheduledFor: now.add(const Duration(hours: 1)),
        tripId: '1',
      ),
      AppNotification(
        id: 'n2',
        title: 'Bag Verification',
        body: 'Please verify your Main Suitcase for the Paris trip.',
        type: 'verification',
        scheduledFor: now.add(const Duration(minutes: 30)),
        tripId: '1',
        bagId: 'b1',
      ),
      AppNotification(
        id: 'n3',
        title: 'Check-in Reminder',
        body: 'Don\'t forget to check in for your NYC business trip!',
        type: 'reminder',
        scheduledFor: now.add(const Duration(hours: 6)),
        tripId: '2',
        isRead: true,
      ),
      AppNotification(
        id: 'n4',
        title: 'Weather Alert',
        body: 'Rain expected in Paris during your trip. Pack an umbrella!',
        type: 'info',
        scheduledFor: now.subtract(const Duration(hours: 2)),
        tripId: '1',
        isRead: true,
      ),
      AppNotification(
        id: 'n5',
        title: 'Document Reminder',
        body: 'Remember to pack your passport for international travel.',
        type: 'reminder',
        scheduledFor: now.add(const Duration(days: 1)),
        tripId: '3',
      ),
    ];
  }

  // Statistics
  static Map<String, int> get tripStats {
    final trips = MockData.trips;
    return {
      'total': trips.length,
      'active': trips.where((t) => t.status == 'Active').length,
      'upcoming': trips.where((t) => t.status == 'Upcoming').length,
      'completed': trips.where((t) => t.status == 'Completed').length,
    };
  }

  static Map<String, int> get bagStats {
    final bags = MockData.bags;
    return {
      'total': bags.length,
      'verified': bags.where((b) => !b.needsVerification).length,
      'unverified': bags.where((b) => b.needsVerification).length,
      'withPhotos': bags.where((b) => b.imagePaths.isNotEmpty).length,
    };
  }

  static Map<String, int> get notificationStats {
    final notifications = MockData.notifications;
    return {
      'total': notifications.length,
      'unread': notifications.where((n) => !n.isRead).length,
      'overdue': notifications.where((n) => n.isOverdue).length,
    };
  }
}