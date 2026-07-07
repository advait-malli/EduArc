import 'package:flutter/material.dart';
import '../../widgets/common/primary_page_header.dart';
import '../../core/utils/responsive_layout.dart';
import '../settings/settings_page.dart';
import '../timetable/timetable_page.dart';
import '../attendance/attendance_page.dart';

class MorePage extends StatefulWidget {
  final String role;
  final Function(int)? onNavigate;

  const MorePage({super.key, required this.role, this.onNavigate});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  Widget? _currentPage;
  String? _currentTitle;

  void _navigateToPage(Widget page, String title) {
    setState(() {
      _currentPage = page;
      _currentTitle = title;
    });
  }

  void _navigateBack() {
    setState(() {
      _currentPage = null;
      _currentTitle = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPage != null) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) _navigateBack();
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 16, 24, 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _navigateBack,
                    ),
                    Expanded(
                      child: Text(
                        _currentTitle!,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: _currentPage!),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PrimaryPageHeader(
              title: 'More',
              subtitle: 'Additional features',
              onSettingsPressed: () => showSettingsSheet(context),
            ),
          ),
          if (ResponsiveLayout.isMobile(context))
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildMenuItem(
                    context,
                    title: 'Timetable',
                    icon: Icons.calendar_today_outlined,
                    isFirst: true,
                    isLast: false,
                    onTap: () {
                      _navigateToPage(
                        _WrappedTimetablePage(role: widget.role),
                        'Timetable',
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    title: 'Attendance',
                    icon: Icons.groups_outlined,
                    isFirst: false,
                    isLast: true,
                    onTap: () {
                      _navigateToPage(
                        _WrappedAttendancePage(role: widget.role),
                        'Attendance',
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ]),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.more_horiz,
                        size: 64,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'More',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Coming soon...',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool isFirst,
    required bool isLast,
    required VoidCallback onTap,
  }) {
    final color = Theme.of(context).colorScheme.primary;

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
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: borderRadius,
      ),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
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
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }
}

// Wrapper widgets that add Scaffold back for standalone use
class _WrappedTimetablePage extends StatelessWidget {
  final String role;

  const _WrappedTimetablePage({required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: TimetablePage(role: role),
    );
  }
}

class _WrappedAttendancePage extends StatelessWidget {
  final String role;

  const _WrappedAttendancePage({required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: AttendancePage(role: role),
    );
  }
}
