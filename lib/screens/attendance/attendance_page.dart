import 'package:flutter/material.dart';
import '../../widgets/common/primary_page_header.dart';
import '../../widgets/common/progress_ring.dart';
import '../../core/utils/responsive_layout.dart';
import '../settings/settings_page.dart';
import '../../core/services/title_service.dart';

class AttendancePage extends StatelessWidget {
  final String role;

  const AttendancePage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    TitleService.setTitle('Attendance');

    final attendanceData = [
      {'date': '2026-01-13', 'status': 'Present', 'classes': 6},
      {'date': '2026-01-12', 'status': 'Leave', 'classes': 6},
      {'date': '2026-01-11', 'status': 'Present', 'classes': 6},
      {'date': '2026-01-10', 'status': 'Present', 'classes': 6},
      {'date': '2026-01-09', 'status': 'Absent', 'classes': 6},
      {'date': '2026-01-08', 'status': 'Present', 'classes': 6},
      {'date': '2026-01-07', 'status': 'Present', 'classes': 6},
    ];

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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: isDesktop
                ? _buildDesktopLayout(context, attendanceData)
                : _buildMobileLayout(context, attendanceData),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    List<Map<String, dynamic>> attendanceData,
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
                    const Center(
                      child: ProgressRing(
                        completedDays: 110,
                        totalDays: 120,
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
                      children: attendanceData.map((record) {
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
    List<Map<String, dynamic>> attendanceData,
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
                  const SizedBox(
                    width: double.infinity,
                    child: ProgressRing(
                      completedDays: 110,
                      totalDays: 120,
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
                  ...attendanceData.map((record) {
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
    Map<String, dynamic> record,
  ) {
    final isPresent = record['status'] == 'Present';
    final isLeave = record['status'] == 'Leave';

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

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: containerColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Text(
          record['date'] as String,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('${record['classes']} classes'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: containerColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            record['status'] as String,
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
