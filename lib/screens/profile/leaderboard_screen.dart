import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_provider.dart';
import '../../utils/app_colors.dart';
import '../../widgets/profile_avatar.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();
    final entries = profile.leaderboard;

    return Scaffold(
      appBar: AppBar(title: const Text('Most Active Students')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: entries.length,
        itemBuilder: (_, i) {
          final entry = entries[i];
          final isTop3 = entry.rank <= 3;

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            color: entry.isCurrentUser
                ? AppColors.primary.withValues(alpha: 0.1)
                : null,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isTop3
                    ? AppColors.navyDeep
                    : Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  '#${entry.rank}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isTop3 ? Colors.white : null,
                  ),
                ),
              ),
              title: Row(
                children: [
                  ProfileAvatar(avatarUrl: entry.avatarUrl, radius: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      entry.name,
                      style: TextStyle(
                        fontWeight: entry.isCurrentUser
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (entry.isCurrentUser)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'You',
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                ],
              ),
              subtitle: Text('${entry.eventsAttended} events attended'),
              trailing: Text(
                '${entry.score} pts',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.navyDeep,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
