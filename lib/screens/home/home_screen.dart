import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/opportunity_category.dart';
import '../../providers/auth_provider.dart';
import '../../providers/event_provider.dart';
import '../../providers/profile_provider.dart';
import '../../services/leadership_score_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';
import '../../utils/constants.dart';
import '../../widgets/app_page_header.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/event_card.dart';
import '../../widgets/featured_event_card.dart';
import '../../widgets/filter_chips_row.dart';
import '../../widgets/leadership_progress.dart';
import '../../widgets/loading_shimmer.dart';
import '../../widgets/quick_action_grid.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/section_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  void _openEvent(String eventId) {
    Navigator.pushNamed(context, AppRoutes.eventDetails, arguments: eventId);
  }

  void _tryCreate() {
    final auth = context.read<AuthProvider>();
    final user = auth.user;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to post opportunities')),
      );
      return;
    }
    if (!user.canPostOpportunities) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Posting is for authorized roles — club leaders, organizers, '
            'entrepreneurs, community leaders, and academic teams.',
          ),
        ),
      );
      return;
    }
    Navigator.pushNamed(context, AppRoutes.createOpportunity);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final events = context.watch<EventProvider>();
    final profile = context.watch<ProfileProvider>();
    final user = auth.user;

    if (events.isLoading) return const LoadingShimmer();

    final filtered = events.filteredEvents(user: user);
    final recommended = events.recommendedEvents(user ?? profile.profile!);
    final featured = events.events.where((e) => e.isFeatured).firstOrNull;
    final firstName = user?.name.split(' ').first ?? 'there';

    return RefreshIndicator(
      onRefresh: events.refresh,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: AppPageHeader(
              greeting: _greeting(),
              name: firstName,
              subtitle: user?.program,
              avatarUrl: user?.avatarUrl,
              badge: user != null ? CampusPill(campus: user.campus) : null,
              trailing: IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.notifications),
                icon: Badge(
                  isLabelVisible: events.savedIds.isNotEmpty,
                  label: Text('${events.savedIds.length}'),
                  child: const Icon(Icons.notifications_none_rounded),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: QuickActionGrid(
              actions: [
                QuickAction(
                  icon: Icons.calendar_month_outlined,
                  label: 'My week',
                  color: AppColors.categoryEvents,
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.myRsvps),
                ),
                QuickAction(
                  icon: Icons.hub_outlined,
                  label: 'Community hubs',
                  color: AppColors.teal,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Open the Hubs tab below to explore communities'),
                      ),
                    );
                  },
                ),
                QuickAction(
                  icon: Icons.emoji_events_outlined,
                  label: 'Achievements',
                  color: AppColors.purple,
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.achievements),
                ),
                QuickAction(
                  icon: Icons.edit_note_rounded,
                  label: 'Post opportunity',
                  color: AppColors.categoryStartups,
                  onTap: _tryCreate,
                ),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(
            child: SearchBarWidget(
              controller: _searchController,
              onChanged: events.setSearchQuery,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 14)),
          SliverToBoxAdapter(
            child: FilterChipsRow(
              filters: AppConstants.filterCategories,
              selected: events.activeFilter,
              onSelected: events.setFilter,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 18),
              child: LeadershipProgress(
                score: profile.leadershipScore,
                progress: profile.leadershipProgress,
                level: profile.leadershipLevel,
              ),
            ),
          ),
          if (featured != null && events.searchQuery.isEmpty) ...[
            const SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Worth your attention',
                subtitle: 'Hand-picked for ALU students this week',
              ),
            ),
            SliverToBoxAdapter(
              child: FeaturedEventCard(
                event: featured,
                heroTag: 'featured-${featured.id}',
                onTap: () => _openEvent(featured.id),
              ),
            ),
          ],
          if (events.searchQuery.isEmpty && recommended.isNotEmpty) ...[
            const SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Curated for you',
                subtitle: 'Based on your interests and campus',
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 168,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  itemCount: recommended.length,
                  itemBuilder: (_, i) {
                    final event = recommended[i];
                    return SizedBox(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: EventCard(
                          event: event,
                          compact: true,
                          showMatchScore: true,
                          isSaved: events.isSaved(event.id),
                          isGoing: events.isGoing(event.id),
                          heroTag: 'rec-${event.id}',
                          onTap: () => _openEvent(event.id),
                          onRsvp: () => _handleRsvp(event.id),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
          SliverToBoxAdapter(
            child: SectionHeader(
              title: events.searchQuery.isEmpty
                  ? 'On campus this week'
                  : 'Results',
              actionLabel: 'My RSVPs',
              onAction: () =>
                  Navigator.pushNamed(context, AppRoutes.myRsvps),
            ),
          ),
          if (filtered.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyState(
                icon: Icons.search_off_rounded,
                title: 'Nothing matched',
                message: 'Try a different filter or search term',
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 110),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) {
                    final event = filtered[i];
                    return EventCard(
                      event: event,
                      isSaved: events.isSaved(event.id),
                      isGoing: events.isGoing(event.id),
                      heroTag: 'event-${event.id}',
                      onTap: () => _openEvent(event.id),
                      onSave: () => events.toggleSave(event.id),
                      onRsvp: () => _handleRsvp(event.id),
                    );
                  },
                  childCount: filtered.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _handleRsvp(String eventId) {
    final events = context.read<EventProvider>();
    final profile = context.read<ProfileProvider>();
    final event = events.getById(eventId);
    if (event == null) return;

    if (events.isGoing(eventId)) {
      events.cancelRsvp(eventId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('RSVP cancelled')),
      );
      return;
    }

    final status = events.rsvpEvent(eventId);
    final points = LeadershipScoreService.pointsForRsvp(event);
    profile.addLeadershipPoints(points, activity: 'RSVP: ${event.title}');
    profile.incrementEventsAttended();
    if (event.category == OpportunityCategory.hackathons) {
      profile.incrementHackathonsAttended();
    } else if (event.category == OpportunityCategory.startups) {
      profile.incrementStartupEventsAttended();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          status == 'going'
              ? 'You\'re going! +$points leadership points'
              : 'Marked as interested',
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
