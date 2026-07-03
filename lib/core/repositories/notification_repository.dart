import '../models/notification.dart';
import '../services/api_service.dart';

/// Repository for Notification data access
/// 
/// Backend developers: This is where you integrate with your backend API.
class NotificationRepository {
  final ApiService _api = ApiService();

  /// Get all notifications
  /// 
  /// Expected API response format:
  /// {
  ///   "notifications": [
  ///     {
  ///       "id": "string",
  ///       "title": "string",
  ///       "message": "string",
  ///       "type": "homework|announcement|message|grade|schedule",
  ///       "timestamp": "ISO8601 date",
  ///       "isRead": boolean,
  ///       "icon": "icon_name (optional)",
  ///       "actionType": "string (optional)",
  ///       "actionId": "string (optional)"
  ///     }
  ///   ]
  /// }
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final List<Map<String, dynamic>> notificationsJson = await _api.getNotifications();
      return notificationsJson.map((json) => NotificationModel.fromJson(json)).toList();
    } catch (e) {
      return _getMockNotifications();
    }
  }

  /// Mark notification as read
  Future<bool> markAsRead(String notificationId) async {
    try {
      await _api.markNotificationAsRead(notificationId);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Mark all notifications as read
  Future<bool> markAllAsRead() async {
    try {
      await _api.markAllNotificationsAsRead();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get unread notification count
  Future<int> getUnreadCount() async {
    final notifications = await getNotifications();
    return notifications.where((n) => n.isUnread).length;
  }

  /// Get notifications by type
  Future<List<NotificationModel>> getByType(String type) async {
    final notifications = await getNotifications();
    return notifications.where((n) => n.type == type).toList();
  }

  // Mock data for development - Backend: Remove this
  List<NotificationModel> _getMockNotifications() {
    return [
      NotificationModel(
        id: '1',
        title: 'Homework Due Tomorrow',
        message: 'Revision Jobsheet for Mathematics is due tomorrow',
        type: 'homework',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
        icon: 'menu_book',
        actionType: 'homework',
        actionId: 'hw1',
      ),
      NotificationModel(
        id: '2',
        title: 'New Announcement',
        message: 'School will be closed on Friday for maintenance',
        type: 'announcement',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        isRead: false,
        icon: 'campaign',
        actionType: 'announcement',
        actionId: 'ann1',
      ),
      NotificationModel(
        id: '3',
        title: 'Message from Teacher',
        message: 'Ms. Johnson sent you a message about Biology lab',
        type: 'message',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
        icon: 'message',
        actionType: 'message',
        actionId: 'msg1',
      ),
      NotificationModel(
        id: '4',
        title: 'Assignment Graded',
        message: 'Your English essay has been graded',
        type: 'grade',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
        icon: 'grade',
        actionType: 'homework',
        actionId: 'hw3',
      ),
      NotificationModel(
        id: '5',
        title: 'Class Schedule Changed',
        message: 'Mathematics class moved to Room 204',
        type: 'schedule',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        isRead: true,
        icon: 'schedule',
        actionType: 'timetable',
        actionId: 'tt1',
      ),
    ];
  }
}
