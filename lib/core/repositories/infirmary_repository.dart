import '../models/infirmary.dart';
import '../services/api_service.dart';
import 'interfaces.dart';

class InfirmaryRepository implements IInfirmaryRepository {
  final ApiService _api = ApiService();

  @override
  Future<List<InfirmaryVisit>> getVisits() async {
    final List<Map<String, dynamic>> visitsJson = await _api.getInfirmaryVisits();
    return visitsJson.map((json) => InfirmaryVisit.fromJson(json)).toList();
  }

  @override
  Future<HealthProfile?> getHealthProfile() async {
    try {
      final data = await _api.getInfirmaryProfile();
      final profile = data['profile'];
      if (profile == null) return null;
      return HealthProfile.fromJson(profile);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> reportVisit({
    required String reason,
    required String description,
    String? nurseName,
    String? medication,
    String? followUp,
  }) async {
    await _api.reportInfirmaryVisit({
      'reason': reason,
      'description': description,
      if (nurseName != null) 'nurseName': nurseName,
      if (medication != null) 'medication': medication,
      if (followUp != null) 'followUp': followUp,
    });
    return true;
  }
}
