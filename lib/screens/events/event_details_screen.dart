import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/opportunity_category.dart';
import '../../providers/community_provider.dart';
import '../../providers/event_provider.dart';
import '../../providers/profile_provider.dart';
import '../../services/leadership_score_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';
import '../../widgets/avatar_stack.dart';
import '../../widgets/cover_image.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eventId = ModalRoute.of(context)!.settings.arguments as String;
    final events = context.watch<EventProvider>();
    final communities = context.watch<CommunityProvider>();
    final event = events.getById(eventId);

    if (event == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Event not found')),
      );
    }

    final isGoing = events.isGoing(eventId);
    final isInterested = events.isInterested(eventId);
    final dateStr = DateFormat('EEEE, MMM d, yyyy').format(event.date);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'event-image-$eventId',
                child: SizedBox.expand(
                  child: CoverImage(
                    imagePath: event.imageUrl,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.zero,
                    placeholderIcon: Icons.event_outlined,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  events.isSaved(eventId)
                      ? Icons.bookmark
                      : Icons.bookmark_outline,
                ),
                onPressed: () => events.toggleSave(eventId),
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Shared: ${event.title}')),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    children: [
                      _TagChip(label: event.category.label),
                      _TagChip(label: 'Tech', color: AppColors.secondary),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _InfoRow(
                    icon: Icons.calendar_today_outlined,
                    label: '$dateStr at ${event.time}',
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    label: event.location,
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.person_outline,
                    label: 'Organized by ${event.organizer}',
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'About',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.6,
                        ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Attendees',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  AvatarStack(
                    avatarUrls: event.attendeeAvatars,
                    size: 36,
                    overflowText:
                        '${event.participantCount} going, ${event.interestedCount} interested',
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () => _handleRsvp(context, eventId, false),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(isGoing ? 'Cancel RSVP' : 'RSVP'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              _handleRsvp(context, eventId, true),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            isInterested ? 'Interested ✓' : 'Interested',
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (event.communityId != null) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.communityDetails,
                            arguments: event.communityId,
                          );
                        },
                        icon: const Icon(Icons.groups_outlined),
                        label: Text(
                          communities.isJoined(event.communityId!)
                              ? 'View Community'
                              : 'Join Community',
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.qrCheckin,
                          arguments: eventId,
                        );
                      },
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('QR Attendance Check-In'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleRsvp(
    BuildContext context,
    String eventId,
    bool interested,
  ) {
    final events = context.read<EventProvider>();
    final profile = context.read<ProfileProvider>();
    final event = events.getById(eventId);
    if (event == null) return;

    if (events.isGoing(eventId) && !interested) {
      events.cancelRsvp(eventId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('RSVP cancelled')),
      );
      return;
    }

    final status = events.rsvpEvent(eventId, interested: interested);

    if (status == 'going') {
      final points = LeadershipScoreService.pointsForRsvp(event);
      profile.addLeadershipPoints(points, activity: 'RSVP: ${event.title}');
      profile.incrementEventsAttended();
      if (event.category == OpportunityCategory.hackathons) {
        profile.incrementHackathonsAttended();
      } else if (event.category == OpportunityCategory.startups) {
        profile.incrementStartupEventsAttended();
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          interested ? 'Marked as interested' : 'You are going!',
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label, this.color});
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: (color ?? Colors.grey).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color ?? Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(child: Text(label)),
      ],
    );
  }
}
