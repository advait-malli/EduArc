class Remark {
  final String id;
  final String teacherName;
  final String subject;
  final String remark;
  final String type;
  final DateTime date;

  Remark({
    required this.id,
    required this.teacherName,
    required this.subject,
    required this.remark,
    required this.type,
    required this.date,
  });

  factory Remark.fromJson(Map<String, dynamic> json) {
    return Remark(
      id: json['id'] ?? '',
      teacherName: json['teacherName'] ?? '',
      subject: json['subject'] ?? '',
      remark: json['remark'] ?? '',
      type: json['type'] ?? 'General',
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teacherName': teacherName,
      'subject': subject,
      'remark': remark,
      'type': type,
      'date': date.toIso8601String(),
    };
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime date;
  final String awardedBy;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.awardedBy,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'Other',
      date: DateTime.parse(json['date']),
      awardedBy: json['awardedBy'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'date': date.toIso8601String(),
      'awardedBy': awardedBy,
    };
  }
}
