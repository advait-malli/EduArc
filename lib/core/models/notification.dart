class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type; // 'homework', 'announcement', 'message', 'grade', 'schedule'
  final DateTime timestamp;
  final bool isRead;
  final String? icon; // Icon name as string
  final String? actionType; // Type of action when tapped
  final String? actionId; // ID of the related item (homework id, message id, etc.)
  final Map<String, dynamic>? metadata; // Additional data

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.icon,
    this.actionType,
    this.actionId,
    this.metadata,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'general',
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
      icon: json['icon'],
      actionType: json['actionType'],
      actionId: json['actionId'],
      metadata: json['metadata'] != null ? Map<String, dynamic>.from(json['metadata']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'icon': icon,
      'actionType': actionType,
      'actionId': actionId,
      'metadata': metadata,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    DateTime? timestamp,
    bool? isRead,
    String? icon,
    String? actionType,
    String? actionId,
    Map<String, dynamic>? metadata,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      icon: icon ?? this.icon,
      actionType: actionType ?? this.actionType,
      actionId: actionId ?? this.actionId,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get isUnread => !isRead;
}
