import 'package:flutter/material.dart';
import '../../widgets/common/primary_page_header.dart';
import '../../widgets/common/progress_ring.dart';
import '../../core/utils/responsive_layout.dart';
import '../settings/settings_page.dart';
import '../../core/services/title_service.dart';
import '../../core/repositories/repository_provider.dart';
import '../../core/models/attendance.dart';

class AttendancePage extends StatefulWidget {
  final String role;

  const AttendancePage({super.key, required this.role});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  List<AttendanceRecord> _records = [];
  AttendanceSummary? _summary;
  bool _isLoading = true;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    final repo = RepositoryProvider.of(context).attendanceRepository;
    final records = await repo.getAttendanceRecords();
    final summary = await repo.getAttendanceSummary();
    if (mounted) setState(() { _records = records; _summary = summary; _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    TitleService.setTitle('Attendance');

    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isDesktop = ResponsiveLayout.isDesktop(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PrimaryPageHeader(
              title: 'Attendance',
              subtitle: 'View your attendance records',
              onSettingsPressed: () {
                showSettingsSheet(context);
              },
            ),
          ),
          SliverToBoxAdapter(
            child: isDesktop
                ? _buildDesktopLayout(context, _records, _summary!)
                : _buildMobileLayout(context, _records, _summary!),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    List<AttendanceRecord> records,
    AttendanceSummary summary,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attendance Overview',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: ProgressRing(
                        completedDays: summary.presentDays,
                        totalDays: summary.totalDays,
                        size: 160,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attendance History',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 16),
                    ListView(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      children: records.map((record) {
                        return _buildAttendanceTile(context, record);
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    List<AttendanceRecord> records,
    AttendanceSummary summary,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    'Attendance Overview',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ProgressRing(
                      completedDays: summary.presentDays,
                      totalDays: summary.totalDays,
                      size: 200,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Attendance History',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 16),
                  ...records.map((record) {
                    return _buildAttendanceTile(context, record);
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceTile(
    BuildContext context,
    AttendanceRecord record,
  ) {
    final isPresent = record.isPresent;
    final isLeave = record.isLeave;

    final containerColor = isPresent
        ? Theme.of(context).colorScheme.primaryContainer
        : isLeave
            ? Theme.of(context).colorScheme.tertiaryContainer
            : Theme.of(context).colorScheme.errorContainer;

    final iconColor = isPresent
        ? Theme.of(context).colorScheme.primary
        : isLeave
            ? Theme.of(context).colorScheme.tertiary
            : Theme.of(context).colorScheme.error;

    final icon = isPresent ? Icons.check : Icons.close;

    final dateStr =
        '${record.date.year}-${record.date.month.toString().padLeft(2, '0')}-${record.date.day.toString().padLeft(2, '0')}';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: containerColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Text(
          dateStr,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('${record.totalClasses} classes'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: containerColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            record.status,
            style: TextStyle(
              color: isPresent
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : isLeave
                      ? Theme.of(context).colorScheme.onTertiaryContainer
                      : Theme.of(context).colorScheme.onErrorContainer,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
