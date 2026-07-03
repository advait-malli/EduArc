class ApiConstants {
  // Base URL - Update this to your backend URL
  static const String baseUrl = 'http://localhost:8080/api';
  
  // API version
  static const String apiVersion = '/v1';
  
  // Endpoints
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String register = '/auth/register';
  
  static const String user = '/user';
  static const String userProfile = '/user/profile';
  
  static const String homework = '/homework';
  static const String homeworkList = '/homework/list';
  static const String homeworkCreate = '/homework/create';
  static const String homeworkSubmit = '/homework/submit';
  
  static const String messages = '/messages';
  static const String messagesList = '/messages/list';
  static const String messagesSend = '/messages/send';
  
  static const String notifications = '/notifications';
  static const String notificationsList = '/notifications/list';
  static const String notificationsMarkRead = '/notifications/mark-read';
  
  static const String attendance = '/attendance';
  static const String attendanceList = '/attendance/list';
  
  static const String timetable = '/timetable';
  static const String timetableList = '/timetable/list';
  
  static const String calendar = '/calendar';
  static const String calendarEvents = '/calendar/events';
  
  static const String news = '/news';
  static const String newsList = '/news/list';
  
  // Timeout settings
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
