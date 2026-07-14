import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../services/auth_service.dart';

/// API Service for making HTTP requests to the backend
/// 
/// Backend developers should update the [ApiConstants] base URL
/// and implement the endpoints as defined in the constants file.
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Get authentication headers with token
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await AuthService.getToken();
    if (token != null && token.isNotEmpty) {
      return {
        ..._headers,
        'Authorization': 'Bearer $token',
      };
    }
    return _headers;
  }

  // ==================== AUTH ENDPOINTS ====================

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}'),
      headers: _headers,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    return _handleResponse(response);
  }

  Future<void> logout() async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.logout}'),
      headers: await _getAuthHeaders(),
    );
    _handleResponse(response);
  }

  // ==================== USER ENDPOINTS ====================

  Future<Map<String, dynamic>> getUserProfile() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.userProfile}'),
      headers: await _getAuthHeaders(),
    );
    return _handleResponse(response);
  }

  // ==================== HOMEWORK ENDPOINTS ====================

  Future<List<Map<String, dynamic>>> getHomeworkList() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.homeworkList}'),
      headers: await _getAuthHeaders(),
    );
    final data = _handleResponse(response);
    return List<Map<String, dynamic>>.from(data['homework'] ?? []);
  }

  Future<Map<String, dynamic>> createHomework(Map<String, dynamic> homework) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.homeworkCreate}'),
      headers: await _getAuthHeaders(),
      body: jsonEncode(homework),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> submitHomework(String homeworkId) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.homeworkSubmit}'),
      headers: await _getAuthHeaders(),
      body: jsonEncode({'homeworkId': homeworkId}),
    );
    return _handleResponse(response);
  }

  // ==================== MESSAGE ENDPOINTS ====================

  Future<List<Map<String, dynamic>>> getMessages({bool announcements = false}) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.messagesList}?announcements=$announcements'),
      headers: await _getAuthHeaders(),
    );
    final data = _handleResponse(response);
    return List<Map<String, dynamic>>.from(data['messages'] ?? []);
  }

  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> message) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.messagesSend}'),
      headers: await _getAuthHeaders(),
      body: jsonEncode(message),
    );
    return _handleResponse(response);
  }

  Future<void> markMessageAsRead(String messageId) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.messagesMarkRead}'),
      headers: await _getAuthHeaders(),
      body: jsonEncode({'messageId': messageId}),
    );
    _handleResponse(response);
  }

  // ==================== NOTIFICATION ENDPOINTS ====================

  Future<List<Map<String, dynamic>>> getNotifications() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.notificationsList}'),
      headers: await _getAuthHeaders(),
    );
    final data = _handleResponse(response);
    return List<Map<String, dynamic>>.from(data['notifications'] ?? []);
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.notificationsMarkRead}'),
      headers: await _getAuthHeaders(),
      body: jsonEncode({'notificationId': notificationId}),
    );
    _handleResponse(response);
  }

  Future<void> markAllNotificationsAsRead() async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.notificationsMarkRead}/all'),
      headers: await _getAuthHeaders(),
    );
    _handleResponse(response);
  }

  // ==================== ATTENDANCE ENDPOINTS ====================

  Future<List<Map<String, dynamic>>> getAttendanceList() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.attendanceList}'),
      headers: await _getAuthHeaders(),
    );
    final data = _handleResponse(response);
    return List<Map<String, dynamic>>.from(data['attendance'] ?? []);
  }

  // ==================== TIMETABLE ENDPOINTS ====================

  Future<List<Map<String, dynamic>>> getTimetableList() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.timetableList}'),
      headers: await _getAuthHeaders(),
    );
    final data = _handleResponse(response);
    return List<Map<String, dynamic>>.from(data['timetable'] ?? []);
  }

  // ==================== CALENDAR ENDPOINTS ====================

  Future<List<Map<String, dynamic>>> getCalendarEvents() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.calendarEvents}'),
      headers: await _getAuthHeaders(),
    );
    final data = _handleResponse(response);
    return List<Map<String, dynamic>>.from(data['events'] ?? []);
  }

  // ==================== NEWS ENDPOINTS ====================

  Future<List<Map<String, dynamic>>> getNewsList({String? category}) async {
    var url = '${ApiConstants.baseUrl}${ApiConstants.newsList}';
    if (category != null) url += '?category=$category';
    final response = await http.get(
      Uri.parse(url),
      headers: await _getAuthHeaders(),
    );
    final data = _handleResponse(response);
    return List<Map<String, dynamic>>.from(data['news'] ?? []);
  }

  // ==================== TRANSPORT ENDPOINTS ====================

  Future<Map<String, dynamic>> getTransport() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.transport}'),
      headers: await _getAuthHeaders(),
    );
    return _handleResponse(response);
  }

  // ==================== RESULTS ENDPOINTS ====================

  Future<List<Map<String, dynamic>>> getResultsList() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.resultsList}'),
      headers: await _getAuthHeaders(),
    );
    final data = _handleResponse(response);
    return List<Map<String, dynamic>>.from(data['results'] ?? []);
  }

  // ==================== REMARKS ENDPOINTS ====================

  Future<List<Map<String, dynamic>>> getRemarksList() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.remarksList}'),
      headers: await _getAuthHeaders(),
    );
    final data = _handleResponse(response);
    return List<Map<String, dynamic>>.from(data['remarks'] ?? []);
  }

  // ==================== ACHIEVEMENTS ENDPOINTS ====================

  Future<List<Map<String, dynamic>>> getAchievementsList() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.achievementsList}'),
      headers: await _getAuthHeaders(),
    );
    final data = _handleResponse(response);
    return List<Map<String, dynamic>>.from(data['achievements'] ?? []);
  }

  // ==================== SYLLABUS ENDPOINTS ====================

  Future<List<Map<String, dynamic>>> getSyllabusList() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.syllabusList}'),
      headers: await _getAuthHeaders(),
    );
    final data = _handleResponse(response);
    return List<Map<String, dynamic>>.from(data['syllabus'] ?? []);
  }

  // ==================== LIBRARY ENDPOINTS ====================

  Future<List<Map<String, dynamic>>> getLibraryBooks() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.libraryBooks}'),
      headers: await _getAuthHeaders(),
    );
    final data = _handleResponse(response);
    return List<Map<String, dynamic>>.from(data['books'] ?? []);
  }

  Future<List<Map<String, dynamic>>> getLibraryRecords() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.libraryRecords}'),
      headers: await _getAuthHeaders(),
    );
    final data = _handleResponse(response);
    return List<Map<String, dynamic>>.from(data['records'] ?? []);
  }

  Future<Map<String, dynamic>> issueBook(String bookId) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.libraryIssue}'),
      headers: await _getAuthHeaders(),
      body: jsonEncode({'bookId': bookId}),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> returnBook(String recordId) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.libraryReturn}'),
      headers: await _getAuthHeaders(),
      body: jsonEncode({'recordId': recordId}),
    );
    return _handleResponse(response);
  }

  // ==================== INFIRMARY ENDPOINTS ====================

  Future<List<Map<String, dynamic>>> getInfirmaryVisits() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.infirmaryVisits}'),
      headers: await _getAuthHeaders(),
    );
    final data = _handleResponse(response);
    return List<Map<String, dynamic>>.from(data['visits'] ?? []);
  }

  Future<Map<String, dynamic>> getInfirmaryProfile() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.infirmaryProfile}'),
      headers: await _getAuthHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> reportInfirmaryVisit(Map<String, dynamic> visit) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.infirmaryVisit}'),
      headers: await _getAuthHeaders(),
      body: jsonEncode(visit),
    );
    return _handleResponse(response);
  }

  // ==================== HELPER METHODS ====================

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw ApiException(
        message: 'Request failed with status ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}
