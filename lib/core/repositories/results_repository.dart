import '../models/exam_result.dart';
import '../services/api_service.dart';
import 'interfaces.dart';

class ResultsRepository implements IResultsRepository {
  final ApiService _api = ApiService();

  @override
  Future<List<ExamResult>> getResults() async {
    final List<Map<String, dynamic>> resultsJson = await _api.getResultsList();
    return resultsJson.map((json) => ExamResult.fromJson(json)).toList();
  }
}
