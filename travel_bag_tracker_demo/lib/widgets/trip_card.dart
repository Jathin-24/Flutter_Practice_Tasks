import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';

import '../models/trip.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';

class TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback? onTap;

  const TripCard({
    Key? key,
    required this.trip,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bags = MockData.bags.where((b) => b.tripId == trip.id).toList();
    final verifiedBags = bags.where((b) => !b.needsVerification).length;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _getStatusGradient(),
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getTripIcon(),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trip.name,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1F2937),
                            ),
                          ),
                          if (trip.destination != null)
                            Text(
                              trip.destination!,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        trip.status.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 16,
                      color: const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 8),
                    // Text(
                    //   '${DateFormat('MMM dd').format(trip.startDate)} - ${DateFormat('MMM dd, yyyy').format(trip.endDate)}',
                    //   style: GoogleFonts.inter(
                    //     fontSize: 14,
                    //     color: const Color(0xFF6B7280),
                    //   ),
                    // ),
                    const Spacer(),
                    Text(
                      '${trip.durationInDays} days',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF374151),
                      ),
                    ),
                  ],
                ),
                if (bags.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.luggage_rounded,
                          size: 18,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${bags.length} bags',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF374151),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.verified_rounded,
                          size: 16,
                          color: verifiedBags == bags.length
                              ? Colors.green
                              : Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$verifiedBags verified',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: verifiedBags == bags.length
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (trip.notes != null && trip.notes!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    trip.notes!,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF6B7280),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getTripIcon() {
    switch (trip.type.toLowerCase()) {
      case 'flight':
        return Icons.flight_rounded;
      case 'train':
        return Icons.train_rounded;
      case 'car':
        return Icons.directions_car_rounded;
      case 'bus':
        return Icons.directions_bus_rounded;
      default:
        return Icons.luggage_rounded;
    }
  }

  Color _getStatusColor() {
    switch (trip.status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'upcoming':
        return AppTheme.primaryColor;
      case 'completed':
        return const Color(0xFF6B7280);
      default:
        return Colors.red;
    }
  }

  List<Color> _getStatusGradient() {
    switch (trip.status.toLowerCase()) {
      case 'active':
        return AppTheme.successGradient;
      case 'upcoming':
        return AppTheme.primaryGradient;
      case 'completed':
        return [const Color(0xFF6B7280), const Color(0xFF4B5563)];
      default:
        return AppTheme.errorGradient;
    }
  }
}