import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/event_provider.dart';
import '../../utils/app_routes.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/event_card.dart';

class SavedOpportunitiesScreen extends StatelessWidget {
  const SavedOpportunitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final events = context.watch<EventProvider>();
    final saved = events.savedEvents();

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Opportunities')),
      body: saved.isEmpty
          ? const EmptyState(
              icon: Icons.bookmark_border,
              title: 'No saved opportunities',
              message: 'Bookmark events to find them quickly later',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: saved.length,
              itemBuilder: (_, i) {
                final event = saved[i];
                return EventCard(
                  event: event,
                  isSaved: true,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.eventDetails,
                    arguments: event.id,
                  ),
                  onSave: () => events.toggleSave(event.id),
                );
              },
            ),
    );
  }
}
