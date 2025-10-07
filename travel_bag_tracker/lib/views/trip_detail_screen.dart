import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../controllers/trip_controller.dart';
import '../controllers/bag_controller.dart';
import '../models/trip.dart';
import '../models/bag.dart';
import '../utils/constants.dart';
import '../widgets/bag_card.dart';
import 'new_trip_screen.dart';
import 'add_bag_screen.dart';
import 'verification_screen.dart';

/// Trip details screen showing all bags and trip information
class TripDetailsScreen extends StatelessWidget {
  final Trip trip;

  const TripDetailsScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          trip.name,
          style: const TextStyle(color: Colors.white), // Set text color to white
        ),
        actions: [
          // Edit trip
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewTripScreen(tripToEdit: trip),
                ),
              );
            },
          ),
          // Delete trip
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
      ),
      body: Consumer<BagController>(
        builder: (context, bagController, child) {
          final bags = bagController.getBagsForTrip(trip.id);
          final verifiedBags = bagController.getVerifiedBagsForTrip(trip.id);
          final unverifiedBags = bagController.getUnverifiedBagsForTrip(trip.id);

          return Column(
            children: [
              // Trip info header
              _buildTripInfoCard(context, bags.length, verifiedBags.length),

              // Verification status
              if (bags.isNotEmpty)
                _buildVerificationBanner(
                  context,
                  verifiedBags.length,
                  bags.length,
                ),

              // Bags list
              Expanded(
                child: bags.isEmpty
                    ? _buildEmptyState(context)
                    : RefreshIndicator(
                  onRefresh: () async {
                    await bagController.refresh();
                  },
                  child: ListView.builder(
                    padding: AppSpacing.paddingMD,
                    itemCount: bags.length,
                    itemBuilder: (context, index) {
                      return BagCard(
                        bag: bags[index],
                        onTap: () => _showBagDetails(context, bags[index]),
                        onVerifyToggle: () async {
                          await bagController.toggleBagVerification(
                            bags[index].id,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Verification checklist button
          Consumer<BagController>(
            builder: (context, bagController, child) {
              final bags = bagController.getBagsForTrip(trip.id);
              if (bags.isEmpty) return const SizedBox.shrink();

              return FloatingActionButton(
                heroTag: 'verify',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VerificationScreen(trip: trip),
                    ),
                  );
                },
                child: const Icon(Icons.checklist),
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          // Add bag button
          FloatingActionButton.extended(
            heroTag: 'add_bag',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddBagScreen(trip: trip),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Bag'),
          ),
        ],
      ),
    );
  }

  /// Build trip info card
  Widget _buildTripInfoCard(BuildContext context, int totalBags, int verifiedBags) {
    return Card(
      margin: AppSpacing.paddingMD,
      child: Padding(
        padding: AppSpacing.paddingMD,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip type and status
            Row(
              children: [
                Text(
                  trip.type.icon,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip.name,
                        style: AppTextStyles.headline3.copyWith(color: Colors.white), // Change here
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          _buildStatusChip(trip.status),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            trip.type.displayName,
                            style: AppTextStyles.caption.copyWith(color: Colors.white70), // Change here
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: AppSpacing.lg),

            // Destination info
            if (trip.destination != null)
              _buildInfoRow(Icons.location_on, 'Destination', trip.destination!),
            if (trip.departureLocation != null)
              _buildInfoRow(
                Icons.flight_takeoff,
                'Departure',
                trip.departureLocation!,
              ),
            if (trip.transportNumber != null)
              _buildInfoRow(
                Icons.confirmation_number,
                '${trip.type.displayName} Number',
                trip.transportNumber!,
              ),

            // Dates
            _buildInfoRow(
              Icons.calendar_today,
              'Start',
              DateFormat('MMM dd, yyyy - hh:mm a').format(trip.startDate),
            ),
            if (trip.endDate != null)
              _buildInfoRow(
                Icons.event,
                'End',
                DateFormat('MMM dd, yyyy - hh:mm a').format(trip.endDate!),
              ),

            // Notes
            if (trip.notes != null && trip.notes!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Notes:',
                style: AppTextStyles.subtitle2.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Change here
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                trip.notes!,
                style: AppTextStyles.body2.copyWith(color: Colors.white), // Change here
              ),
            ],

            const Divider(height: AppSpacing.lg),

            // Bag statistics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Total Bags', totalBags.toString(), Icons.luggage),
                _buildStatItem(
                  'Verified',
                  verifiedBags.toString(),
                  Icons.check_circle,
                  color: AppColors.verified,
                ),
                _buildStatItem(
                  'Unverified',
                  (totalBags - verifiedBags).toString(),
                  Icons.warning,
                  color: AppColors.unverified,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build status chip
  Widget _buildStatusChip(String status) {
    Color color;
    if (status == 'Upcoming') {
      color = AppColors.upcoming;
    } else if (status == 'Ongoing') {
      color = AppColors.ongoing;
    } else {
      color = AppColors.completed;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppRadius.radiusSM,
        border: Border.all(color: color),
      ),
      child: Text(
        status,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Build info row
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: AppIconSize.sm, color: Colors.white70), // Adjusted icon color
          const SizedBox(width: AppSpacing.sm),
          Text(
            '$label: ',
            style: AppTextStyles.body2.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white, // Change here
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.body2.copyWith(color: Colors.white), // Change here
            ),
          ),
        ],
      ),
    );
  }

  /// Build stat item
  Widget _buildStatItem(String label, String value, IconData icon, {Color? color}) {
    return Column(
      children: [
        Icon(icon, size: AppIconSize.lg, color: color ?? Colors.white), // Adjusted icon color
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTextStyles.headline2.copyWith(color: color ?? Colors.white), // Change here
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: Colors.white70), // Change here
        ),
      ],
    );
  }

  /// Build verification banner
  Widget _buildVerificationBanner(
      BuildContext context, int verified, int total) {
    final isAllVerified = verified == total;
    final color = isAllVerified ? AppColors.success : AppColors.warning;
    final message = isAllVerified
        ? AppMessages.allBagsVerified
        : 'Verified: $verified/$total bags';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: AppSpacing.paddingMD,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppRadius.radiusMD,
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(
            isAllVerified ? Icons.check_circle : Icons.warning,
            color: color,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.body2.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingXL,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.luggage,
              size: AppIconSize.xxl * 2,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              AppMessages.noBagsYet,
              textAlign: TextAlign.center,
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show bag details
  void _showBagDetails(BuildContext context, Bag bag) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return _buildBagDetailsSheet(context, bag, scrollController);
        },
      ),
    );
  }

  /// Build bag details bottom sheet
  Widget _buildBagDetailsSheet(
      BuildContext context, Bag bag, ScrollController scrollController) {
    return Container(
      padding: AppSpacing.paddingMD,
      child: ListView(
        controller: scrollController,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withOpacity(0.3),
                borderRadius: AppRadius.radiusSM,
              ),
            ),
          ),

          // Bag details
          Text(
            bag.name,
            style: AppTextStyles.headline2.copyWith(color: Colors.white), // Change here
          ),
          const SizedBox(height: AppSpacing.md),

          // Photo
          if (bag.photoPath != null)
            ClipRRect(
              borderRadius: AppRadius.radiusMD,
              child: Image.file(
                File(bag.photoPath!),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: AppSpacing.md),

          // Details
          _buildDetailItem('Type', '${bag.type.icon} ${bag.type.displayName}'),
          _buildDetailItem('Size', bag.size.displayName),
          if (bag.color != null) _buildDetailItem('Color', bag.color!),
          if (bag.weight != null) _buildDetailItem('Weight', bag.weight!),
          if (bag.tagNumber != null)
            _buildDetailItem('Tag Number', bag.tagNumber!),
          if (bag.notes != null) _buildDetailItem('Notes', bag.notes!),

          _buildDetailItem(
            'Status',
            bag.isVerified ? '✓ Verified' : '⚠ Unverified',
          ),

          const SizedBox(height: AppSpacing.lg),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddBagScreen(
                          trip: trip,
                          bagToEdit: bag,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text(
                    'Edit',
                    style: TextStyle(color: Colors.white), // Change here
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showDeleteBagDialog(context, bag);
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.white), // Change here
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: AppTextStyles.body2.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white, // Label text is set to white here
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.body2.copyWith(
                color: Colors.white, // Value text is set to white here
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show delete trip dialog
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Trip'),
        content: Text(
          'Are you sure you want to delete "${trip.name}"? All associated bags will also be deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final tripController =
              Provider.of<TripController>(context, listen: false);
              final success = await tripController.deleteTrip(trip.id);

              if (context.mounted) {
                Navigator.pop(context); // Close dialog
                if (success) {
                  Navigator.pop(context); // Close details screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(AppMessages.tripDeleted),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  /// Show delete bag dialog
  void _showDeleteBagDialog(BuildContext context, Bag bag) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Bag'),
        content: Text('Are you sure you want to delete "${bag.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final bagController =
              Provider.of<BagController>(context, listen: false);
              final success = await bagController.deleteBag(bag.id);

              if (context.mounted) {
                Navigator.pop(context);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(AppMessages.bagDeleted),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

