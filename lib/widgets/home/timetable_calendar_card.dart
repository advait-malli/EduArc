import 'package:flutter/material.dart';

class TimetableCalendarCard extends StatefulWidget {
  const TimetableCalendarCard({super.key});

  @override
  State<TimetableCalendarCard> createState() =>
      _TimetableCalendarCardState();
}

class _TimetableCalendarCardState
    extends State<TimetableCalendarCard> {
  String selected = 'Today';

  final List<Map<String, dynamic>> todayClasses = [
    {
      'subject': 'Mathematics',
      'time': '9:00 AM - 10:00 AM',
      'room': 'Room 101',
      'icon': Icons.calculate,
    },
    {
      'subject': 'Biology',
      'time': '10:30 AM - 11:30 AM',
      'room': 'Lab 3',
      'icon': Icons.science,
    },
    {
      'subject': 'English',
      'time': '12:00 PM - 1:00 PM',
      'room': 'Room 205',
      'icon': Icons.book,
    },
  ];

  final List<Map<String, dynamic>> tomorrowClasses = [
    {
      'subject': 'Chemistry',
      'time': '9:00 AM - 10:00 AM',
      'room': 'Lab 1',
      'icon': Icons.biotech,
    },
    {
      'subject': 'Physics',
      'time': '10:30 AM - 11:30 AM',
      'room': 'Room 302',
      'icon': Icons.flash_on,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final classes =
        selected == 'Today' ? todayClasses : tomorrowClasses;

    final now = DateTime.now();
    final daysInMonth =
        DateTime(now.year, now.month + 1, 0).day;
    final firstDayOfMonth =
        DateTime(now.year, now.month, 1).weekday;

    return Card(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_month,
                  size: 20,
                  color: color,
                ),
                const SizedBox(width: 8),
                Text(
                  '${_getMonthName(now.month)} ${now.year}',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            _buildMiniCalendar(
              context,
              daysInMonth,
              firstDayOfMonth,
              now.day,
              color,
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),

            Row(
              children: [
                Text(
                  'Timetable',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),

                const Spacer(),

                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'Today',
                      label: Text('Today'),
                    ),
                    ButtonSegment(
                      value: 'Tomorrow',
                      label: Text('Tomorrow'),
                    ),
                  ],
                  selected: {selected},
                  onSelectionChanged: (value) {
                    setState(() {
                      selected = value.first;
                    });
                  },
                  style: const ButtonStyle(
                    visualDensity:
                        VisualDensity.compact,
                    tapTargetSize:
                        MaterialTapTargetSize
                            .shrinkWrap,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            classes.isEmpty
                ? Center(
                    child: Text(
                      'No classes scheduled',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                      ),
                    ),
                  )
                : ListView(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    children: List.generate(
                      classes.length,
                      (index) {
                        final cls = classes[index];

                        final isFirst = index == 0;
                        final isLast =
                            index ==
                                classes.length - 1;

                        BorderRadius borderRadius;

                        if (isFirst && isLast) {
                          borderRadius =
                              BorderRadius.circular(
                            24,
                          );
                        } else if (isFirst) {
                          borderRadius =
                              const BorderRadius.only(
                            topLeft:
                                Radius.circular(24),
                            topRight:
                                Radius.circular(24),
                            bottomLeft:
                                Radius.circular(10),
                            bottomRight:
                                Radius.circular(10),
                          );
                        } else if (isLast) {
                          borderRadius =
                              const BorderRadius.only(
                            topLeft:
                                Radius.circular(10),
                            topRight:
                                Radius.circular(10),
                            bottomLeft:
                                Radius.circular(24),
                            bottomRight:
                                Radius.circular(24),
                          );
                        } else {
                          borderRadius =
                              BorderRadius.circular(
                            10,
                          );
                        }

                        return Container(
                          margin:
                              const EdgeInsets.only(
                            bottom: 6,
                          ),
                          padding:
                              const EdgeInsets.all(
                            10,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerLowest,
                            borderRadius:
                                borderRadius,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.all(
                                  8,
                                ),
                                decoration:
                                    BoxDecoration(
                                  color: color
                                      .withOpacity(
                                    0.1,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(
                                    100,
                                  ),
                                ),
                                child: Icon(
                                  cls['icon']
                                      as IconData,
                                  color: color,
                                  size: 20,
                                ),
                              ),

                              const SizedBox(
                                width: 12,
                              ),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    Text(
                                      cls['subject']
                                          as String,
                                      style:
                                          const TextStyle(
                                        fontWeight:
                                            FontWeight
                                                .w600,
                                        fontSize: 14,
                                      ),
                                    ),

                                    Text(
                                      '${cls['time']} • ${cls['room']}',
                                      style:
                                          TextStyle(
                                        color: Colors
                                            .grey
                                            .shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniCalendar(
    BuildContext context,
    int daysInMonth,
    int firstDay,
    int currentDay,
    Color color,
  ) {
    final days = [
      'M',
      'T',
      'W',
      'T',
      'F',
      'S',
      'S',
    ];

    final adjustedFirstDay = firstDay - 1;

    return Column(
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceAround,
          children: days
              .map(
                (day) => SizedBox(
                  width: 28,
                  child: Text(
                    day,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight:
                          FontWeight.w600,
                      color:
                          Colors.grey.shade600,
                      fontSize: 11,
                    ),
                  ),
                ),
              )
              .toList(),
        ),

        const SizedBox(height: 4),

        GridView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(),
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            childAspectRatio: 1,
          ),
          itemCount: 42,
          itemBuilder: (context, index) {
            final dayOffset =
                index - adjustedFirstDay;

            if (dayOffset < 0 ||
                dayOffset >= daysInMonth) {
              return const SizedBox.shrink();
            }

            final day = dayOffset + 1;
            final isToday = day == currentDay;

            return Container(
              decoration: BoxDecoration(
                color: isToday
                    ? color
                    : Colors.transparent,
                borderRadius:
                    BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  '$day',
                  style: TextStyle(
                    color: isToday
                        ? Theme.of(context)
                            .colorScheme
                            .onPrimary
                        : Theme.of(context)
                            .colorScheme
                            .onSurface,
                    fontWeight: isToday
                        ? FontWeight.bold
                        : null,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }
}