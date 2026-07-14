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

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PrimaryPageHeader(
              title: 'Attendance',
              subtitle: 'View your attendance records',
              onSettingsPressed: () => showSettingsSheet(context),
            ),
          ),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_summary != null) ...[
            SliverToBoxAdapter(
              child: ResponsiveLayout.isDesktop(context)
                  ? _buildDesktopOverview(_summary!)
                  : _buildMobileOverview(_summary!),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text(
                  'Recent History',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildAttendanceCard(_records[index], index),
                  childCount: _records.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ],
      ),
    );
  }

  Widget _buildDesktopOverview(AttendanceSummary summary) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  ProgressRing(
                    completedDays: summary.presentDays,
                    leaveDays: summary.leaveDays,
                    totalDays: summary.totalDays,
                    size: 160,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatsColumn(summary),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileOverview(AttendanceSummary summary) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            ProgressRing(
              completedDays: summary.presentDays,
              leaveDays: summary.leaveDays,
              totalDays: summary.totalDays,
              size: 160,
            ),
            const SizedBox(height: 16),
            _buildStatsRow(summary),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(AttendanceSummary summary) {
    return Row(
      children: [
        _statChip('Present', summary.presentDays, Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        _statChip('Absent', summary.absentDays, Theme.of(context).colorScheme.error),
        const SizedBox(width: 8),
        _statChip('Leave', summary.leaveDays, Theme.of(context).colorScheme.tertiary),
      ],
    );
  }

  Widget _buildStatsColumn(AttendanceSummary summary) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summary',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          _statRow('Present', summary.presentDays, Theme.of(context).colorScheme.primary),
          const SizedBox(height: 12),
          _statRow('Absent', summary.absentDays, Theme.of(context).colorScheme.error),
          const SizedBox(height: 12),
          _statRow('Leave', summary.leaveDays, Theme.of(context).colorScheme.tertiary),
          const Divider(height: 28),
          _statRow('Total Days', summary.totalDays, Theme.of(context).colorScheme.onSurface),
          const SizedBox(height: 8),
          Text(
            '${summary.percentage.toStringAsFixed(1)}% attendance',
            style: TextStyle(
              color: summary.percentage >= 75
                  ? Colors.green
                  : Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statChip(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color.withValues(alpha: 0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statRow(String label, int count, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(label, style: const TextStyle(fontSize: 14)),
        ),
        Text(
          '$count days',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceCard(AttendanceRecord record, int index) {
    final isFirst = index == 0;
    final isLast = index == _records.length - 1;

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

    final isPresent = record.isPresent;
    final isLeave = record.isLeave;
    final isAbsent = record.isAbsent;

    final color = isPresent
        ? Theme.of(context).colorScheme.primary
        : isLeave
            ? Theme.of(context).colorScheme.tertiary
            : Theme.of(context).colorScheme.error;

    final icon = isPresent
        ? Icons.check_circle
        : isLeave
            ? Icons.event_busy
            : isAbsent
                ? Icons.cancel
                : Icons.access_time;

    final statusText = isPresent
        ? 'Present'
        : isLeave
            ? 'On Leave'
            : isAbsent
                ? 'Absent'
                : 'Late';

    final dayName = _dayName(record.date.weekday);
    final monthName = _monthName(record.date.month);

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: borderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$dayName, ${record.date.day} $monthName',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${record.totalClasses} classes scheduled${record.attendedClasses != null ? ' • ${record.attendedClasses} attended' : ''}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                  if (record.subject != null && record.subject!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      record.subject!,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                statusText,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _dayName(int weekday) {
    const days = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday];
  }

  String _monthName(int month) {
    const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month];
  }
}
