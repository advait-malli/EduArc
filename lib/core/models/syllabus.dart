class Syllabus {
  final String id;
  final String subject;
  final String className;
  final List<SyllabusChapter> chapters;

  Syllabus({
    required this.id,
    required this.subject,
    required this.className,
    required this.chapters,
  });

  factory Syllabus.fromJson(Map<String, dynamic> json) {
    return Syllabus(
      id: json['id'] ?? '',
      subject: json['subject'] ?? '',
      className: json['className'] ?? '',
      chapters: (json['chapters'] as List<dynamic>?)
              ?.map((c) => SyllabusChapter.fromJson(c))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'className': className,
      'chapters': chapters.map((c) => c.toJson()).toList(),
    };
  }

  int get completedChapters => chapters.where((c) => c.status == 'Completed').length;
  int get totalChapters => chapters.length;
  double get overallProgress =>
      chapters.isEmpty ? 0 : chapters.map((c) => c.progress).reduce((a, b) => a + b) / chapters.length;
}

class SyllabusChapter {
  final String id;
  final String title;
  final String description;
  final String status;
  final int progress;
  final List<String> topics;

  SyllabusChapter({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.progress,
    required this.topics,
  });

  factory SyllabusChapter.fromJson(Map<String, dynamic> json) {
    return SyllabusChapter(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'Upcoming',
      progress: json['progress'] ?? 0,
      topics: (json['topics'] as List<dynamic>?)
              ?.map((t) => t.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'progress': progress,
      'topics': topics,
    };
  }
}
