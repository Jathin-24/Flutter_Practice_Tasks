import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import '../controllers/luggage_controller.dart';
import '../controllers/trip_controller.dart';
import '../models/luggage_item.dart';
import 'summary_screen.dart';

class ReviewLuggageScreen extends StatefulWidget {
  final int tripId;

  const ReviewLuggageScreen({Key? key, required this.tripId}) : super(key: key);

  @override
  State<ReviewLuggageScreen> createState() => _ReviewLuggageScreenState();
}

class _ReviewLuggageScreenState extends State<ReviewLuggageScreen> {
  final LuggageController luggageController = Get.put(LuggageController());
  final AppinioSwiperController swiperController = AppinioSwiperController();

  @override
  void initState() {
    super.initState();
    luggageController.loadLuggageItems(widget.tripId);
  }

  @override
  void dispose() {
    swiperController.dispose();
    super.dispose();
  }

  void _onSwipe(int index, AxisDirection direction) {
    if (index < luggageController.luggageItems.length) {
      final item = luggageController.luggageItems[index];
      final isPresent = direction == AxisDirection.right;

      luggageController.updateLuggageStatus(item.id!, isPresent);

      // Check if all items are reviewed
      if (index == luggageController.luggageItems.length - 1) {
        _showCompletionDialog();
      }
    }
  }


  void _markAsPresent() {
    swiperController.swipeRight();
  }

  void _markAsMissing() {
    swiperController.swipeLeft();
  }

  void _showCompletionDialog() {
    Future.delayed(const Duration(milliseconds: 500), () {
      Get.dialog(
        AlertDialog(
          title: const Text('Review Complete!'),
          content: const Text('You have reviewed all your luggage. Would you like to see the summary?'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                Get.back(); // Go back to home
              },
              child: const Text('Later'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                // Mark trip as completed
                Get.find<TripController>().completeTrip(widget.tripId);
                // Go to summary
                Get.off(() => SummaryScreen(tripId: widget.tripId));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('View Summary'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Luggage'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  title: const Text('Reset Reviews?'),
                  content: const Text('This will clear all your review decisions.'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                        luggageController.resetReviews(widget.tripId);
                        setState(() {
                          // Rebuild to reset swiper
                        });
                      },
                      child: const Text('Reset', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (luggageController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (luggageController.luggageItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No luggage to review',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }

        // Filter unreviewed items
        final unreviewedItems = luggageController.luggageItems
            .where((item) => item.isPresent == null)
            .toList();

        if (unreviewedItems.isEmpty) {
          // All reviewed - show summary button
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, size: 100, color: Colors.green[400]),
                const SizedBox(height: 20),
                const Text(
                  'All luggage reviewed!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.find<TripController>().completeTrip(widget.tripId);
                    Get.off(() => SummaryScreen(tripId: widget.tripId));
                  },
                  icon: const Icon(Icons.summarize),
                  label: const Text('View Summary'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Instructions
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.blue[50],
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.swipe_left, color: Colors.red[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Swipe Left = Missing',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Icon(Icons.swipe_right, color: Colors.green[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Swipe Right = Present',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Obx(() {
                    final reviewed = luggageController.getReviewedCount();
                    final total = luggageController.luggageItems.length;
                    return Text(
                      'Progress: $reviewed / $total bags reviewed',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Swipeable Cards
            Expanded(
              child: Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: AppinioSwiper(
                    controller: swiperController,
                    cardCount: unreviewedItems.length,
                    cardBuilder: (BuildContext context, int index) {
                      final item = unreviewedItems[index];
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: _buildCard(item),
                      );
                    },
                    // ✅ Updated callback
                    onSwipeEnd: (int previousIndex, int targetIndex, SwiperActivity activity) {
                      final swipedItem = unreviewedItems[previousIndex];
                      final globalIndex = luggageController.luggageItems.indexOf(swipedItem);

                      // Now pass the AxisDirection instead
                      _onSwipe(globalIndex, activity.direction);
                    },
                    onEnd: () {
                      _showCompletionDialog();
                    },
                  ),
                ),
              ),
            ),


            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Missing Button
                  FloatingActionButton.extended(
                    onPressed: _markAsMissing,
                    backgroundColor: Colors.red,
                    heroTag: 'missing',
                    icon: const Icon(Icons.close, color: Colors.white),
                    label: const Text(
                      'Missing',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Present Button
                  FloatingActionButton.extended(
                    onPressed: _markAsPresent,
                    backgroundColor: Colors.green,
                    heroTag: 'present',
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: const Text(
                      'Present',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCard(LuggageItem item) {
    final index = luggageController.luggageItems.indexOf(item) + 1;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue[200]!, width: 3),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(17),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image
              Image.file(
                File(item.imagePath),
                fit: BoxFit.cover,
              ),

              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: const [0.6, 1.0],
                  ),
                ),
              ),

              // Bag Number Badge
              Positioned(
                top: 20,
                left: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'Bag $index',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Bottom Info
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Is this bag present?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.swipe,
                          color: Colors.white.withOpacity(0.8),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Swipe or tap buttons below',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}