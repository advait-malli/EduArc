import '../models/remark.dart';
import '../services/api_service.dart';
import 'interfaces.dart';

class RemarksRepository implements IRemarksRepository {
  final ApiService _api = ApiService();

  @override
  Future<List<Remark>> getRemarks() async {
    final List<Map<String, dynamic>> remarksJson = await _api.getRemarksList();
    return remarksJson.map((json) => Remark.fromJson(json)).toList();
  }

  @override
  Future<List<Achievement>> getAchievements() async {
    final List<Map<String, dynamic>> achievementsJson = await _api.getAchievementsList();
    return achievementsJson.map((json) => Achievement.fromJson(json)).toList();
  }
}
