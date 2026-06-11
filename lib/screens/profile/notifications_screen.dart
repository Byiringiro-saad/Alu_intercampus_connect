import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/notification_tile.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifs = context.watch<NotificationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (notifs.unreadCount > 0)
            TextButton(
              onPressed: notifs.markAllRead,
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: notifs.notifications.isEmpty
          ? const EmptyState(
              icon: Icons.notifications_none,
              title: 'No notifications',
              message: 'You\'re all caught up!',
            )
          : ListView.builder(
              itemCount: notifs.notifications.length,
              itemBuilder: (_, i) {
                final n = notifs.notifications[i];
                return NotificationTile(
                  notification: n,
                  onTap: () => notifs.markAsRead(n.id),
                );
              },
            ),
    );
  }
}
