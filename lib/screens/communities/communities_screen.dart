import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/community_provider.dart';
import '../../providers/profile_provider.dart';
import '../../services/leadership_score_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_decorations.dart';
import '../../utils/app_routes.dart';
import '../../widgets/community_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_shimmer.dart';
import '../../widgets/section_header.dart';

class CommunitiesScreen extends StatelessWidget {
  const CommunitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final communities = context.watch<CommunityProvider>();

    if (communities.isLoading) return const LoadingShimmer(itemCount: 4);

    final list = communities.filteredCommunities();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Community hubs',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontSize: 28,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Find your people — entrepreneurship, AI, climate, leadership, and more.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'All Clubs', label: Text('All hubs')),
                    ButtonSegment(value: 'My Clubs', label: Text('Mine')),
                  ],
                  selected: {communities.activeTab},
                  onSelectionChanged: (s) => communities.setActiveTab(s.first),
                  style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return AppColors.brandMuted(isDark);
                      }
                      return AppDecorations.mutedSurface(context);
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SectionHeader(
            title: communities.activeTab == 'My Clubs'
                ? 'Your memberships'
                : 'Explore hubs',
            actionLabel: 'Leaderboard',
            onAction: () =>
                Navigator.pushNamed(context, AppRoutes.leaderboard),
          ),
        ),
        if (list.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyState(
              icon: Icons.hub_outlined,
              title: 'No hubs here yet',
              message: communities.activeTab == 'My Clubs'
                  ? 'Join a hub from Explore to see it here'
                  : 'Community hubs will appear as they launch',
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 110),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  final community = list[i];
                  return CommunityCard(
                    community: community,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.communityDetails,
                      arguments: community.id,
                    ),
                    onJoinToggle: () => _toggleJoin(context, community.id),
                  );
                },
                childCount: list.length,
              ),
            ),
          ),
      ],
    );
  }

  void _toggleJoin(BuildContext context, String id) {
    final communities = context.read<CommunityProvider>();
    final profile = context.read<ProfileProvider>();
    final chat = context.read<ChatProvider>();
    final auth = context.read<AuthProvider>();
    final community = communities.getById(id);
    final user = auth.user;

    if (communities.isJoined(id)) {
      communities.leaveCommunity(id);
      if (user != null) {
        chat.leaveCommunityChannel(id, user.id);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Left community hub')),
      );
    } else {
      communities.joinCommunity(id);
      if (user != null && community != null) {
        chat.joinCommunityChannel(id, community.name, user.id, user.name);
      }
      final points = LeadershipScoreService.pointsForCommunityJoin();
      profile.addLeadershipPoints(
        points,
        activity: 'Joined ${community?.name}',
      );
      profile.incrementCommunitiesJoined();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome to the hub! +$points leadership points'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}
