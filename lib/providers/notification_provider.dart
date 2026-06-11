import 'package:flutter/material.dart';
import '../models/notification_item.dart';
import '../services/mock_data.dart';

/// NotificationProvider — mock local notifications with badge count.
class NotificationProvider extends ChangeNotifier {
  List<NotificationItem> _notifications = [];

  List<NotificationItem> get notifications => _notifications;

  int get unreadCount =>
      _notifications.where((n) => !n.isRead).length;

  Future<void> init() async {
    _notifications = MockData.notifications
        .map((n) => NotificationItem(
              id: n.id,
              title: n.title,
              body: n.body,
              type: n.type,
              timestamp: n.timestamp,
              isRead: n.isRead,
              relatedId: n.relatedId,
            ))
        .toList();
    notifyListeners();
  }

  void markAsRead(String id) {
    final notif = _notifications.firstWhere((n) => n.id == id);
    notif.isRead = true;
    notifyListeners();
  }

  void markAllRead() {
    for (final n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void addNotification(NotificationItem item) {
    _notifications.insert(0, item);
    notifyListeners();
  }
}
