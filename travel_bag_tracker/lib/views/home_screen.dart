import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../controllers/trip_controller.dart';
import '../controllers/bag_controller.dart';
import '../models/trip.dart';
import '../utils/constants.dart';
import '../widgets/trip_card.dart';
import '../widgets/stat_card.dart';
import 'trip_detail_screen.dart';
import 'new_trip_screen.dart';
import 'notifications_screen.dart';

/// Home screen - Main landing page showing trip list and overview
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppConstants.appName,
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        actions: [
          // Notifications button
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Upcoming', icon: Icon(Icons.schedule, size: 20)),
            Tab(text: 'Ongoing', icon: Icon(Icons.flight_takeoff, size: 20)),
            Tab(text: 'Completed', icon: Icon(Icons.check_circle_outline, size: 20)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Statistics cards
          _buildStatisticsSection(),

          // Trips list by tab
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTripList(TripFilter.upcoming),
                _buildTripList(TripFilter.ongoing),
                _buildTripList(TripFilter.completed),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewTripScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Trip'),
      ),
    );
  }

  /// Build statistics section
  Widget _buildStatisticsSection() {
    return Consumer2<TripController, BagController>(
      builder: (context, tripController, bagController, child) {
        final stats = tripController.getStatistics();

        return Container(
          padding: AppSpacing.paddingMD,
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.luggage,
                  title: 'Total Trips',
                  value: '${stats['total']}',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: StatCard(
                  icon: Icons.schedule,
                  title: 'Upcoming',
                  value: '${stats['upcoming']}',
                  color: AppColors.upcoming,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: StatCard(
                  icon: Icons.flight_takeoff,
                  title: 'Ongoing',
                  value: '${stats['ongoing']}',
                  color: AppColors.ongoing,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build trip list based on filter
  Widget _buildTripList(TripFilter filter) {
    return Consumer<TripController>(
      builder: (context, tripController, child) {
        if (tripController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        List<Trip> trips;
        switch (filter) {
          case TripFilter.upcoming:
            trips = tripController.upcomingTrips;
            break;
          case TripFilter.ongoing:
            trips = tripController.ongoingTrips;
            break;
          case TripFilter.completed:
            trips = tripController.completedTrips;
            break;
        }

        if (trips.isEmpty) {
          return _buildEmptyState(filter);
        }

        return RefreshIndicator(
          onRefresh: () async {
            await tripController.refresh();
          },
          child: ListView.builder(
            padding: AppSpacing.paddingMD,
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index];
              return TripCard(
                trip: trip,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TripDetailsScreen(trip: trip),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  /// Build empty state
  Widget _buildEmptyState(TripFilter filter) {
    String message;
    IconData icon;

    switch (filter) {
      case TripFilter.upcoming:
        message = 'No upcoming trips.\nCreate your first trip to get started!';
        icon = Icons.add_circle_outline;
        break;
      case TripFilter.ongoing:
        message = 'No ongoing trips.\nYour active trips will appear here.';
        icon = Icons.flight_takeoff;
        break;
      case TripFilter.completed:
        message = 'No completed trips yet.\nYour trip history will appear here.';
        icon = Icons.check_circle_outline;
        break;
    }

    return Center(
      child: Padding(
        padding: AppSpacing.paddingXL,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppIconSize.xxl * 1.5,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message,
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
}

/// Enum for trip filtering
enum TripFilter {
  upcoming,
  ongoing,
  completed,
}