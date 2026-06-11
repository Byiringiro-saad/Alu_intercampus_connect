import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/event.dart';
import '../../providers/event_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/event_card.dart';

class MyRsvpsScreen extends StatefulWidget {
  const MyRsvpsScreen({super.key});

  @override
  State<MyRsvpsScreen> createState() => _MyRsvpsScreenState();
}

class _MyRsvpsScreenState extends State<MyRsvpsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final events = context.watch<EventProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My RSVPs'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Going'),
            Tab(text: 'Interested'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _RsvpList(
            events: events.rsvpEvents('going'),
            emptyTitle: 'No events yet',
            emptyMessage: 'RSVP to events to see them here',
            badgeColor: AppColors.success,
            badgeLabel: 'Going',
          ),
          _RsvpList(
            events: events.rsvpEvents('interested'),
            emptyTitle: 'No interested events',
            emptyMessage: 'Mark events as interested to track them',
            badgeColor: AppColors.navyMid,
            badgeLabel: 'Interested',
          ),
        ],
      ),
    );
  }
}

class _RsvpList extends StatelessWidget {
  const _RsvpList({
    required this.events,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.badgeColor,
    required this.badgeLabel,
  });

  final List<EventModel> events;
  final String emptyTitle;
  final String emptyMessage;
  final Color badgeColor;
  final String badgeLabel;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return EmptyState(
        icon: Icons.event_busy_rounded,
        title: emptyTitle,
        message: emptyMessage,
        actionLabel: 'Explore Events',
        onAction: () => Navigator.pop(context),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (_, i) {
        final event = events[i];
        return Stack(
          children: [
            EventCard(
              event: event,
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.eventDetails,
                arguments: event.id,
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badgeLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
