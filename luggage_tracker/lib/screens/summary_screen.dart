import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/luggage_controller.dart';
import '../controllers/trip_controller.dart';
import '../models/luggage_item.dart';

class SummaryScreen extends StatelessWidget {
  final int tripId;

  const SummaryScreen({Key? key, required this.tripId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LuggageController luggageController = Get.find();
    final TripController tripController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Summary'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        final presentItems = luggageController.getPresentItems();
        final missingItems = luggageController.getMissingItems();
        final totalItems = luggageController.luggageItems.length;

        return SingleChildScrollView(
          child: Column(
            children: [
              // Header Stats
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[700]!, Colors.blue[500]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      const Icon(
                        Icons.summarize,
                        size: 60,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Luggage Check Complete',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatCard(
                            'Total',
                            totalItems.toString(),
                            Icons.luggage,
                            Colors.white,
                          ),
                          _buildStatCard(
                            'Present',
                            presentItems.length.toString(),
                            Icons.check_circle,
                            Colors.green[300]!,
                          ),
                          _buildStatCard(
                            'Missing',
                            missingItems.length.toString(),
                            Icons.cancel,
                            Colors.red[300]!,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Present Bags Section
              if (presentItems.isNotEmpty) ...[
                _buildSectionHeader(
                  '✓ Present Bags',
                  presentItems.length,
                  Colors.green,
                ),
                _buildImageGrid(presentItems),
              ],

              // Missing Bags Section
              if (missingItems.isNotEmpty) ...[
                _buildSectionHeader(
                  '✗ Missing Bags',
                  missingItems.length,
                  Colors.red,
                ),
                _buildImageGrid(missingItems),
              ],

              // All Good Message
              if (missingItems.isEmpty) ...[
                Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green[200]!, width: 2),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.celebration,
                        size: 60,
                        color: Colors.green[700],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'All Bags Present!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[900],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Great! All your luggage made it safely.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],

              // Warning Message
              if (missingItems.isNotEmpty) ...[
                Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.red[200]!, width: 2),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning,
                        size: 40,
                        color: Colors.red[700],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bags Missing',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red[900],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Please report to baggage claim or airline staff.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.red[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.dialog(
                            AlertDialog(
                              title: const Text('Review Again?'),
                              content: const Text(
                                'This will reset all your review decisions and you can check your luggage again.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                    luggageController.resetReviews(tripId);
                                    Get.back();
                                  },
                                  child: const Text('Review Again'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Review Again'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.back();
                          Get.back();
                        },
                        icon: const Icon(Icons.home),
                        label: const Text('Back to Home'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 16),
      color: color.withOpacity(0.1),
      child: Row(
        children: [
          Icon(
            count > 0 ? Icons.check_circle : Icons.cancel,
            color: color.withRed(700),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color.withRed(900),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withGreen(700),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid(List<LuggageItem> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final bagNumber = Get.find<LuggageController>()
            .luggageItems
            .indexOf(item) + 1;

        return GestureDetector(
          onTap: () {
            _showImageDialog(Get.context!, item.imagePath, bagNumber);
          },
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(item.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 4,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Bag $bagNumber',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showImageDialog(BuildContext context, String imagePath, int bagNumber) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue,
              child: Row(
                children: [
                  Text(
                    'Bag $bagNumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Image.file(File(imagePath)),
          ],
        ),
      ),
    );
  }
}