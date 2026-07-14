import 'package:flutter/material.dart';
import '../../widgets/common/primary_page_header.dart';
import '../../core/utils/responsive_layout.dart';
import '../settings/settings_page.dart';
import '../timetable/timetable_page.dart';
import '../attendance/attendance_page.dart';
import '../meal_menu/meal_menu_page.dart';
import '../transport/transport_page.dart';
import '../results/results_page.dart';
import '../remarks/remarks_page.dart';
import '../syllabus/syllabus_page.dart';
import '../library/library_page.dart';
import '../infirmary/infirmary_page.dart';

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
                    isLast: false,
                    onTap: () {
                      _navigateToPage(
                        _WrappedAttendancePage(role: widget.role),
                        'Attendance',
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    title: 'Meal Menu',
                    icon: Icons.dining_outlined,
                    isFirst: false,
                    isLast: false,
                    onTap: () {
                      _navigateToPage(
                        _WrappedMealMenuPage(role: widget.role),
                        'Meal Menu',
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    title: 'School Transport',
                    icon: Icons.directions_bus_outlined,
                    isFirst: false,
                    isLast: false,
                    onTap: () {
                      _navigateToPage(
                        _WrappedTransportPage(role: widget.role),
                        'School Transport',
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    title: 'Results & Performance',
                    icon: Icons.assessment_outlined,
                    isFirst: false,
                    isLast: false,
                    onTap: () {
                      _navigateToPage(
                        _WrappedResultsPage(role: widget.role),
                        'Results & Performance',
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    title: 'Remarks & Achievements',
                    icon: Icons.rate_review_outlined,
                    isFirst: false,
                    isLast: false,
                    onTap: () {
                      _navigateToPage(
                        _WrappedRemarksPage(role: widget.role),
                        'Remarks & Achievements',
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    title: 'Syllabus',
                    icon: Icons.menu_book_outlined,
                    isFirst: false,
                    isLast: false,
                    onTap: () {
                      _navigateToPage(
                        _WrappedSyllabusPage(role: widget.role),
                        'Syllabus',
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    title: 'Library',
                    icon: Icons.library_books_outlined,
                    isFirst: false,
                    isLast: false,
                    onTap: () {
                      _navigateToPage(
                        _WrappedLibraryPage(role: widget.role),
                        'Library',
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    title: 'Infirmary',
                    icon: Icons.local_hospital_outlined,
                    isFirst: false,
                    isLast: true,
                    onTap: () {
                      _navigateToPage(
                        _WrappedInfirmaryPage(role: widget.role),
                        'Infirmary',
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ]),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildMenuItem(
                    context,
                    title: 'Meal Menu',
                    icon: Icons.dining_outlined,
                    isFirst: true,
                    isLast: false,
                    onTap: () {
                      _navigateToPage(
                        _WrappedMealMenuPage(role: widget.role),
                        'Meal Menu',
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    title: 'School Transport',
                    icon: Icons.directions_bus_outlined,
                    isFirst: false,
                    isLast: false,
                    onTap: () {
                      _navigateToPage(
                        _WrappedTransportPage(role: widget.role),
                        'School Transport',
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    title: 'Results & Performance',
                    icon: Icons.assessment_outlined,
                    isFirst: false,
                    isLast: false,
                    onTap: () {
                      _navigateToPage(
                        _WrappedResultsPage(role: widget.role),
                        'Results & Performance',
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    title: 'Remarks & Achievements',
                    icon: Icons.rate_review_outlined,
                    isFirst: false,
                    isLast: false,
                    onTap: () {
                      _navigateToPage(
                        _WrappedRemarksPage(role: widget.role),
                        'Remarks & Achievements',
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    title: 'Syllabus',
                    icon: Icons.menu_book_outlined,
                    isFirst: false,
                    isLast: false,
                    onTap: () {
                      _navigateToPage(
                        _WrappedSyllabusPage(role: widget.role),
                        'Syllabus',
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    title: 'Library',
                    icon: Icons.library_books_outlined,
                    isFirst: false,
                    isLast: false,
                    onTap: () {
                      _navigateToPage(
                        _WrappedLibraryPage(role: widget.role),
                        'Library',
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    title: 'Infirmary',
                    icon: Icons.local_hospital_outlined,
                    isFirst: false,
                    isLast: true,
                    onTap: () {
                      _navigateToPage(
                        _WrappedInfirmaryPage(role: widget.role),
                        'Infirmary',
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ]),
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

class _WrappedMealMenuPage extends StatelessWidget {
  final String role;

  const _WrappedMealMenuPage({required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: MealMenuPage(role: role),
    );
  }
}

class _WrappedTransportPage extends StatelessWidget {
  final String role;

  const _WrappedTransportPage({required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: TransportPage(role: role),
    );
  }
}

class _WrappedResultsPage extends StatelessWidget {
  final String role;

  const _WrappedResultsPage({required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: ResultsPage(role: role),
    );
  }
}

class _WrappedRemarksPage extends StatelessWidget {
  final String role;

  const _WrappedRemarksPage({required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: RemarksPage(role: role),
    );
  }
}

class _WrappedSyllabusPage extends StatelessWidget {
  final String role;

  const _WrappedSyllabusPage({required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: SyllabusPage(role: role),
    );
  }
}

class _WrappedLibraryPage extends StatelessWidget {
  final String role;

  const _WrappedLibraryPage({required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: LibraryPage(role: role),
    );
  }
}

class _WrappedInfirmaryPage extends StatelessWidget {
  final String role;

  const _WrappedInfirmaryPage({required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: InfirmaryPage(role: role),
    );
  }
}
