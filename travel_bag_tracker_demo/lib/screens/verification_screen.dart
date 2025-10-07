import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/animated_counter.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  @override
  Widget build(BuildContext context) {
    final bags = MockData.bags;
    final unverifiedBags = bags.where((bag) => bag.needsVerification).toList();
    final verifiedBags = bags.where((bag) => !bag.needsVerification).toList();
    final verificationRate = bags.isEmpty ? 0.0 : verifiedBags.length / bags.length;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(verificationRate),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildVerificationSummary(bags, unverifiedBags, verificationRate),
                const SizedBox(height: 32),
                if (unverifiedBags.isNotEmpty) ...[
                  _buildUnverifiedSection(unverifiedBags),
                  const SizedBox(height: 32),
                ],
                if (verifiedBags.isNotEmpty)
                  _buildVerifiedSection(verifiedBags),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(double verificationRate) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: verificationRate == 1.0
                  ? AppTheme.successGradient
                  : AppTheme.warningGradient,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FadeInDown(
                    duration: const Duration(milliseconds: 800),
                    child: Text(
                      'Bag Verification',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeInDown(
                    duration: const Duration(milliseconds: 1000),
                    child: Row(
                      children: [
                        Icon(
                          verificationRate == 1.0
                              ? Icons.verified_rounded
                              : Icons.schedule_rounded,
                          color: Colors.white.withOpacity(0.9),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          verificationRate == 1.0
                              ? 'All bags verified!'
                              : 'Verification in progress',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerificationSummary(
      List<dynamic> bags,
      List<dynamic> unverifiedBags,
      double verificationRate
      ) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: verificationRate == 1.0
                ? AppTheme.successGradient
                : AppTheme.primaryGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: (verificationRate == 1.0
                  ? Colors.green
                  : AppTheme.primaryColor).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    verificationRate == 1.0
                        ? Icons.verified_rounded
                        : Icons.analytics_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Verification Overview',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      AnimatedCounter(
                        value: bags.length - unverifiedBags.length,
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Verified',
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.white.withOpacity(0.3),
                ),
                Expanded(
                  child: Column(
                    children: [
                      AnimatedCounter(
                        value: unverifiedBags.length,
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Pending',
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.white.withOpacity(0.3),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '${(verificationRate * 100).toInt()}%',
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Complete',
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: verificationRate,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnverifiedSection(List<dynamic> unverifiedBags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInUp(
          duration: const Duration(milliseconds: 800),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Needs Verification (${unverifiedBags.length})',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
              ),
              CustomButton(
                text: 'Verify All',
                onPressed: () => _showVerifyAllDialog(unverifiedBags.length),
                gradientColors: AppTheme.successGradient,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AnimationLimiter(
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 600),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: unverifiedBags.map((bag) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _BagVerificationCard(
                  bag: bag,
                  isVerified: false,
                  onVerify: () => _verifyBag(bag.name),
                ),
              )).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerifiedSection(List<dynamic> verifiedBags) {
    return FadeInUp(
      duration: const Duration(milliseconds: 1000),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Verified Bags (${verifiedBags.length})',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          ...verifiedBags.map((bag) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _BagVerificationCard(
              bag: bag,
              isVerified: true,
              onVerify: null,
            ),
          )).toList(),
        ],
      ),
    );
  }

  void _verifyBag(String bagName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$bagName verified successfully!',
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showVerifyAllDialog(int count) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Verify All Bags',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to verify all $count bags? Make sure you have physically checked each bag.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.inter()),
          ),
          CustomButton(
            text: 'Verify All',
            onPressed: () {
              Navigator.pop(context);
              _verifyBag('All bags');
            },
            gradientColors: AppTheme.successGradient,
          ),
        ],
      ),
    );
  }
}

class _BagVerificationCard extends StatelessWidget {
  final dynamic bag;
  final bool isVerified;
  final VoidCallback? onVerify;

  const _BagVerificationCard({
    required this.bag,
    required this.isVerified,
    this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    final trip = MockData.trips.firstWhere((t) => t.id == bag.tripId);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isVerified ? Colors.green.withOpacity(0.3) : Colors.orange.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isVerified
                        ? AppTheme.successGradient
                        : AppTheme.warningGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isVerified ? Icons.verified_rounded : Icons.schedule_rounded,
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
                      bag.name,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      'Trip: ${trip.name}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              if (isVerified)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 14,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'VERIFIED',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                )
              else
                CustomButton(
                  text: 'Verify',
                  onPressed: onVerify,
                  gradientColors: AppTheme.successGradient,
                  icon: Icons.verified_rounded,
                ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(
                  'Type: ${bag.type.toUpperCase()}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF374151),
                  ),
                ),
                if (bag.color != null) ...[
                  const SizedBox(width: 16),
                  Text(
                    'Color: ${bag.color}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
                const Spacer(),
                Icon(
                  Icons.camera_alt_rounded,
                  size: 14,
                  color: const Color(0xFF6B7280),
                ),
                const SizedBox(width: 4),
                Text(
                  '${bag.imagePaths.length} photos',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}