import '../models/timetable.dart';
import '../models/calendar.dart';
import '../services/api_service.dart';

/// Repository for Timetable data access
class TimetableRepository {
  final ApiService _api = ApiService();

  /// Get timetable classes
  /// 
  /// Expected API response format:
  /// {
  ///   "timetable": [
  ///     {
  ///       "id": "string",
  ///       "subject": "string",
  ///       "startTime": "HH:mm",
  ///       "endTime": "HH:mm",
  ///       "room": "string",
  ///       "teacherName": "string (optional)",
  ///       "dayOfWeek": number (1-7, Monday-Sunday),
  ///       "icon": "icon_name (optional)"
  ///     }
  ///   ]
  /// }
  Future<List<TimetableClass>> getTimetable({int? dayOfWeek}) async {
    try {
      final List<Map<String, dynamic>> timetableJson = await _api.getTimetableList();
      final classes = timetableJson.map((json) => TimetableClass.fromJson(json)).toList();
      
      if (dayOfWeek != null) {
        return classes.where((c) => c.dayOfWeek == dayOfWeek).toList();
      }
      return classes;
    } catch (e) {
      return _getMockTimetable(dayOfWeek);
    }
  }

  /// Get today's classes
  Future<List<TimetableClass>> getTodayClasses() async {
    final now = DateTime.now();
    // Convert to 1-7 (Monday-Sunday)
    int dayOfWeek = now.weekday;
    return getTimetable(dayOfWeek: dayOfWeek);
  }

  /// Get tomorrow's classes
  Future<List<TimetableClass>> getTomorrowClasses() async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    int dayOfWeek = tomorrow.weekday;
    return getTimetable(dayOfWeek: dayOfWeek);
  }

  // Mock data for development - Backend: Remove this
  List<TimetableClass> _getMockTimetable(int? dayOfWeek) {
    final todayClasses = [
      TimetableClass(
        id: 't1',
        subject: 'Mathematics',
        startTime: '09:00',
        endTime: '10:00',
        room: 'Room 101',
        teacherName: 'Mr. Smith',
        icon: 'calculate',
        dayOfWeek: 1,
      ),
      TimetableClass(
        id: 't2',
        subject: 'Biology',
        startTime: '10:30',
        endTime: '11:30',
        room: 'Lab 3',
        teacherName: 'Ms. Johnson',
        icon: 'science',
        dayOfWeek: 1,
      ),
      TimetableClass(
        id: 't3',
        subject: 'English',
        startTime: '12:00',
        endTime: '13:00',
        room: 'Room 205',
        teacherName: 'Mrs. Williams',
        icon: 'book',
        dayOfWeek: 1,
      ),
    ];

    final tomorrowClasses = [
      TimetableClass(
        id: 't4',
        subject: 'Chemistry',
        startTime: '09:00',
        endTime: '10:00',
        room: 'Lab 1',
        teacherName: 'Dr. Brown',
        icon: 'biotech',
        dayOfWeek: 2,
      ),
      TimetableClass(
        id: 't5',
        subject: 'Physics',
        startTime: '10:30',
        endTime: '11:30',
        room: 'Room 302',
        teacherName: 'Mr. Davis',
        icon: 'flash_on',
        dayOfWeek: 2,
      ),
    ];

    if (dayOfWeek == null) {
      return [...todayClasses, ...tomorrowClasses];
    }
    
    return dayOfWeek == 1 ? todayClasses : tomorrowClasses;
  }
}

/// Repository for Calendar data access
class CalendarRepository {
  final ApiService _api = ApiService();

  /// Get calendar events
  /// 
  /// Expected API response format:
  /// {
  ///   "events": [
  ///     {
  ///       "id": "string",
  ///       "title": "string",
  ///       "description": "string",
  ///       "startDate": "ISO8601 date",
  ///       "endDate": "ISO8601 date",
  ///       "type": "exam|holiday|event|deadline",
  ///       "location": "string (optional)",
  ///       "icon": "icon_name (optional)",
  ///       "isAllDay": boolean
  ///     }
  ///   ]
  /// }
  Future<List<CalendarEvent>> getCalendarEvents({DateTime? startDate, DateTime? endDate}) async {
    try {
      final List<Map<String, dynamic>> eventsJson = await _api.getCalendarEvents();
      return eventsJson.map((json) => CalendarEvent.fromJson(json)).toList();
    } catch (e) {
      return _getMockEvents();
    }
  }

  /// Get upcoming events
  Future<List<CalendarEvent>> getUpcomingEvents({int limit = 5}) async {
    final events = await getCalendarEvents();
    final now = DateTime.now();
    final upcoming = events.where((e) => e.endDate.isAfter(now)).toList();
    upcoming.sort((a, b) => a.startDate.compareTo(b.startDate));
    return upcoming.take(limit).toList();
  }

  // Mock data for development - Backend: Remove this
  List<CalendarEvent> _getMockEvents() {
    final now = DateTime.now();
    return [
      CalendarEvent(
        id: 'e1',
        title: 'Science Fair',
        description: 'Annual science fair competition',
        startDate: DateTime(now.year, now.month, now.day + 5, 9, 0),
        endDate: DateTime(now.year, now.month, now.day + 5, 15, 0),
        type: 'event',
        location: 'Main Hall',
        icon: 'science',
        isAllDay: false,
      ),
      CalendarEvent(
        id: 'e2',
        title: 'Parent Meeting',
        description: 'Parent-teacher meeting',
        startDate: DateTime(now.year, now.month, now.day + 8, 14, 0),
        endDate: DateTime(now.year, now.month, now.day + 8, 17, 0),
        type: 'event',
        location: 'Conference Room',
        icon: 'people',
        isAllDay: false,
      ),
      CalendarEvent(
        id: 'e3',
        title: 'Sports Day',
        description: 'Annual sports day',
        startDate: DateTime(now.year, now.month, now.day + 15, 8, 0),
        endDate: DateTime(now.year, now.month, now.day + 15, 16, 0),
        type: 'event',
        location: 'Sports Ground',
        icon: 'sports',
        isAllDay: true,
      ),
    ];
  }
}

/// Repository for News/Circulars data access
class NewsRepository {
  final ApiService _api = ApiService();

  /// Get news items
  /// 
  /// Expected API response format:
  /// {
  ///   "news": [
  ///     {
  ///       "id": "string",
  ///       "title": "string",
  ///       "summary": "string",
  ///       "content": "string",
  ///       "publishedDate": "ISO8601 date",
  ///       "category": "circular|news|announcement",
  ///       "imageUrl": "string (optional)",
  ///       "author": "string (optional)",
  ///       "isImportant": boolean
  ///     }
  ///   ]
  /// }
  Future<List<NewsItem>> getNewsList({int limit = 10}) async {
    try {
      final List<Map<String, dynamic>> newsJson = await _api.getNewsList();
      final news = newsJson.map((json) => NewsItem.fromJson(json)).toList();
      return news.take(limit).toList();
    } catch (e) {
      return _getMockNews();
    }
  }

  // Mock data for development - Backend: Remove this
  List<NewsItem> _getMockNews() {
    final now = DateTime.now();
    return [
      NewsItem(
        id: 'n1',
        title: 'Science Fair Registration',
        summary: 'Register now for the annual science fair',
        content: 'The annual science fair will be held next month. All students are encouraged to participate.',
        publishedDate: now.subtract(const Duration(days: 3)),
        category: 'circular',
        author: 'Admin',
        isImportant: true,
      ),
      NewsItem(
        id: 'n2',
        title: 'Sports Day Announcement',
        summary: 'Sports day scheduled for next week',
        content: 'The annual sports day will be held on the school grounds.',
        publishedDate: now.subtract(const Duration(days: 6)),
        category: 'announcement',
        author: 'Sports Department',
        isImportant: false,
      ),
      NewsItem(
        id: 'n3',
        title: 'Library Hours Extended',
        summary: 'Library now open until 6 PM',
        content: 'Due to popular demand, the library hours have been extended.',
        publishedDate: now.subtract(const Duration(days: 8)),
        category: 'news',
        author: 'Library',
        isImportant: false,
      ),
    ];
  }
}
