class Message {
  final String id;
  final String senderId;
  final String senderName;
  final String subject;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final bool isAnnouncement;
  final String? recipientId;
  final String? recipientName;
  final String? senderRole; // e.g., 'Mathematics', 'School'

  Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.subject,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.isAnnouncement = false,
    this.recipientId,
    this.recipientName,
    this.senderRole,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      subject: json['subject'] ?? '',
      message: json['message'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
      isAnnouncement: json['isAnnouncement'] ?? false,
      recipientId: json['recipientId'],
      recipientName: json['recipientName'],
      senderRole: json['senderRole'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'subject': subject,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'isAnnouncement': isAnnouncement,
      'recipientId': recipientId,
      'recipientName': recipientName,
      'senderRole': senderRole,
    };
  }

  Message copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? subject,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    bool? isAnnouncement,
    String? recipientId,
    String? recipientName,
    String? senderRole,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      subject: subject ?? this.subject,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      isAnnouncement: isAnnouncement ?? this.isAnnouncement,
      recipientId: recipientId ?? this.recipientId,
      recipientName: recipientName ?? this.recipientName,
      senderRole: senderRole ?? this.senderRole,
    );
  }

  bool get isUnread => !isRead;
}
