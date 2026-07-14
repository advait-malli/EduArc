import '../models/homework.dart';
import '../models/message.dart';
import '../models/timetable.dart';
import '../models/attendance.dart';
import '../models/calendar.dart';
import '../models/notification.dart';
import '../models/user.dart';
import '../models/transport.dart';
import '../models/exam_result.dart';
import '../models/remark.dart';
import '../models/syllabus.dart';
import '../models/library.dart';
import '../models/infirmary.dart';
import '../services/search_service.dart';

abstract class IHomeworkRepository {
  Future<List<Homework>> getHomeworkList();
  Future<Homework> createHomework({
    required String title, required String subject,
    required String description, required DateTime dueDate,
    required String assignedTo,
    String? subjectIcon,
  });
  Future<bool> submitHomework(String homeworkId);
  Future<Homework?> getHomeworkById(String id);
  Future<int> getPendingCount();
  Future<List<Homework>> getOverdueHomework();
}

abstract class IMessageRepository {
  Future<List<Message>> getPersonalMessages();
  Future<List<Message>> getAnnouncements();
  Future<bool> sendMessage({
    required String recipientId, required String subject,
    required String message,
  });
  Future<bool> markAsRead(String messageId);
  Future<int> getUnreadCount();
}

abstract class ITimetableRepository {
  Future<List<TimetableClass>> getTimetable({int? dayOfWeek});
  Future<List<TimetableClass>> getTodayClasses();
  Future<List<TimetableClass>> getTomorrowClasses();
  Future<List<String>> getDaysOfWeek();
}

abstract class IAttendanceRepository {
  Future<List<AttendanceRecord>> getAttendanceRecords({int days = 30});
  Future<AttendanceSummary> getAttendanceSummary({int days = 30});
  Future<double> getAttendancePercentage({int days = 30});
}

abstract class ICalendarRepository {
  Future<List<CalendarEvent>> getCalendarEvents({DateTime? startDate, DateTime? endDate});
  Future<List<CalendarEvent>> getUpcomingEvents({int limit = 5});
}

abstract class INewsRepository {
  Future<List<NewsItem>> getNewsList({int limit = 10});
}

abstract class INotificationRepository {
  Future<List<NotificationModel>> getNotifications();
  Future<bool> markAsRead(String notificationId);
  Future<bool> markAllAsRead();
  Future<int> getUnreadCount();
  Future<List<NotificationModel>> getByType(String type);
}

abstract class IUserRepository {
  Future<User> getCurrentUser();
  Future<Map<String, String>> getUserProfile();
}

abstract class ISearchRepository {
  List<String> getPopularSuggestions();
  List<SearchItem> search(String query);
}

abstract class ITransportRepository {
  Future<TransportInfo?> getTransportInfo();
}

abstract class IResultsRepository {
  Future<List<ExamResult>> getResults();
}

abstract class IRemarksRepository {
  Future<List<Remark>> getRemarks();
  Future<List<Achievement>> getAchievements();
}

abstract class ISyllabusRepository {
  Future<List<Syllabus>> getSyllabus();
}

abstract class ILibraryRepository {
  Future<List<LibraryBook>> getBooks();
  Future<List<LibraryRecord>> getRecords();
  Future<bool> issueBook(String bookId);
  Future<bool> returnBook(String recordId);
}

abstract class IInfirmaryRepository {
  Future<List<InfirmaryVisit>> getVisits();
  Future<HealthProfile?> getHealthProfile();
  Future<bool> reportVisit({required String reason, required String description, String? nurseName, String? medication, String? followUp});
}
