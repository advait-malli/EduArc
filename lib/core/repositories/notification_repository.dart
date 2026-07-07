import '../models/notification.dart';
import '../services/api_service.dart';
import 'interfaces.dart';

class NotificationRepository implements INotificationRepository {
  final ApiService _api = ApiService();

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final List<Map<String, dynamic>> notificationsJson = await _api.getNotifications();
    return notificationsJson.map((json) => NotificationModel.fromJson(json)).toList();
  }

  @override
  Future<bool> markAsRead(String notificationId) async {
    await _api.markNotificationAsRead(notificationId);
    return true;
  }

  @override
  Future<bool> markAllAsRead() async {
    await _api.markAllNotificationsAsRead();
    return true;
  }

  @override
  Future<int> getUnreadCount() async {
    final notifications = await getNotifications();
    return notifications.where((n) => n.isUnread).length;
  }

  @override
  Future<List<NotificationModel>> getByType(String type) async {
    final notifications = await getNotifications();
    return notifications.where((n) => n.type == type).toList();
  }
}
