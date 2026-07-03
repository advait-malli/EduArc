class AttendanceRecord {
  final String id;
  final DateTime date;
  final String status; // 'Present', 'Absent', 'Leave', 'Late'
  final int totalClasses;
  final int? attendedClasses;
  final String? subject;
  final String? notes;

  AttendanceRecord({
    required this.id,
    required this.date,
    required this.status,
    required this.totalClasses,
    this.attendedClasses,
    this.subject,
    this.notes,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] ?? '',
      date: DateTime.parse(json['date']),
      status: json['status'] ?? 'Present',
      totalClasses: json['totalClasses'] ?? 0,
      attendedClasses: json['attendedClasses'],
      subject: json['subject'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'status': status,
      'totalClasses': totalClasses,
      'attendedClasses': attendedClasses,
      'subject': subject,
      'notes': notes,
    };
  }

  AttendanceRecord copyWith({
    String? id,
    DateTime? date,
    String? status,
    int? totalClasses,
    int? attendedClasses,
    String? subject,
    String? notes,
  }) {
    return AttendanceRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      status: status ?? this.status,
      totalClasses: totalClasses ?? this.totalClasses,
      attendedClasses: attendedClasses ?? this.attendedClasses,
      subject: subject ?? this.subject,
      notes: notes ?? this.notes,
    );
  }

  bool get isPresent => status == 'Present';
  bool get isAbsent => status == 'Absent';
  bool get isLeave => status == 'Leave';
  bool get isLate => status == 'Late';
}

class AttendanceSummary {
  final int totalDays;
  final int presentDays;
  final int absentDays;
  final int leaveDays;
  final double percentage;

  AttendanceSummary({
    required this.totalDays,
    required this.presentDays,
    required this.absentDays,
    required this.leaveDays,
    required this.percentage,
  });

  factory AttendanceSummary.fromRecords(List<AttendanceRecord> records) {
    final presentDays = records.where((r) => r.isPresent).length;
    final absentDays = records.where((r) => r.isAbsent).length;
    final leaveDays = records.where((r) => r.isLeave).length;
    final totalDays = records.length;
    final percentage = totalDays > 0 ? (presentDays / totalDays) * 100 : 0;

    return AttendanceSummary(
      totalDays: totalDays,
      presentDays: presentDays,
      absentDays: absentDays,
      leaveDays: leaveDays,
      percentage: percentage,
    );
  }
}
