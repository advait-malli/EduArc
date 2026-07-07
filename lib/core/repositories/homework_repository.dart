import '../models/homework.dart';
import '../services/api_service.dart';
import 'interfaces.dart';

class HomeworkRepository implements IHomeworkRepository {
  final ApiService _api = ApiService();

  @override
  Future<List<Homework>> getHomeworkList() async {
    final List<Map<String, dynamic>> homeworkJson = await _api.getHomeworkList();
    return homeworkJson.map((json) => Homework.fromJson(json)).toList();
  }

  @override
  Future<Homework> createHomework({
    required String title, required String subject,
    required String description, required DateTime dueDate,
    required String assignedTo,
    String? subjectIcon,
  }) async {
    final response = await _api.createHomework({
      'title': title, 'subject': subject, 'description': description,
      'dueDate': dueDate.toIso8601String(), 'subjectIcon': subjectIcon,
      'assignedTo': assignedTo,
    });
    return Homework.fromJson(response);
  }

  @override
  Future<bool> submitHomework(String homeworkId) async {
    await _api.submitHomework(homeworkId);
    return true;
  }

  @override
  Future<Homework?> getHomeworkById(String id) async {
    final homeworkList = await getHomeworkList();
    return homeworkList.where((h) => h.id == id).firstOrNull;
  }

  @override
  Future<int> getPendingCount() async {
    final homeworkList = await getHomeworkList();
    return homeworkList.where((h) => h.isPending).length;
  }

  @override
  Future<List<Homework>> getOverdueHomework() async {
    final homeworkList = await getHomeworkList();
    return homeworkList.where((h) => h.isOverdue).toList();
  }
}
