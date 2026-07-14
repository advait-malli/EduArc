import '../models/timetable.dart';
import '../models/calendar.dart';
import '../services/api_service.dart';
import 'interfaces.dart';

class TimetableRepository implements ITimetableRepository {
  final ApiService _api = ApiService();

  @override
  Future<List<TimetableClass>> getTimetable({int? dayOfWeek}) async {
    final List<Map<String, dynamic>> timetableJson = await _api.getTimetableList();
    final classes = timetableJson.map((json) => TimetableClass.fromJson(json)).toList();
    if (dayOfWeek != null) {
      return classes.where((c) => c.dayOfWeek == dayOfWeek).toList();
    }
    return classes;
  }

  @override
  Future<List<TimetableClass>> getTodayClasses() async {
    final dayOfWeek = DateTime.now().weekday;
    return getTimetable(dayOfWeek: dayOfWeek);
  }

  @override
  Future<List<TimetableClass>> getTomorrowClasses() async {
    final dayOfWeek = DateTime.now().add(const Duration(days: 1)).weekday;
    return getTimetable(dayOfWeek: dayOfWeek);
  }

  @override
  Future<List<String>> getDaysOfWeek() async {
    final classes = await getTimetable();
    final days = classes.map((c) => c.dayOfWeek).toSet().toList()..sort();
    const names = ['', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days.map((d) => names[d]).toList();
  }
}

class CalendarRepository implements ICalendarRepository {
  final ApiService _api = ApiService();

  @override
  Future<List<CalendarEvent>> getCalendarEvents({DateTime? startDate, DateTime? endDate}) async {
    final List<Map<String, dynamic>> eventsJson = await _api.getCalendarEvents();
    return eventsJson.map((json) => CalendarEvent.fromJson(json)).toList();
  }

  @override
  Future<List<CalendarEvent>> getUpcomingEvents({int limit = 5}) async {
    final events = await getCalendarEvents();
    final now = DateTime.now();
    final upcoming = events.where((e) => e.endDate.isAfter(now)).toList();
    upcoming.sort((a, b) => a.startDate.compareTo(b.startDate));
    return upcoming.take(limit).toList();
  }
}

class NewsRepository implements INewsRepository {
  final ApiService _api = ApiService();

  @override
  Future<List<NewsItem>> getNewsList({int limit = 10}) async {
    final List<Map<String, dynamic>> newsJson = await _api.getNewsList();
    final news = newsJson.map((json) => NewsItem.fromJson(json)).toList();
    return news.take(limit).toList();
  }

  Future<List<NewsItem>> getCirculars({int limit = 20}) async {
    final List<Map<String, dynamic>> newsJson = await _api.getNewsList(category: 'circular');
    final news = newsJson.map((json) => NewsItem.fromJson(json)).toList();
    return news.take(limit).toList();
  }
}
