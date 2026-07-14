import 'package:flutter/material.dart';
import '../../widgets/common/primary_page_header.dart';
import '../settings/settings_page.dart';

class MealMenuPage extends StatefulWidget {
  final String role;

  const MealMenuPage({super.key, required this.role});

  @override
  State<MealMenuPage> createState() => _MealMenuPageState();
}

class _MealMenuPageState extends State<MealMenuPage> {
  String _selectedDay = 'Today';

  // Mock meal data per day
  final Map<String, Map<String, List<String>>> _mealData = {
    'Monday': {
      'Vegetable': ['Aloo Gobi', 'Bhindi Masala'],
      'Dal': ['Dal Tadka', ''],
      'Rice': ['Steamed Rice', 'Jeera Rice'],
      'Roti': ['Chapati', 'Paratha'],
      'Salad': ['Cucumber Salad', ''],
      'Sweet / Accompaniment': ['Gulab Jamun', 'Papad'],
    },
    'Tuesday': {
      'Vegetable': ['Paneer Butter Masala', 'Mix Veg'],
      'Dal': ['Dal Fry', ''],
      'Rice': ['Steamed Rice', ''],
      'Roti': ['Chapati', 'Naan'],
      'Salad': ['Green Salad', ''],
      'Sweet / Accompaniment': ['Kheer', 'Pickle'],
    },
    'Wednesday': {
      'Vegetable': ['Chole', 'Aloo Matar'],
      'Dal': ['Masoor Dal', ''],
      'Rice': ['Steamed Rice', 'Lemon Rice'],
      'Roti': ['Chapati', 'Puri'],
      'Salad': ['Carrot Salad', ''],
      'Sweet / Accompaniment': ['Rasgulla', 'Curd'],
    },
    'Thursday': {
      'Vegetable': ['Rajma', 'Cabbage Sabzi'],
      'Dal': ['Moong Dal', ''],
      'Rice': ['Steamed Rice', ''],
      'Roti': ['Chapati', 'Tandoori Roti'],
      'Salad': ['Onion Salad', ''],
      'Sweet / Accompaniment': ['Jalebi', 'Buttermilk'],
    },
    'Friday': {
      'Vegetable': ['Palak Paneer', 'Aloo Jeera'],
      'Dal': ['Chana Dal', ''],
      'Rice': ['Steamed Rice', 'Peas Pulao'],
      'Roti': ['Chapati', 'Roomali Roti'],
      'Salad': ['Mixed Salad', ''],
      'Sweet / Accompaniment': ['Gajar Halwa', 'Papad'],
    },
    'Saturday': {
      'Vegetable': ['Kadhi Pakora', 'Bharta'],
      'Dal': ['Urad Dal', ''],
      'Rice': ['Steamed Rice', ''],
      'Roti': ['Chapati', 'Missi Roti'],
      'Salad': ['Beetroot Salad', ''],
      'Sweet / Accompaniment': ['Shrikhand', 'Chutney'],
    },
    'Sunday': {
      'Vegetable': ['Veg Biryani Side', 'Malai Kofta'],
      'Dal': ['Dal Makhani', ''],
      'Rice': ['Veg Biryani', ''],
      'Roti': ['Butter Naan', ''],
      'Salad': ['Raita Salad', ''],
      'Sweet / Accompaniment': ['Gulab Jamun', 'Pickle'],
    },
  };

  final Map<String, IconData> _categoryIcons = {
    'Vegetable': Icons.eco,
    'Dal': Icons.soup_kitchen,
    'Rice': Icons.rice_bowl,
    'Roti': Icons.lunch_dining,
    'Salad': Icons.local_dining,
    'Sweet / Accompaniment': Icons.icecream,
  };

  String _getDayName(int offset) {
    final now = DateTime.now();
    final date = now.add(Duration(days: offset));
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday',
    ];
    return days[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final dayKey = _selectedDay == 'Today'
        ? _getDayName(0)
        : _getDayName(1);
    final meals = _mealData[dayKey] ?? {};

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PrimaryPageHeader(
              title: 'Meal Menu',
              subtitle: 'Today\'s & Tomorrow\'s meals',
              onSettingsPressed: () => showSettingsSheet(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'Today', label: Text('Today')),
                        ButtonSegment(value: 'Tomorrow', label: Text('Tomorrow')),
                      ],
                      selected: {_selectedDay},
                      onSelectionChanged: (value) {
                        setState(() => _selectedDay = value.first);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.tonal(
                    onPressed: _showMonthlyMenu,
                    child: const Icon(Icons.calendar_month, size: 20),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                _buildCategoryCards(meals),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  List<Widget> _buildCategoryCards(Map<String, List<String>> meals) {
    final categories = meals.entries.toList();
    return List.generate(categories.length, (index) {
      final entry = categories[index];
      final isFirst = index == 0;
      final isLast = index == categories.length - 1;

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

      final items = entry.value.where((s) => s.isNotEmpty).toList();

      return Container(
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: borderRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(
                  _categoryIcons[entry.key] ?? Icons.restaurant,
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
                      entry.key,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      items.isEmpty ? '—' : items.join(' • '),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showMonthlyMenu() {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final dayNames = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday',
    ];
    final monthName = _getMonthName(now.month);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Monthly Menu \u2022 $monthName ${now.year}',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: 900,
                      child: _buildMonthlyTable(dayNames, daysInMonth),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildMonthlyTable(List<String> dayNames, int daysInMonth) {
    final categories = [
      'Vegetable',
      'Dal',
      'Rice',
      'Roti',
      'Salad',
      'Sweet / Accompaniment',
    ];

    final now = DateTime.now();

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Table(
              border: TableBorder.all(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 1,
              ),
              columnWidths: {
                0: const FixedColumnWidth(100),
                for (int i = 1; i <= daysInMonth; i++)
                  i: const FixedColumnWidth(100),
              },
              children: [
                // Header row
                TableRow(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withValues(alpha: 0.5),
                  ),
                  children: [
                    _tableHeaderCell('Category'),
                    for (int day = 1; day <= daysInMonth; day++)
                      _tableHeaderCell('$day'),
                  ],
                ),
                // Data rows
                for (final category in categories)
                  TableRow(
                    children: [
                      _tableCell(category, bold: true),
                      for (int day = 1; day <= daysInMonth; day++) ...[
                        Builder(builder: (context) {
                          final date = DateTime(now.year, now.month, day);
                          final dayName = dayNames[date.weekday - 1];
                          final meals =
                              _mealData[dayName] ?? {};
                          final items = (meals[category] ?? [])
                              .where((s) => s.isNotEmpty)
                              .join(', ');
                          final isToday = day == now.day;
                          return _tableCell(
                            items.isEmpty ? '—' : items,
                            highlight: isToday,
                          );
                        }),
                      ],
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _tableHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _tableCell(String text, {bool bold = false, bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Container(
        padding: highlight ? const EdgeInsets.all(4) : null,
        decoration: highlight
            ? BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              )
            : null,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
            fontSize: 10,
            color: highlight
                ? Theme.of(context).colorScheme.primary
                : null,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const names = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return names[month];
  }
}
