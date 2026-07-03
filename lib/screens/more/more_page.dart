import 'package:flutter/material.dart';
import '../../widgets/common/primary_page_header.dart';
import '../../core/services/auth_service.dart';
import '../../core/utils/responsive_layout.dart';
import '../auth/login_page.dart';
import '../settings/settings_page.dart';
import '../timetable/timetable_page.dart';
import '../attendance/attendance_page.dart';
import '../main/main_screen.dart';

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
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _navigateBack,
          ),
          title: Text(_currentTitle!),
        ),
        body: _currentPage,
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
              onSettingsPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
            ),
          ),
          if (ResponsiveLayout.isMobile(context))
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildMenuItem(
                    context,
                    title: 'Timetable',
                    icon: Icons.calendar_today_outlined,
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

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
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
