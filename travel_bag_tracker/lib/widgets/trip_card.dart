import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/trip.dart';
import '../utils/constants.dart';

/// A card widget to display a summary of a trip.
///
/// Shows key details like name, destination, and dates, along with an
/// icon representing the trip type. Handles tap events to navigate.
class TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback onTap;

  const TripCard({
    super.key,
    required this.trip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.radiusMD,
        child: Padding(
          padding: AppSpacing.paddingMD,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header with Trip Name and Icon ---
              Row(
                children: [
                  Text(
                    trip.type.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      trip.name,
                      style:TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white, // Add this line to change the color
                    ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              const Divider(),
              const SizedBox(height: AppSpacing.md),

              // --- Destination Info ---
              if (trip.destination != null && trip.destination!.isNotEmpty)
                _buildInfoRow(
                  icon: Icons.location_on_outlined,
                  text: trip.destination!,
                ),

              // --- Date Info ---
              _buildInfoRow(
                icon: Icons.calendar_today_outlined,
                text: _formatDateRange(trip.startDate, trip.endDate),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper to format the date range string.
  String _formatDateRange(DateTime start, DateTime? end) {
    final formattedStart = DateFormat('MMM d, yyyy').format(start);
    if (end == null || start.isAtSameMomentAs(end)) {
      return formattedStart;
    }
    final formattedEnd = DateFormat('MMM d, yyyy').format(end);
    return '$formattedStart - $formattedEnd';
  }

  /// Helper to build a consistent row with an icon and text.
  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppIconSize.sm,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.body2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
