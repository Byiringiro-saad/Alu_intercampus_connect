import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/notification_item.dart';
import '../utils/app_colors.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final NotificationItem notification;
  final VoidCallback onTap;

  IconData _iconForType(NotificationType type) {
    switch (type) {
      case NotificationType.eventReminder:
        return Icons.alarm_rounded;
      case NotificationType.rsvpConfirmation:
        return Icons.check_circle_outline;
      case NotificationType.communityInvitation:
        return Icons.group_add_rounded;
      case NotificationType.newOpportunity:
        return Icons.new_releases_rounded;
      case NotificationType.achievement:
        return Icons.emoji_events_rounded;
      case NotificationType.message:
        return Icons.chat_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('MMM d, h:mm a').format(notification.timestamp);

    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(_iconForType(notification.type), color: AppColors.primary),
      ),
      title: Text(
        notification.title,
        style: TextStyle(
          fontWeight:
              notification.isRead ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(notification.body),
          const SizedBox(height: 4),
          Text(
            time,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
      trailing: notification.isRead
          ? null
          : Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: AppColors.navyMid,
                shape: BoxShape.circle,
              ),
            ),
    );
  }
}
