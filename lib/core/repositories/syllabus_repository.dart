import '../models/syllabus.dart';
import '../services/api_service.dart';
import 'interfaces.dart';

class SyllabusRepository implements ISyllabusRepository {
  final ApiService _api = ApiService();

  @override
  Future<List<Syllabus>> getSyllabus() async {
    final List<Map<String, dynamic>> syllabusJson = await _api.getSyllabusList();
    return syllabusJson.map((json) => Syllabus.fromJson(json)).toList();
  }
}
