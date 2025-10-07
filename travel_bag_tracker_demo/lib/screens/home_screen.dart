import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/mock_data.dart';
import '../models/trip.dart';
import '../widgets/trip_card.dart';
import '../widgets/stats_card.dart';
import '../widgets/animated_counter.dart';
import '../theme/app_theme.dart';
import 'trip_form_screen.dart';
import 'luggage_screen.dart';
import 'verification_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _HomeTab(),
          _TripsTab(),
          VerificationScreen(),
          NotificationsScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _currentIndex == 0 || _currentIndex == 1
          ? _buildFloatingActionButton()
          : null,
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.normal),
          items: [
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.home_rounded, 0),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.flight_takeoff_rounded, 1),
              label: 'Trips',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.verified_rounded, 2),
              label: 'Verify',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.notifications_rounded, 3),
              label: 'Alerts',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index) {
    final isSelected = _currentIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.primaryColor.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: isSelected ? AppTheme.primaryColor : Colors.grey,
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
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
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                const TripFormScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOutCubic,
                    )),
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 400),
              ),
            );
          },
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
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final stats = MockData.tripStats;
    final bagStats = MockData.bagStats;
    final notificationStats = MockData.notificationStats;

    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(context),
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildStatsSection(stats, bagStats, notificationStats),
              const SizedBox(height: 32),
              _buildQuickActions(context),
              const SizedBox(height: 32),
              _buildRecentTrips(context),
              const SizedBox(height: 32),
              _buildUpcomingAlerts(context),
              const SizedBox(height: 100), // Bottom padding for FAB
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppTheme.primaryGradient,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
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
                    duration: const Duration(milliseconds: 600),
                    child: Text(
                      'Welcome back!',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  FadeInDown(
                    duration: const Duration(milliseconds: 800),
                    child: Text(
                      'Track Your Journey',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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

  Widget _buildStatsSection(
      Map<String, int> stats,
      Map<String, int> bagStats,
      Map<String, int> notificationStats,
      ) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Row(
        children: [
          Expanded(
            child: StatsCard(
              title: 'Active Trips',
              value: stats['active']!,
              icon: Icons.flight_takeoff_rounded,
              gradientColors: AppTheme.primaryGradient,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: StatsCard(
              title: 'Bags Tracked',
              value: bagStats['total']!,
              icon: Icons.luggage_rounded,
              gradientColors: AppTheme.successGradient,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: StatsCard(
              title: 'Alerts',
              value: notificationStats['unread']!,
              icon: Icons.notifications_rounded,
              gradientColors: AppTheme.warningGradient,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  context,
                  'Add Trip',
                  Icons.add_circle_outline_rounded,
                  AppTheme.primaryGradient,
                      () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TripFormScreen()),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildQuickActionCard(
                  context,
                  'Verify Bags',
                  Icons.verified_rounded,
                  AppTheme.successGradient,
                      () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const VerificationScreen()),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
      BuildContext context,
      String title,
      IconData icon,
      List<Color> gradientColors,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors.map((c) => c.withOpacity(0.1)).toList(),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: gradientColors.first.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTrips(BuildContext context) {
    final recentTrips = MockData.trips.take(3).toList();

    return FadeInUp(
      duration: const Duration(milliseconds: 1000),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Trips',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to trips tab
                },
                child: Text(
                  'View All',
                  style: GoogleFonts.inter(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
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
                children: recentTrips.map((trip) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TripCard(
                    trip: trip,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LuggageScreen(trip: trip),
                      ),
                    ),
                  ),
                )).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingAlerts(BuildContext context) {
    final upcomingNotifications = MockData.notifications
        .where((n) => !n.isRead && DateTime.now().isBefore(n.scheduledFor))
        .take(2)
        .toList();

    if (upcomingNotifications.isEmpty) return const SizedBox();

    return FadeInUp(
      duration: const Duration(milliseconds: 1200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcoming Alerts',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          ...upcomingNotifications.map((notification) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.orange.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.schedule_rounded,
                    color: Colors.orange,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                      Text(
                        notification.timeDescription,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _TripsTab extends StatelessWidget {
  const _TripsTab();

  @override
  Widget build(BuildContext context) {
    final trips = MockData.trips;
    final upcomingTrips = trips.where((t) => t.status == 'Upcoming').toList();
    final activeTrips = trips.where((t) => t.status == 'Active').toList();
    final completedTrips = trips.where((t) => t.status == 'Completed').toList();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(
            'My Trips',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          floating: true,
        ),
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              if (upcomingTrips.isNotEmpty) ...[
                _buildTripSection('Upcoming Trips', upcomingTrips, context),
                const SizedBox(height: 32),
              ],
              if (activeTrips.isNotEmpty) ...[
                _buildTripSection('Active Trips', activeTrips, context),
                const SizedBox(height: 32),
              ],
              if (completedTrips.isNotEmpty) ...[
                _buildTripSection('Recent Trips', completedTrips, context),
                const SizedBox(height: 32),
              ],
              const SizedBox(height: 100), // Bottom padding for FAB
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildTripSection(String title, List<Trip> trips, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
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
              children: trips.map((trip) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TripCard(
                  trip: trip,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LuggageScreen(trip: trip),
                    ),
                  ),
                ),
              )).toList(),
            ),
          ),
        ),
      ],
    );
  }
}