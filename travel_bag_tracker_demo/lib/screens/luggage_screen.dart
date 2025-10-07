import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../models/trip.dart';
import '../models/bag.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';

class LuggageScreen extends StatefulWidget {
  final Trip trip;

  const LuggageScreen({Key? key, required this.trip}) : super(key: key);

  @override
  State<LuggageScreen> createState() => _LuggageScreenState();
}

class _LuggageScreenState extends State<LuggageScreen> {
  late List<Bag> bags;

  @override
  void initState() {
    super.initState();
    bags = MockData.bags.where((b) => b.tripId == widget.trip.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    final verifiedBags = bags.where((b) => !b.needsVerification).length;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(verifiedBags),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                if (bags.isEmpty)
                  _buildEmptyState()
                else ...[
                  _buildStatsSection(verifiedBags),
                  const SizedBox(height: 32),
                  _buildBagsList(),
                ],
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildSliverAppBar(int verifiedBags) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: FadeInLeft(
        duration: const Duration(milliseconds: 600),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppTheme.primaryGradient,
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
                      widget.trip.name,
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
                          _getTripIcon(),
                          color: Colors.white.withOpacity(0.9),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${widget.trip.type.toUpperCase()} • ${widget.trip.durationInDays} days',
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

  Widget _buildStatsSection(int verifiedBags) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Container(
        padding: const EdgeInsets.all(20),
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
        child: Row(
          children: [
            Expanded(
              child: _buildStatItem(
                'Total Bags',
                bags.length.toString(),
                Icons.luggage_rounded,
                AppTheme.primaryColor,
              ),
            ),
            Container(
              height: 40,
              width: 1,
              color: Colors.grey,
            ),
            Expanded(
              child: _buildStatItem(
                'Verified',
                verifiedBags.toString(),
                Icons.verified_rounded,
                Colors.green,
              ),
            ),
            Container(
              height: 40,
              width: 1,
              color: Colors.grey,
            ),
            Expanded(
              child: _buildStatItem(
                'Photos',
                bags.where((b) => b.imagePaths.isNotEmpty).length.toString(),
                Icons.camera_alt_rounded,
                Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildBagsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Luggage',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
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
              children: bags.map((bag) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _BagCard(
                  bag: bag,
                  onVerify: () => _toggleBagVerification(bag),
                ),
              )).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppTheme.primaryGradient.map((c) => c.withOpacity(0.1)).toList(),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                Icons.luggage_rounded,
                size: 60,
                color: AppTheme.primaryColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No luggage added yet',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first piece of luggage to start tracking',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Add Luggage',
              onPressed: _showAddBagDialog,
              icon: Icons.add_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: AppTheme.primaryGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _showAddBagDialog,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(
            Icons.add_rounded,
            size: 28,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  IconData _getTripIcon() {
    switch (widget.trip.type.toLowerCase()) {
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

  void _toggleBagVerification(Bag bag) {
    setState(() {
      final index = bags.indexWhere((b) => b.id == bag.id);
      if (index != -1) {
        // This would normally update the actual bag object
        // For demo purposes, we'll just show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Text(
                  '${bag.name} ${bag.isVerified ? 'unverified' : 'verified'}!',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    });
  }

  void _showAddBagDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddBagBottomSheet(
        onBagAdded: (bagName) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(
                    '$bagName added successfully!',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
      ),
    );
  }
}

class _BagCard extends StatelessWidget {
  final Bag bag;
  final VoidCallback onVerify;

  const _BagCard({
    required this.bag,
    required this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _getVerificationGradient(),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getBagIcon(),
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
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      '${bag.type.toUpperCase()}${bag.color != null ? ' • ${bag.color}' : ''}${bag.size != null ? ' • ${bag.size}' : ''}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getVerificationColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  bag.verificationStatus.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _getVerificationColor(),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          if (bag.description != null) ...[
            const SizedBox(height: 16),
            Text(
              bag.description!,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.camera_alt_rounded,
                size: 16,
                color: Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                '${bag.imagePaths.length} photos',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const Spacer(),
              if (bag.needsVerification)
                CustomButton(
                  text: 'Verify',
                  onPressed: onVerify,
                  icon: Icons.verified_rounded,
                  gradientColors: AppTheme.successGradient,
                )
              else
                Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 24,
                ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getBagIcon() {
    switch (bag.type.toLowerCase()) {
      case 'carry-on':
        return Icons.luggage_rounded;
      case 'checked':
        return Icons.work_rounded;
      case 'personal':
        return Icons.backpack_rounded;
      case 'backpack':
        return Icons.hiking_rounded;
      default:
        return Icons.luggage_rounded;
    }
  }

  Color _getVerificationColor() {
    if (bag.isVerified && !bag.needsVerification) {
      return Colors.green;
    } else if (bag.needsVerification) {
      return Colors.orange;
    } else {
      return Colors.grey;
    }
  }

  List<Color> _getVerificationGradient() {
    if (bag.isVerified && !bag.needsVerification) {
      return AppTheme.successGradient;
    } else if (bag.needsVerification) {
      return AppTheme.warningGradient;
    } else {
      return [Colors.grey, Colors.grey!];
    }
  }
}

// Add Bag Bottom Sheet
class _AddBagBottomSheet extends StatefulWidget {
  final Function(String) onBagAdded;

  const _AddBagBottomSheet({required this.onBagAdded});

  @override
  State<_AddBagBottomSheet> createState() => _AddBagBottomSheetState();
}

class _AddBagBottomSheetState extends State<_AddBagBottomSheet> {
  final _nameController = TextEditingController();
  String _selectedType = 'carry-on';

  final List<Map<String, dynamic>> _bagTypes = [
    {'value': 'carry-on', 'label': 'Carry-on', 'icon': Icons.luggage_rounded},
    {'value': 'checked', 'label': 'Checked', 'icon': Icons.work_rounded},
    {'value': 'personal', 'label': 'Personal', 'icon': Icons.backpack_rounded},
    {'value': 'backpack', 'label': 'Backpack', 'icon': Icons.hiking_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Add New Bag',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Bag Name',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'e.g., Main Suitcase',
              prefixIcon: const Icon(Icons.luggage_rounded),
              filled: true,
              fillColor: Colors.grey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Bag Type',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _bagTypes.map((type) {
              final isSelected = _selectedType == type['value'];
              return GestureDetector(
                onTap: () => setState(() => _selectedType = type['value']),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                      colors: AppTheme.primaryGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                        : null,
                    color: isSelected ? null : Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        type['icon'],
                        color: isSelected ? Colors.white : Colors.grey,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        type['label'],
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: 'Add Bag',
            onPressed: () {
              if (_nameController.text.isNotEmpty) {
                widget.onBagAdded(_nameController.text);
                Navigator.pop(context);
              }
            },
            icon: Icons.add_rounded,
          ),
        ],
      ),
    );
  }
}