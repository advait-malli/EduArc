import '../models/user.dart';
import '../services/api_service.dart';
import 'interfaces.dart';

class UserRepository implements IUserRepository {
  final ApiService _api = ApiService();

  @override
  Future<User> getCurrentUser() async {
    final data = await _api.getUserProfile();
    return User.fromJson(data);
  }

  @override
  Future<Map<String, String>> getUserProfile() async {
    final data = await _api.getUserProfile();
    return data.map((k, v) => MapEntry(k, v.toString()));
  }
}
