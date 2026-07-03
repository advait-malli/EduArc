import 'package:flutter/material.dart';
import '../../core/utils/responsive_layout.dart';
import '../home/home_page.dart';
import '../homework/homework_page.dart';
import '../attendance/attendance_page.dart';
import '../timetable/timetable_page.dart';
import '../communicate/communicate_page.dart';
import '../more/more_page.dart';
import '../search/search_page.dart';
import '../../core/services/title_service.dart';

class NavigationItem {
  final int index;
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const NavigationItem({
    required this.index,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

class MainScreen extends StatefulWidget {
  final String role;

  const MainScreen({super.key, required this.role});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Define navigation destinations with their indices
  static const List<NavigationItem> _allDestinations = [
    NavigationItem(
      index: 0,
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'Home',
    ),
    NavigationItem(
      index: 1,
      icon: Icons.book_outlined,
      selectedIcon: Icons.book,
      label: 'Homework',
    ),
    NavigationItem(
      index: 2,
      icon: Icons.groups_outlined,
      selectedIcon: Icons.groups,
      label: 'Attendance',
    ),
    NavigationItem(
      index: 3,
      icon: Icons.calendar_today_outlined,
      selectedIcon: Icons.calendar_today,
      label: 'Timetable',
    ),
    NavigationItem(
      index: 4,
      icon: Icons.chat_outlined,
      selectedIcon: Icons.chat,
      label: 'Communicate',
    ),
    NavigationItem(
      index: 5,
      icon: Icons.more_horiz_outlined,
      selectedIcon: Icons.more_horiz,
      label: 'More',
    ),
  ];

  // Mobile navigation items (subset of all destinations)
  static const List<NavigationItem> _mobileDestinations = [
    NavigationItem(
      index: 0,
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'Home',
    ),
    NavigationItem(
      index: 1,
      icon: Icons.book_outlined,
      selectedIcon: Icons.book,
      label: 'Homework',
    ),
    NavigationItem(
      index: 4,
      icon: Icons.chat_outlined,
      selectedIcon: Icons.chat,
      label: 'Chat',
    ),
    NavigationItem(
      index: 5,
      icon: Icons.more_horiz_outlined,
      selectedIcon: Icons.more_horiz,
      label: 'More',
    ),
  ];

  List<Widget> get _pages => [
    HomePage(role: widget.role),
    HomeworkPage(role: widget.role),
    AttendancePage(role: widget.role),
    TimetablePage(role: widget.role),
    CommunicatePage(role: widget.role),
    MorePage(role: widget.role, onNavigate: _navigateToPage),
  ];

  // Map mobile navigation index to actual page index
  int _mapMobileToPageIndex(int mobileIndex) {
    if (mobileIndex < _mobileDestinations.length) {
      return _mobileDestinations[mobileIndex].index;
    }
    return 0;
  }

  // Map page index to mobile navigation index
  int _mapPageToMobileIndex(int pageIndex) {
    for (int i = 0; i < _mobileDestinations.length; i++) {
      if (_mobileDestinations[i].index == pageIndex) {
        return i;
      }
    }
    return 0;
  }

  void _openSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SearchPage()),
    );
  }

  void _navigateToPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Set title based on selected page (deferred to avoid setState during build)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      switch (_selectedIndex) {
        case 0:
          TitleService.setTitle('Home');
          break;
        case 1:
          TitleService.setTitle('Homework');
          break;
        case 2:
          TitleService.setTitle('Attendance');
          break;
        case 3:
          TitleService.setTitle('Timetable');
          break;
        case 4:
          TitleService.setTitle('Communicate');
          break;
        case 5:
          TitleService.setTitle('More');
          break;
        default:
          TitleService.setTitle('');
          break;
      }
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = ResponsiveLayout.isMobileFromConstraints(constraints);

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
          floatingActionButton: isMobile
              ? FloatingActionButton(
                  onPressed: _openSearch,
                  elevation: 2.0,
                  child: const Icon(Icons.search),
                )
              : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          body: Row(
            children: [
              if (!isMobile)
                NavigationRail(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  selectedIndex: _selectedIndex,
                  labelType: NavigationRailLabelType.all,
                  onDestinationSelected: (index) {
                    setState(() => _selectedIndex = index);
                  },
                  leading: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      FloatingActionButton(
                        elevation: 0,
                        onPressed: _openSearch,
                        child: const Icon(Icons.search),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  destinations: _allDestinations
                      .map(
                        (item) => NavigationRailDestination(
                          icon: Icon(item.icon),
                          selectedIcon: Icon(item.selectedIcon),
                          label: Text(item.label),
                        ),
                      )
                      .toList(),
                ),
              Expanded(child: _pages[_selectedIndex]),
            ],
          ),
          bottomNavigationBar: isMobile
              ? NavigationBar(
                  selectedIndex: _mapPageToMobileIndex(_selectedIndex),
                  onDestinationSelected: (mobileIndex) {
                    final pageIndex = _mapMobileToPageIndex(mobileIndex);
                    setState(() => _selectedIndex = pageIndex);
                  },
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  destinations: _mobileDestinations
                      .map(
                        (item) => NavigationDestination(
                          icon: Icon(item.icon),
                          selectedIcon: Icon(item.selectedIcon),
                          label: item.label,
                        ),
                      )
                      .toList(),
                )
              : null,
        );
      },
    );
  }
}
