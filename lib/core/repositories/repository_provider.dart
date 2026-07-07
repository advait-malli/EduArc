import 'package:flutter/material.dart';
import 'homework_repository.dart';
import 'message_repository.dart';
import 'dashboard_repository.dart';
import 'attendance_repository.dart';
import 'notification_repository.dart';
import 'user_repository.dart';
import 'search_repository.dart';
import 'interfaces.dart';

class RepositoryProvider extends InheritedWidget {
  final IHomeworkRepository homeworkRepository;
  final IMessageRepository messageRepository;
  final ITimetableRepository timetableRepository;
  final ICalendarRepository calendarRepository;
  final INewsRepository newsRepository;
  final IAttendanceRepository attendanceRepository;
  final INotificationRepository notificationRepository;
  final IUserRepository userRepository;
  final ISearchRepository searchRepository;

  const RepositoryProvider({
    super.key,
    required super.child,
    required this.homeworkRepository,
    required this.messageRepository,
    required this.timetableRepository,
    required this.calendarRepository,
    required this.newsRepository,
    required this.attendanceRepository,
    required this.notificationRepository,
    required this.userRepository,
    required this.searchRepository,
  });

  static RepositoryProvider of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<RepositoryProvider>();
    assert(provider != null, 'No RepositoryProvider found in context');
    return provider!;
  }

  @override
  bool updateShouldNotify(RepositoryProvider oldWidget) => false;

  static RepositoryProvider _default({required Widget child}) => RepositoryProvider(
    homeworkRepository: HomeworkRepository(),
    messageRepository: MessageRepository(),
    timetableRepository: TimetableRepository(),
    calendarRepository: CalendarRepository(),
    newsRepository: NewsRepository(),
    attendanceRepository: AttendanceRepository(),
    notificationRepository: NotificationRepository(),
    userRepository: UserRepository(),
    searchRepository: SearchRepository(),
    child: child,
  );

  static Widget wrap(Widget child) => _default(child: child);
}
