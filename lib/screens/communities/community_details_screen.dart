import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/community_provider.dart';
import '../../providers/event_provider.dart';
import '../../providers/profile_provider.dart';
import '../../services/leadership_score_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';
import '../../widgets/avatar_stack.dart';
import '../../widgets/cover_image.dart';
import '../../widgets/event_card.dart';

class CommunityDetailsScreen extends StatelessWidget {
  const CommunityDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final communityId = ModalRoute.of(context)!.settings.arguments as String;
    final communities = context.watch<CommunityProvider>();
    final events = context.watch<EventProvider>();
    final community = communities.getById(communityId);

    if (community == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Community not found')),
      );
    }

    final upcoming = events.eventsForCommunity(communityId);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final channelId = ChatProvider.communityChannelId(communityId);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(community.name),
              background: SizedBox.expand(
                child: CoverImage(
                  imagePath: community.imageUrl,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.zero,
                  placeholderIcon: Icons.groups_outlined,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Member count + Join/Leave row
                  Row(
                    children: [
                      Text(
                        '${community.memberCount} members',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const Spacer(),
                      FilledButton(
                        onPressed: () => _toggleJoin(context, communityId),
                        style: community.isJoined
                            ? FilledButton.styleFrom(
                                backgroundColor: AppColors.error.withValues(alpha: 0.12),
                                foregroundColor: AppColors.error,
                              )
                            : null,
                        child: Text(community.isJoined ? 'Leave hub' : 'Join hub'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  AvatarStack(
                    avatarUrls: community.memberAvatars,
                    size: 36,
                    overflowText: '${community.memberCount} members',
                  ),
                  const SizedBox(height: 20),

                  // Community Chat button — visible once joined
                  if (community.isJoined) ...[
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          AppRoutes.chatDetail,
                          arguments: channelId,
                        ),
                        icon: const Icon(Icons.forum_rounded, size: 18),
                        label: const Text('Community Chat'),
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              AppColors.brand(isDark).withValues(alpha: 0.12),
                          foregroundColor: AppColors.brand(isDark),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // About section
                  Text(
                    'About',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    community.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.55,
                        ),
                  ),
                  const SizedBox(height: 24),

                  // Upcoming activities
                  Text(
                    'Upcoming Activities',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  if (upcoming.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'No upcoming activities',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  else
                    ...upcoming.map(
                      (e) => EventCard(
                        event: e,
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.eventDetails,
                          arguments: e.id,
                        ),
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

  void _toggleJoin(BuildContext context, String communityId) {
    final communities = context.read<CommunityProvider>();
    final chat = context.read<ChatProvider>();
    final auth = context.read<AuthProvider>();
    final profile = context.read<ProfileProvider>();
    final community = communities.getById(communityId);
    final user = auth.user;

    if (community == null) return;

    if (community.isJoined) {
      communities.leaveCommunity(communityId);
      if (user != null) {
        chat.leaveCommunityChannel(communityId, user.id);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Left community hub')),
      );
    } else {
      communities.joinCommunity(communityId);
      if (user != null) {
        chat.joinCommunityChannel(communityId, community.name, user.id, user.name);
      }
      final points = LeadershipScoreService.pointsForCommunityJoin();
      profile.addLeadershipPoints(points, activity: 'Joined ${community.name}');
      profile.incrementCommunitiesJoined();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome to ${community.name}! +$points leadership points'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}
