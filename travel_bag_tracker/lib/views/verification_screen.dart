import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/bag_controller.dart';
import '../models/trip.dart';
import '../models/bag.dart';
import '../utils/constants.dart';

/// Verification checklist screen for checking off bags before departure
class VerificationScreen extends StatelessWidget {
  final Trip trip;

  const VerificationScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Luggage'),
      ),
      body: Consumer<BagController>(
        builder: (context, bagController, child) {
          final bags = bagController.getBagsForTrip(trip.id);
          final verifiedBags = bagController.getVerifiedBagsForTrip(trip.id);
          final unverifiedBags = bagController.getUnverifiedBagsForTrip(trip.id);

          if (bags.isEmpty) {
            return _buildEmptyState();
          }

          return Column(
            children: [
              // Progress header
              _buildProgressHeader(verifiedBags.length, bags.length),

              // Verification list
              Expanded(
                child: ListView.builder(
                  padding: AppSpacing.paddingMD,
                  itemCount: bags.length,
                  itemBuilder: (context, index) {
                    final bag = bags[index];
                    return _buildVerificationItem(
                      context,
                      bag,
                      bagController,
                    );
                  },
                ),
              ),

              // Bottom action bar
              _buildBottomActionBar(
                context,
                bagController,
                bags.length,
                verifiedBags.length,
              ),
            ],
          );
        },
      ),
    );
  }

  /// Build progress header
  Widget _buildProgressHeader(int verified, int total) {
    final progress = total > 0 ? verified / total : 0.0;
    final isComplete = verified == total;

    return Container(
      padding: AppSpacing.paddingMD,
      decoration: BoxDecoration(
        color: isComplete
            ? AppColors.success.withOpacity(0.1)
            : AppColors.warning.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: isComplete ? AppColors.success : AppColors.warning,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Verification Progress',
                style: AppTextStyles.headline3,
              ),
              Text(
                '$verified/$total',
                style: AppTextStyles.headline3.copyWith(
                  color: isComplete ? AppColors.success : AppColors.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: AppRadius.radiusSM,
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(
                isComplete ? AppColors.success : AppColors.warning,
              ),
            ),
          ),
          if (isComplete) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                const Icon(Icons.check_circle, color: AppColors.success),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    AppMessages.allBagsVerified,
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Build verification item
  Widget _buildVerificationItem(
      BuildContext context,
      Bag bag,
      BagController controller,
      ) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: () async {
          await controller.toggleBagVerification(bag.id);
        },
        borderRadius: AppRadius.radiusLG,
        child: Padding(
          padding: AppSpacing.paddingMD,
          child: Row(
            children: [
              // Photo thumbnail
              if (bag.photoPath != null)
                ClipRRect(
                  borderRadius: AppRadius.radiusSM,
                  child: Image.file(
                    File(bag.photoPath!),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.border.withOpacity(0.3),
                    borderRadius: AppRadius.radiusSM,
                  ),
                  child: Icon(
                    Icons.luggage,
                    size: AppIconSize.lg,
                    color: AppColors.textSecondary,
                  ),
                ),

              const SizedBox(width: AppSpacing.md),

              // Bag info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bag.name,
                      style: AppTextStyles.subtitle1.copyWith(color: Colors.white), // Change color here
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Text(
                          bag.type.icon,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          '${bag.type.displayName} • ${bag.size.displayName}',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                    if (bag.color != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Color: ${bag.color}',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ],
                ),
              ),

              // Verification checkbox
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: bag.isVerified
                      ? AppColors.success
                      : AppColors.border.withOpacity(0.3),
                  border: Border.all(
                    color: bag.isVerified
                        ? AppColors.success
                        : AppColors.textSecondary,
                    width: 2,
                  ),
                ),
                child: bag.isVerified
                    ? const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20,
                )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build bottom action bar
  Widget _buildBottomActionBar(
      BuildContext context,
      BagController controller,
      int total,
      int verified,
      ) {
    final isComplete = verified == total;

    return Container(
      padding: AppSpacing.paddingMD,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isComplete)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // Verify all bags
                    for (final bag in controller.getBagsForTrip(trip.id)) {
                      if (!bag.isVerified) {
                        await controller.verifyBag(bag.id);
                      }
                    }
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('All bags verified!'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Verify All'),
                  style: ElevatedButton.styleFrom(
                    padding:
                    const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  ),
                ),
              ),
            if (verified > 0 && !isComplete) const SizedBox(height: AppSpacing.sm),
            if (verified > 0)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    // Unverify all bags
                    for (final bag in controller.getBagsForTrip(trip.id)) {
                      if (bag.isVerified) {
                        await controller.unverifyBag(bag.id);
                      }
                    }
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('All bags unverified'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset All'),
                  style: OutlinedButton.styleFrom(
                    padding:
                    const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingXL,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.checklist,
              size: AppIconSize.xxl * 2,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No bags to verify',
              textAlign: TextAlign.center,
              style: AppTextStyles.headline3.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Add bags to your trip first',
              textAlign: TextAlign.center,
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}