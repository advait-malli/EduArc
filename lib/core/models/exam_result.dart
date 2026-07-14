class ExamResult {
  final String id;
  final String examName;
  final String examType;
  final List<ExamSubject> subjects;
  final int totalMarks;
  final int obtainedMarks;
  final double percentage;
  final String grade;
  final DateTime examDate;
  final String? remarks;

  ExamResult({
    required this.id,
    required this.examName,
    required this.examType,
    required this.subjects,
    required this.totalMarks,
    required this.obtainedMarks,
    required this.percentage,
    required this.grade,
    required this.examDate,
    this.remarks,
  });

  factory ExamResult.fromJson(Map<String, dynamic> json) {
    return ExamResult(
      id: json['id'] ?? '',
      examName: json['examName'] ?? '',
      examType: json['examType'] ?? '',
      subjects: (json['subjects'] as List<dynamic>?)
              ?.map((s) => ExamSubject.fromJson(s))
              .toList() ??
          [],
      totalMarks: json['totalMarks'] ?? 0,
      obtainedMarks: json['obtainedMarks'] ?? 0,
      percentage: (json['percentage'] ?? 0).toDouble(),
      grade: json['grade'] ?? '',
      examDate: DateTime.parse(json['examDate']),
      remarks: json['remarks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'examName': examName,
      'examType': examType,
      'subjects': subjects.map((s) => s.toJson()).toList(),
      'totalMarks': totalMarks,
      'obtainedMarks': obtainedMarks,
      'percentage': percentage,
      'grade': grade,
      'examDate': examDate.toIso8601String(),
      'remarks': remarks,
    };
  }
}

class ExamSubject {
  final String subject;
  final int marksObtained;
  final int maxMarks;
  final String grade;
  final String? remarks;

  ExamSubject({
    required this.subject,
    required this.marksObtained,
    required this.maxMarks,
    required this.grade,
    this.remarks,
  });

  double get percentage => maxMarks > 0 ? (marksObtained / maxMarks) * 100 : 0;

  factory ExamSubject.fromJson(Map<String, dynamic> json) {
    return ExamSubject(
      subject: json['subject'] ?? '',
      marksObtained: json['marksObtained'] ?? 0,
      maxMarks: json['maxMarks'] ?? 100,
      grade: json['grade'] ?? '',
      remarks: json['remarks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'marksObtained': marksObtained,
      'maxMarks': maxMarks,
      'grade': grade,
      'remarks': remarks,
    };
  }
}
