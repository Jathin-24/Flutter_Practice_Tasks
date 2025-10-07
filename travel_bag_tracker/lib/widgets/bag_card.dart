import 'package:flutter/material.dart';
import '../models/bag.dart';
import '../utils/constants.dart';

/// A card widget to display summary information about a single bag.
///
/// Provides visual feedback on verification status and handles tap and
/// verification toggle events.
class BagCard extends StatelessWidget {
  final Bag bag;
  final VoidCallback onTap;
  final VoidCallback onVerifyToggle;

  const BagCard({
    super.key,
    required this.bag,
    required this.onTap,
    required this.onVerifyToggle,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the color and icon based on the verification status
    final statusColor = bag.isVerified ? AppColors.verified : AppColors.unverified;
    final statusIcon = bag.isVerified ? Icons.check_circle : Icons.radio_button_unchecked;
    final statusText = bag.isVerified ? 'Verified' : 'Unverified';

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.radiusMD,
        child: Padding(
          padding: AppSpacing.paddingMD,
          child: Row(
            children: [
              // Bag Type Icon
              CircleAvatar(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  bag.type.icon,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Bag Name and Type
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bag.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${bag.type.displayName} • ${bag.size.displayName}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Verification Status and Toggle Button
              InkWell(
                onTap: onVerifyToggle,
                borderRadius: AppRadius.radiusLG,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: AppRadius.radiusLG,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, color: statusColor, size: AppIconSize.sm),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        statusText,
                        style: AppTextStyles.caption.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
