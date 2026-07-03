import '../models/message.dart';
import '../services/api_service.dart';

/// Repository for Message data access
/// 
/// Backend developers: This is where you integrate with your backend API.
class MessageRepository {
  final ApiService _api = ApiService();

  /// Get personal messages
  /// 
  /// Expected API response format:
  /// {
  ///   "messages": [
  ///     {
  ///       "id": "string",
  ///       "senderId": "string",
  ///       "senderName": "string",
  ///       "senderRole": "string (e.g., Mathematics)",
  ///       "subject": "string",
  ///       "message": "string",
  ///       "timestamp": "ISO8601 date",
  ///       "isRead": boolean,
  ///       "isAnnouncement": boolean
  ///     }
  ///   ]
  /// }
  Future<List<Message>> getPersonalMessages() async {
    try {
      final List<Map<String, dynamic>> messagesJson = await _api.getMessages(announcements: false);
      return messagesJson.map((json) => Message.fromJson(json)).toList();
    } catch (e) {
      return _getMockPersonalMessages();
    }
  }

  /// Get announcements
  Future<List<Message>> getAnnouncements() async {
    try {
      final List<Map<String, dynamic>> messagesJson = await _api.getMessages(announcements: true);
      return messagesJson.map((json) => Message.fromJson(json)).toList();
    } catch (e) {
      return _getMockAnnouncements();
    }
  }

  /// Send a new message
  Future<bool> sendMessage({
    required String recipientId,
    required String subject,
    required String message,
  }) async {
    try {
      await _api.sendMessage({
        'recipientId': recipientId,
        'subject': subject,
        'message': message,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Mark message as read
  Future<bool> markAsRead(String messageId) async {
    try {
      // TODO: Add API endpoint for marking message as read
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get unread message count
  Future<int> getUnreadCount() async {
    final messages = await getPersonalMessages();
    return messages.where((m) => m.isUnread).length;
  }

  // Mock data for development - Backend: Remove this
  List<Message> _getMockPersonalMessages() {
    return [
      Message(
        id: '1',
        senderId: 'teacher1',
        senderName: 'Mr. Smith',
        senderRole: 'Mathematics',
        subject: 'Homework Reminder',
        message: 'Please submit your homework by tomorrow',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
        isAnnouncement: false,
      ),
      Message(
        id: '2',
        senderId: 'teacher2',
        senderName: 'Ms. Johnson',
        senderRole: 'Biology',
        subject: 'Lab Session Update',
        message: 'Lab session postponed to next week',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        isRead: false,
        isAnnouncement: false,
      ),
    ];
  }

  // Mock data for development - Backend: Remove this
  List<Message> _getMockAnnouncements() {
    return [
      Message(
        id: 'a1',
        senderId: 'admin',
        senderName: 'Admin',
        senderRole: 'School',
        subject: 'School Closure',
        message: 'School will be closed on Friday for maintenance',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: false,
        isAnnouncement: true,
      ),
      Message(
        id: 'a2',
        senderId: 'principal',
        senderName: 'Principal',
        senderRole: 'School',
        subject: 'Parent-Teacher Meetings',
        message: 'Parent-teacher meetings next week',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
        isAnnouncement: true,
      ),
    ];
  }
}
