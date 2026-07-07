import 'package:flutter/material.dart';
import '../../widgets/common/primary_page_header.dart';
import '../settings/settings_page.dart';
import '../../core/repositories/repository_provider.dart';
import '../../core/models/timetable.dart';
import '../../core/utils/subject_helpers.dart';

class TimetablePage extends StatefulWidget {
  final String role;

  const TimetablePage({super.key, required this.role});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _days = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday',
  ];
  Map<String, List<TimetableClass>> _timetable = {};
  bool _isLoading = true;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _days.length, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      _loadTimetable();
    }
  }

  Future<void> _loadTimetable() async {
    final repo = RepositoryProvider.of(context).timetableRepository;
    final Map<String, List<TimetableClass>> data = {};
    for (int i = 0; i < _days.length; i++) {
      final dayOfWeek = i + 1;
      data[_days[i]] = await repo.getTimetable(dayOfWeek: dayOfWeek);
    }
    if (mounted) setState(() { _timetable = data; _isLoading = false; });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedDay = _days[_tabController.index];
    final classes = _timetable[selectedDay] ?? [];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: PrimaryPageHeader(
              title: 'Timetable',
              subtitle: 'Weekly schedule',
              onSettingsPressed: () {
                showSettingsSheet(context);
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
                  tabs: _days.map((d) => Tab(text: d.substring(0, 3))).toList(),
                  onTap: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
        body: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          itemCount: classes.length,
          itemBuilder: (context, index) {
            final classInfo = classes[index];
            final classColor = Theme.of(context).colorScheme.primary;
            final isFirst = index == 0;
            final isLast = index == classes.length - 1;

            BorderRadius borderRadius;
            if (isFirst && isLast) {
              borderRadius = BorderRadius.circular(24);
            } else if (isFirst) {
              borderRadius = const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              );
            } else if (isLast) {
              borderRadius = const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              );
            } else {
              borderRadius = BorderRadius.circular(10);
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: borderRadius,
              ),
              child: InkWell(
                borderRadius: borderRadius,
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: classColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Icon(
                          iconForSubject(classInfo.subject),
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              classInfo.subject,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${classInfo.startTime} - ${classInfo.endTime} • ${classInfo.room}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16,
                          color: Colors.grey),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
