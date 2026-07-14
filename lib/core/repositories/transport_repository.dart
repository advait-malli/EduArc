import '../models/transport.dart';
import '../services/api_service.dart';
import 'interfaces.dart';

class TransportRepository implements ITransportRepository {
  final ApiService _api = ApiService();

  @override
  Future<TransportInfo?> getTransportInfo() async {
    try {
      final data = await _api.getTransport();
      final transport = data['transport'];
      if (transport == null) return null;
      return TransportInfo.fromJson(transport);
    } catch (e) {
      return null;
    }
  }
}
