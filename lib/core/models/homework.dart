class Homework {
  final String id;
  final String title;
  final String subject;
  final String description;
  final DateTime dueDate;
  final String status; // 'Pending', 'Submitted', 'Graded'
  final String? subjectIcon; // Icon name as string
  final DateTime? createdAt;
  final DateTime? submittedAt;
  final double? grade;
  final String? feedback;
  final String? createdBy; // Teacher who created the homework
  final String? assignedTo; // Student who must submit

  Homework({
    required this.id,
    required this.title,
    required this.subject,
    required this.description,
    required this.dueDate,
    required this.status,
    this.subjectIcon,
    this.createdAt,
    this.submittedAt,
    this.grade,
    this.feedback,
    this.createdBy,
    this.assignedTo,
  });

  factory Homework.fromJson(Map<String, dynamic> json) {
    return Homework(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subject: json['subject'] ?? '',
      description: json['description'] ?? '',
      dueDate: DateTime.parse(json['dueDate']),
      status: json['status'] ?? 'Pending',
      subjectIcon: json['subjectIcon'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      submittedAt: json['submittedAt'] != null ? DateTime.parse(json['submittedAt']) : null,
      grade: json['grade'] != null ? (json['grade'] as num).toDouble() : null,
      feedback: json['feedback'],
      createdBy: json['createdBy'],
      assignedTo: json['assignedTo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'status': status,
      'subjectIcon': subjectIcon,
      'createdAt': createdAt?.toIso8601String(),
      'submittedAt': submittedAt?.toIso8601String(),
      'grade': grade,
      'feedback': feedback,
      'createdBy': createdBy,
      'assignedTo': assignedTo,
    };
  }

  Homework copyWith({
    String? id,
    String? title,
    String? subject,
    String? description,
    DateTime? dueDate,
    String? status,
    String? subjectIcon,
    DateTime? createdAt,
    DateTime? submittedAt,
    double? grade,
    String? feedback,
    String? createdBy,
    String? assignedTo,
  }) {
    return Homework(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      subjectIcon: subjectIcon ?? this.subjectIcon,
      createdAt: createdAt ?? this.createdAt,
      submittedAt: submittedAt ?? this.submittedAt,
      grade: grade ?? this.grade,
      feedback: feedback ?? this.feedback,
      createdBy: createdBy ?? this.createdBy,
      assignedTo: assignedTo ?? this.assignedTo,
    );
  }

  bool get isOverdue => DateTime.now().isAfter(dueDate) && status != 'Submitted';
  bool get isPending => status == 'Pending';
  bool get isSubmitted => status == 'Submitted';
  bool get isGraded => status == 'Graded';
}
