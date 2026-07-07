import '../models/message.dart';
import '../services/api_service.dart';
import 'interfaces.dart';

class MessageRepository implements IMessageRepository {
  final ApiService _api = ApiService();

  @override
  Future<List<Message>> getPersonalMessages() async {
    final List<Map<String, dynamic>> messagesJson = await _api.getMessages(announcements: false);
    return messagesJson.map((json) => Message.fromJson(json)).toList();
  }

  @override
  Future<List<Message>> getAnnouncements() async {
    final List<Map<String, dynamic>> messagesJson = await _api.getMessages(announcements: true);
    return messagesJson.map((json) => Message.fromJson(json)).toList();
  }

  @override
  Future<bool> sendMessage({
    required String recipientId, required String subject,
    required String message,
  }) async {
    await _api.sendMessage({
      'recipientId': recipientId, 'subject': subject, 'message': message,
    });
    return true;
  }

  @override
  Future<bool> markAsRead(String messageId) async {
    try {
      await _api.markMessageAsRead(messageId);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<int> getUnreadCount() async {
    final messages = await getPersonalMessages();
    return messages.where((m) => m.isUnread).length;
  }
}
