import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_decorations.dart';
import '../../utils/app_routes.dart';
import '../../widgets/leadership_progress.dart';
import '../../widgets/profile_avatar.dart';
import '../../widgets/section_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final profile = context.watch<ProfileProvider>();
    final user = auth.user ?? profile.profile;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('Please log in')));
    }

    final displayUser = profile.profile ?? user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Your profile',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontSize: 28,
                          ),
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.editProfile),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: AppDecorations.surfaceCard(context),
                    child: Column(
                      children: [
                        ProfileAvatar(
                          avatarUrl: displayUser.avatarUrl,
                          radius: 44,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          displayUser.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          displayUser.program,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          displayUser.campus,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        if (displayUser.canPostOpportunities) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.brandMuted(isDark),
                              borderRadius: BorderRadius.circular(
                                AppDecorations.radiusXs,
                              ),
                            ),
                            child: Text(
                              displayUser.roleLabel,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _StatsRow(
                    events: displayUser.eventsAttended,
                    communities: displayUser.communitiesJoined,
                    connections: displayUser.connections,
                  ),
                  const SizedBox(height: 16),
                  LeadershipProgress(
                    score: profile.leadershipScore,
                    progress: profile.leadershipProgress,
                    level: profile.leadershipLevel,
                    compact: true,
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SectionHeader(title: 'Your space'),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 110),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                if (displayUser.canPostOpportunities)
                  _MenuRow(
                    icon: Icons.edit_note_rounded,
                    title: 'Post opportunity',
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.createOpportunity,
                    ),
                  ),
                _MenuRow(
                  icon: Icons.bookmark_outline_rounded,
                  title: 'Saved opportunities',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.savedOpportunities),
                ),
                _MenuRow(
                  icon: Icons.history_rounded,
                  title: 'Participation history',
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.participationHistory,
                  ),
                ),
                _MenuRow(
                  icon: Icons.insights_rounded,
                  title: 'Campus impact',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.impactDashboard),
                ),
                _MenuRow(
                  icon: Icons.emoji_events_outlined,
                  title: 'Achievements',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.achievements),
                ),
                _MenuRow(
                  icon: Icons.leaderboard_outlined,
                  title: 'Leaderboard',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.leaderboard),
                ),
                _MenuRow(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifications',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.notifications),
                ),
                _MenuRow(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.settings),
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: () {
                    auth.logout();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.login,
                      (_) => false,
                    );
                  },
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: const Text('Sign out'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: BorderSide(
                      color: AppColors.error.withValues(alpha: 0.4),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.events,
    required this.communities,
    required this.connections,
  });

  final int events;
  final int communities;
  final int connections;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCell(value: '$events', label: 'Events'),
        _StatCell(value: '$communities', label: 'Hubs'),
        _StatCell(value: '$connections', label: 'Peers'),
      ],
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: AppDecorations.surfaceCard(context),
        child: Column(
          children: [
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 2),
            Text(label, style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = AppColors.brand(isDark);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDecorations.radiusMd),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: AppDecorations.surfaceCard(context),
            child: Row(
              children: [
                Icon(icon, size: 20, color: accent),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 15,
                        ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
