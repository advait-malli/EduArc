import 'package:flutter/material.dart';
import '../../widgets/common/primary_page_header.dart';
import '../../core/services/auth_service.dart';
import '../auth/login_page.dart';
import '../settings/settings_page.dart';
class TimetablePage extends StatefulWidget {
  final String role;

  const TimetablePage({super.key, required this.role});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  final Map<String, List<Map<String, dynamic>>> timetable = {
    'Monday': [
      {
        'time': '9:00 - 10:00',
        'subject': 'Mathematics',
        'room': 'Room 101',
        'icon': Icons.calculate,
        'color': const Color(0xFF6366F1),
      },
      {
        'time': '10:15 - 11:15',
        'subject': 'Physics',
        'room': 'Lab 1',
        'icon': Icons.lightbulb,
        'color': const Color(0xFFF59E0B),
      },
    ],
    'Tuesday': [
      {
        'time': '9:00 - 10:00',
        'subject': 'Biology',
        'room': 'Lab 3',
        'icon': Icons.science,
        'color': const Color(0xFF10B981),
      },
    ],
    'Wednesday': [
      {
        'time': '9:00 - 10:00',
        'subject': 'Chemistry',
        'room': 'Lab 2',
        'icon': Icons.biotech,
        'color': const Color(0xFFEC4899),
      },
    ],
    'Thursday': [
      {
        'time': '9:00 - 10:00',
        'subject': 'English',
        'room': 'Room 205',
        'icon': Icons.book,
        'color': const Color(0xFF8B5CF6),
      },
    ],
    'Friday': [
      {
        'time': '9:00 - 10:00',
        'subject': 'History',
        'room': 'Room 301',
        'icon': Icons.history_edu,
        'color': const Color(0xFFF97316),
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: days.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedDay = days[_tabController.index];
    final classes = timetable[selectedDay] ?? [];

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverToBoxAdapter(
          child: PrimaryPageHeader(
            title: 'Timetable',
            subtitle: 'Weekly schedule',
            onSettingsPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: Theme.of(context).colorScheme.primary,
                indicatorColor: Theme.of(context).colorScheme.primary,
                tabs: days.map((d) => Tab(text: d.substring(0, 3))).toList(),
                onTap: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: classes.length,
        itemBuilder: (context, index) {
          final classInfo = classes[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (classInfo['color'] as Color).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  classInfo['icon'] as IconData,
                  color: classInfo['color'] as Color,
                ),
              ),
              title: Text(
                classInfo['subject'],
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text('${classInfo['time']} • ${classInfo['room']}'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
          );
        },
      ),
    );
  }
}
