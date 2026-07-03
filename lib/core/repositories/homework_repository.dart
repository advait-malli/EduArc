import '../models/homework.dart';
import '../services/api_service.dart';

/// Repository for Homework data access
/// 
/// Backend developers: This is where you integrate with your backend API.
/// The methods below show the expected data structure and return types.
class HomeworkRepository {
  final ApiService _api = ApiService();

  /// Get list of homework assignments
  /// 
  /// Expected API response format:
  /// {
  ///   "homework": [
  ///     {
  ///       "id": "string",
  ///       "title": "string",
  ///       "subject": "string",
  ///       "description": "string",
  ///       "dueDate": "ISO8601 date",
  ///       "status": "Pending|Submitted|Graded",
  ///       "subjectIcon": "icon_name (optional)"
  ///     }
  ///   ]
  /// }
  Future<List<Homework>> getHomeworkList() async {
    try {
      final List<Map<String, dynamic>> homeworkJson = await _api.getHomeworkList();
      return homeworkJson.map((json) => Homework.fromJson(json)).toList();
    } catch (e) {
      // Return mock data for development
      // Backend: Remove this and throw the error
      return _getMockHomework();
    }
  }

  /// Create a new homework assignment (Teacher only)
  Future<Homework> createHomework({
    required String title,
    required String subject,
    required String description,
    required DateTime dueDate,
    String? subjectIcon,
  }) async {
    try {
      final response = await _api.createHomework({
        'title': title,
        'subject': subject,
        'description': description,
        'dueDate': dueDate.toIso8601String(),
        'subjectIcon': subjectIcon,
      });
      return Homework.fromJson(response);
    } catch (e) {
      // Mock for development
      return Homework(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        subject: subject,
        description: description,
        dueDate: dueDate,
        status: 'Pending',
        subjectIcon: subjectIcon,
      );
    }
  }

  /// Submit homework assignment
  Future<bool> submitHomework(String homeworkId) async {
    try {
      await _api.submitHomework(homeworkId);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get homework by ID
  Future<Homework?> getHomeworkById(String id) async {
    final homeworkList = await getHomeworkList();
    return homeworkList.where((h) => h.id == id).firstOrNull;
  }

  /// Get pending homework count
  Future<int> getPendingCount() async {
    final homeworkList = await getHomeworkList();
    return homeworkList.where((h) => h.isPending).length;
  }

  /// Get overdue homework
  Future<List<Homework>> getOverdueHomework() async {
    final homeworkList = await getHomeworkList();
    return homeworkList.where((h) => h.isOverdue).toList();
  }

  // Mock data for development - Backend: Remove this
  List<Homework> _getMockHomework() {
    return [
      Homework(
        id: '1',
        title: 'Revision Jobsheet',
        subject: 'Mathematics',
        description: 'Complete all exercises from chapter 5',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        status: 'Pending',
        subjectIcon: 'calculate',
      ),
      Homework(
        id: '2',
        title: 'Chapter 4 Notes',
        subject: 'Biology',
        description: 'Write detailed notes on cell structure',
        dueDate: DateTime.now().add(const Duration(days: 2)),
        status: 'Pending',
        subjectIcon: 'science',
      ),
      Homework(
        id: '3',
        title: 'Essay on Climate',
        subject: 'English',
        description: 'Write a 500-word essay on climate change',
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
        status: 'Submitted',
        subjectIcon: 'book',
      ),
      Homework(
        id: '4',
        title: 'Lab Report',
        subject: 'Chemistry',
        description: 'Submit the lab report from last week\'s experiment',
        dueDate: DateTime.now().add(const Duration(days: 3)),
        status: 'Pending',
        subjectIcon: 'biotech',
      ),
    ];
  }
}
