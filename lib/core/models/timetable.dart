class TimetableClass {
  final String id;
  final String subject;
  final String startTime; // e.g., '09:00'
  final String endTime; // e.g., '10:00'
  final String room;
  final String? teacherName;
  final String? icon; // Icon name as string
  final int dayOfWeek; // 1 = Monday, 7 = Sunday

  TimetableClass({
    required this.id,
    required this.subject,
    required this.startTime,
    required this.endTime,
    required this.room,
    this.teacherName,
    this.icon,
    required this.dayOfWeek,
  });

  factory TimetableClass.fromJson(Map<String, dynamic> json) {
    return TimetableClass(
      id: json['id'] ?? '',
      subject: json['subject'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      room: json['room'] ?? '',
      teacherName: json['teacherName'],
      icon: json['icon'],
      dayOfWeek: json['dayOfWeek'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'startTime': startTime,
      'endTime': endTime,
      'room': room,
      'teacherName': teacherName,
      'icon': icon,
      'dayOfWeek': dayOfWeek,
    };
  }

  TimetableClass copyWith({
    String? id,
    String? subject,
    String? startTime,
    String? endTime,
    String? room,
    String? teacherName,
    String? icon,
    int? dayOfWeek,
  }) {
    return TimetableClass(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      room: room ?? this.room,
      teacherName: teacherName ?? this.teacherName,
      icon: icon ?? this.icon,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
    );
  }
}

class TimetableDay {
  final DateTime date;
  final List<TimetableClass> classes;

  TimetableDay({
    required this.date,
    required this.classes,
  });

  factory TimetableDay.fromJson(Map<String, dynamic> json) {
    final classesJson = json['classes'] as List<dynamic>? ?? [];
    final classes = classesJson
        .map((c) => TimetableClass.fromJson(Map<String, dynamic>.from(c)))
        .toList();

    return TimetableDay(
      date: DateTime.parse(json['date']),
      classes: classes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'classes': classes.map((c) => c.toJson()).toList(),
    };
  }
}
