import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/event.dart';
import '../../providers/event_provider.dart';
import '../../providers/notification_provider.dart';
import '../../models/notification_item.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';
import '../../widgets/cover_image.dart';

class CreatePreviewScreen extends StatelessWidget {
  const CreatePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final draft = ModalRoute.of(context)!.settings.arguments as EventModel;
    final dateStr = DateFormat('MMM d, yyyy').format(draft.date);

    return Scaffold(
      appBar: AppBar(title: const Text('Preview')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CoverImage(
              imagePath: draft.imageUrl,
              height: 200,
              width: double.infinity,
              borderRadius: BorderRadius.circular(20),
            ),
            const SizedBox(height: 20),
            Text(
              draft.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text('${draft.category.label} · $dateStr · ${draft.time}'),
            const SizedBox(height: 8),
            Text(draft.location),
            const SizedBox(height: 16),
            Text(draft.description),
            const SizedBox(height: 8),
            Text('Max participants: ${draft.maxParticipants}'),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FilledButton(
            onPressed: () => _publish(context, draft),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Publish'),
          ),
        ),
      ),
    );
  }

  Future<void> _publish(BuildContext context, EventModel draft) async {
    final events = context.read<EventProvider>();
    final notifs = context.read<NotificationProvider>();

    final published = EventModel(
      id: const Uuid().v4(),
      title: draft.title,
      description: draft.description,
      organizer: draft.organizer,
      organizerId: draft.organizerId,
      date: draft.date,
      time: draft.time,
      location: draft.location,
      category: draft.category,
      imageUrl: draft.imageUrl,
      maxParticipants: draft.maxParticipants,
    );

    events.addCreatedEvent(published);
    notifs.addNotification(
      NotificationItem(
        id: const Uuid().v4(),
        title: 'Opportunity Published',
        body: 'Your opportunity "${published.title}" is now live',
        type: NotificationType.newOpportunity,
        timestamp: DateTime.now(),
        relatedId: published.id,
      ),
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opportunity published successfully!'),
        backgroundColor: AppColors.success,
      ),
    );

    AppRoutes.popToMain(context);
  }
}
