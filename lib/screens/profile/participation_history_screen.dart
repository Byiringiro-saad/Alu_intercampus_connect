import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/empty_state.dart';

class ParticipationHistoryScreen extends StatelessWidget {
  const ParticipationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();
    final history = profile.profile?.participationHistory ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Participation History')),
      body: history.isEmpty
          ? const EmptyState(
              icon: Icons.history,
              title: 'No activity yet',
              message:
                  'Attend events and join communities to build your history',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${i + 1}')),
                    title: Text(history[i]),
                    subtitle: const Text('Leadership activity'),
                    trailing: const Icon(Icons.check_circle_outline),
                  ),
                );
              },
            ),
    );
  }
}
