import '../models/attendance.dart';
import '../services/api_service.dart';
import 'interfaces.dart';

class AttendanceRepository implements IAttendanceRepository {
  final ApiService _api = ApiService();

  @override
  Future<List<AttendanceRecord>> getAttendanceRecords({int days = 30}) async {
    final List<Map<String, dynamic>> attendanceJson = await _api.getAttendanceList();
    return attendanceJson.map((json) => AttendanceRecord.fromJson(json)).toList();
  }

  @override
  Future<AttendanceSummary> getAttendanceSummary({int days = 30}) async {
    final records = await getAttendanceRecords(days: days);
    return AttendanceSummary.fromRecords(records);
  }

  @override
  Future<double> getAttendancePercentage({int days = 30}) async {
    final summary = await getAttendanceSummary(days: days);
    return summary.percentage;
  }
}
