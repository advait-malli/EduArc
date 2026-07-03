import 'package:flutter/material.dart';

class SearchService {
  // Define searchable items across all pages
  static List<SearchItem> getAllSearchableItems() {
    return [
      // Homework items
      SearchItem(
        title: 'Revision Jobsheet',
        subtitle: 'Mathematics Homework',
        category: 'Homework',
        icon: Icons.calculate,
        color: const Color(0xFF6366F1),
        route: '/homework',
      ),
      SearchItem(
        title: 'Chapter 4 Notes',
        subtitle: 'Biology Homework',
        category: 'Homework',
        icon: Icons.science,
        color: const Color(0xFF10B981),
        route: '/homework',
      ),
      SearchItem(
        title: 'Essay on Climate',
        subtitle: 'English Homework',
        category: 'Homework',
        icon: Icons.book,
        color: const Color(0xFFF59E0B),
        route: '/homework',
      ),
      
      // Timetable/Classes
      SearchItem(
        title: 'Mathematics Class',
        subtitle: 'Room 101 • 9:00 - 10:00',
        category: 'Timetable',
        icon: Icons.calculate,
        color: const Color(0xFF6366F1),
        route: '/timetable',
      ),
      SearchItem(
        title: 'Physics Lab',
        subtitle: 'Lab 1 • 10:15 - 11:15',
        category: 'Timetable',
        icon: Icons.lightbulb,
        color: const Color(0xFFF59E0B),
        route: '/timetable',
      ),
      
      // Attendance
      SearchItem(
        title: 'Attendance Records',
        subtitle: 'View your attendance',
        category: 'Attendance',
        icon: Icons.groups,
        color: const Color(0xFF10B981),
        route: '/attendance',
      ),
      
      // Communication
      SearchItem(
        title: 'Announcements',
        subtitle: 'School announcements',
        category: 'Communicate',
        icon: Icons.campaign,
        color: const Color(0xFF6366F1),
        route: '/communicate',
      ),
      SearchItem(
        title: 'Messages',
        subtitle: 'Personal messages',
        category: 'Communicate',
        icon: Icons.chat,
        color: const Color(0xFF10B981),
        route: '/communicate',
      ),
      
      // Settings & Other
      SearchItem(
        title: 'Settings',
        subtitle: 'App preferences',
        category: 'Settings',
        icon: Icons.settings,
        color: const Color(0xFF8B5CF6),
        route: '/settings',
      ),
      SearchItem(
        title: 'Meal Menu',
        subtitle: 'Weekly meal schedule',
        category: 'Menu',
        icon: Icons.dining,
        color: const Color(0xFFF97316),
        route: '/meal-menu',
      ),
    ];
  }

  // Search function with fuzzy matching
  static List<SearchItem> search(String query) {
    if (query.isEmpty) return [];
    
    final items = getAllSearchableItems();
    final lowerQuery = query.toLowerCase();
    
    return items.where((item) {
      final titleMatch = item.title.toLowerCase().contains(lowerQuery);
      final subtitleMatch = item.subtitle.toLowerCase().contains(lowerQuery);
      final categoryMatch = item.category.toLowerCase().contains(lowerQuery);
      
      return titleMatch || subtitleMatch || categoryMatch;
    }).toList();
  }
}

class SearchItem {
  final String title;
  final String subtitle;
  final String category;
  final IconData icon;
  final Color color;
  final String route;

  SearchItem({
    required this.title,
    required this.subtitle,
    required this.category,
    required this.icon,
    required this.color,
    required this.route,
  });
}