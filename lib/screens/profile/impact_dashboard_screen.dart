import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_provider.dart';
import '../../utils/app_colors.dart';
import '../../widgets/leadership_progress.dart';
import '../../widgets/stat_card.dart';

/// Campus Impact Dashboard — tracks engagement analytics for ALU students.
class ImpactDashboardScreen extends StatelessWidget {
  const ImpactDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();
    final metrics = profile.impactMetrics;

    return Scaffold(
      appBar: AppBar(title: const Text('Campus Impact Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LeadershipProgress(
              score: profile.leadershipScore,
              progress: profile.leadershipProgress,
              level: profile.leadershipLevel,
            ),
            const SizedBox(height: 24),
            Text(
              'Your Impact',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                StatCard(
                  label: 'Events Attended',
                  value: '${metrics['Events Attended']}',
                  icon: Icons.event_available,
                  color: AppColors.primary,
                ),
                StatCard(
                  label: 'Communities',
                  value: '${metrics['Communities Joined']}',
                  icon: Icons.groups,
                  color: AppColors.secondary,
                ),
                StatCard(
                  label: 'Leadership Score',
                  value: '${metrics['Leadership Score']}',
                  icon: Icons.military_tech,
                  color: AppColors.navyDeep,
                ),
                StatCard(
                  label: 'Connections',
                  value: '${metrics['Connections']}',
                  icon: Icons.people,
                  color: AppColors.success,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Impact Summary',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'You are in the top 30% of active ALU students. '
                  'Keep attending events and joining communities to '
                  'reach Leadership Ambassador status!',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
