import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/trip_controller.dart';
import '../models/trip.dart';
import 'create_trip_screen.dart';
import 'capture_luggage_screen.dart';
import 'review_luggage_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TripController tripController = Get.put(TripController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Luggage Tracker'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Obx(() {
        if (tripController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (tripController.trips.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.luggage,
                  size: 100,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 20),
                Text(
                  'No trips yet!',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Create your first trip to get started',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: tripController.trips.length,
          itemBuilder: (context, index) {
            final trip = tripController.trips[index];
            return TripCard(trip: trip);
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => const CreateTripScreen());
        },
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add),
        label: const Text('New Trip'),
      ),
    );
  }
}

class TripCard extends StatelessWidget {
  final Trip trip;

  const TripCard({Key? key, required this.trip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TripController tripController = Get.find();

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          tripController.setCurrentTrip(trip);

          if (trip.isCompleted) {
            // Go to review screen
            Get.to(() => ReviewLuggageScreen(tripId: trip.id!));
          } else {
            // Go to capture screen
            Get.to(() => CaptureLuggageScreen(tripId: trip.id!));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: trip.isCompleted ? Colors.green[100] : Colors.blue[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      trip.isCompleted ? Icons.check_circle : Icons.flight_takeoff,
                      color: trip.isCompleted ? Colors.green[700] : Colors.blue[700],
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              trip.destination,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'delete') {
                        _showDeleteDialog(context, trip.id!);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Chip(
                    label: Text(
                      trip.isCompleted ? 'Completed' : 'In Progress',
                      style: TextStyle(
                        fontSize: 12,
                        color: trip.isCompleted ? Colors.green[700] : Colors.blue[700],
                      ),
                    ),
                    backgroundColor: trip.isCompleted ? Colors.green[100] : Colors.blue[100],
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  const SizedBox(width: 8),
                  FutureBuilder<int>(
                    future: tripController.getLuggageCount(trip.id!),
                    builder: (context, snapshot) {
                      final count = snapshot.data ?? 0;
                      return Chip(
                        avatar: const Icon(Icons.luggage, size: 16),
                        label: Text(
                          '$count bag${count != 1 ? 's' : ''}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: Colors.grey[200],
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int tripId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Trip'),
        content: const Text('Are you sure you want to delete this trip? This will also delete all luggage photos.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.find<TripController>().deleteTrip(tripId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}