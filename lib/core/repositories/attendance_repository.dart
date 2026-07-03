import '../models/attendance.dart';
import '../services/api_service.dart';

/// Repository for Attendance data access
/// 
/// Backend developers: This is where you integrate with your backend API.
class AttendanceRepository {
  final ApiService _api = ApiService();

  /// Get attendance records
  /// 
  /// Expected API response format:
  /// {
  ///   "attendance": [
  ///     {
  ///       "id": "string",
  ///       "date": "ISO8601 date",
  ///       "status": "Present|Absent|Leave|Late",
  ///       "totalClasses": number,
  ///       "attendedClasses": number (optional),
  ///       "subject": "string (optional)",
  ///       "notes": "string (optional)"
  ///     }
  ///   ]
  /// }
  Future<List<AttendanceRecord>> getAttendanceRecords({int days = 30}) async {
    try {
      final List<Map<String, dynamic>> attendanceJson = await _api.getAttendanceList();
      return attendanceJson.map((json) => AttendanceRecord.fromJson(json)).toList();
    } catch (e) {
      return _getMockAttendanceRecords();
    }
  }

  /// Get attendance summary
  Future<AttendanceSummary> getAttendanceSummary({int days = 30}) async {
    final records = await getAttendanceRecords(days: days);
    return AttendanceSummary.fromRecords(records);
  }

  /// Get attendance percentage
  Future<double> getAttendancePercentage({int days = 30}) async {
    final summary = await getAttendanceSummary(days: days);
    return summary.percentage;
  }

  // Mock data for development - Backend: Remove this
  List<AttendanceRecord> _getMockAttendanceRecords() {
    final now = DateTime.now();
    return [
      AttendanceRecord(
        id: '1',
        date: now.subtract(const Duration(days: 1)),
        status: 'Present',
        totalClasses: 6,
        attendedClasses: 6,
      ),
      AttendanceRecord(
        id: '2',
        date: now.subtract(const Duration(days: 2)),
        status: 'Leave',
        totalClasses: 6,
        attendedClasses: 0,
      ),
      AttendanceRecord(
        id: '3',
        date: now.subtract(const Duration(days: 3)),
        status: 'Present',
        totalClasses: 6,
        attendedClasses: 6,
      ),
      AttendanceRecord(
        id: '4',
        date: now.subtract(const Duration(days: 4)),
        status: 'Present',
        totalClasses: 6,
        attendedClasses: 6,
      ),
      AttendanceRecord(
        id: '5',
        date: now.subtract(const Duration(days: 5)),
        status: 'Absent',
        totalClasses: 6,
        attendedClasses: 0,
      ),
      AttendanceRecord(
        id: '6',
        date: now.subtract(const Duration(days: 6)),
        status: 'Present',
        totalClasses: 6,
        attendedClasses: 6,
      ),
      AttendanceRecord(
        id: '7',
        date: now.subtract(const Duration(days: 7)),
        status: 'Present',
        totalClasses: 6,
        attendedClasses: 6,
      ),
    ];
  }
}
