class CalendarEvent {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String type; // 'exam', 'holiday', 'event', 'deadline'
  final String? location;
  final String? icon;
  final bool isAllDay;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.type,
    this.location,
    this.icon,
    this.isAllDay = false,
  });

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      type: json['type'] ?? 'event',
      location: json['location'],
      icon: json['icon'],
      isAllDay: json['isAllDay'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'type': type,
      'location': location,
      'icon': icon,
      'isAllDay': isAllDay,
    };
  }

  CalendarEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    String? location,
    String? icon,
    bool? isAllDay,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      type: type ?? this.type,
      location: location ?? this.location,
      icon: icon ?? this.icon,
      isAllDay: isAllDay ?? this.isAllDay,
    );
  }
}

class NewsItem {
  final String id;
  final String title;
  final String content;
  final String summary;
  final DateTime publishedDate;
  final String category; // 'circular', 'news', 'announcement'
  final String? imageUrl;
  final String? author;
  final bool isImportant;

  NewsItem({
    required this.id,
    required this.title,
    required this.content,
    required this.summary,
    required this.publishedDate,
    required this.category,
    this.imageUrl,
    this.author,
    this.isImportant = false,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      summary: json['summary'] ?? '',
      publishedDate: DateTime.parse(json['publishedDate']),
      category: json['category'] ?? 'news',
      imageUrl: json['imageUrl'],
      author: json['author'],
      isImportant: json['isImportant'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'summary': summary,
      'publishedDate': publishedDate.toIso8601String(),
      'category': category,
      'imageUrl': imageUrl,
      'author': author,
      'isImportant': isImportant,
    };
  }

  NewsItem copyWith({
    String? id,
    String? title,
    String? content,
    String? summary,
    DateTime? publishedDate,
    String? category,
    String? imageUrl,
    String? author,
    bool? isImportant,
  }) {
    return NewsItem(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      summary: summary ?? this.summary,
      publishedDate: publishedDate ?? this.publishedDate,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      author: author ?? this.author,
      isImportant: isImportant ?? this.isImportant,
    );
  }
}
