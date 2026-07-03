import 'package:flutter/material.dart';

class TimetableCard extends StatefulWidget {
  const TimetableCard({super.key});

  @override
  State<TimetableCard> createState() => _TimetableCardState();
}

class _TimetableCardState extends State<TimetableCard> {
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
        selected == 'Today'
            ? todayClasses
            : tomorrowClasses;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Timetable',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                        fontWeight:
                            FontWeight.w600,
                      ),
                ),

                const Spacer(),

                IconButton(
                  icon: const Icon(
                    Icons.more_horiz,
                  ),
                  onPressed: () {},
                  iconSize: 20,
                ),
              ],
            ),

            const SizedBox(height: 16),

            Center(
              child: SegmentedButton<String>(
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
              ),
            ),

            const SizedBox(height: 12),

            ListView(
                shrinkWrap: true,
                children: List.generate(
                  classes.length,
                  (index) {
                    final cls = classes[index];

                    final isFirst =
                        index == 0;

                    final isLast =
                        index ==
                        classes.length - 1;

                    BorderRadius
                    borderRadius;

                    if (isFirst &&
                        isLast) {
                      borderRadius =
                          BorderRadius.circular(
                            24,
                          );
                    } else if (isFirst) {
                      borderRadius =
                          const BorderRadius.only(
                            topLeft:
                                Radius.circular(
                                  24,
                                ),
                            topRight:
                                Radius.circular(
                                  24,
                                ),
                            bottomLeft:
                                Radius.circular(
                                  10,
                                ),
                            bottomRight:
                                Radius.circular(
                                  10,
                                ),
                          );
                    } else if (isLast) {
                      borderRadius =
                          const BorderRadius.only(
                            topLeft:
                                Radius.circular(
                                  10,
                                ),
                            topRight:
                                Radius.circular(
                                  10,
                                ),
                            bottomLeft:
                                Radius.circular(
                                  24,
                                ),
                            bottomRight:
                                Radius.circular(
                                  24,
                                ),
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
                            bottom: 8,
                          ),
                      padding:
                          const EdgeInsets.all(
                            10,
                          ),
                      decoration:
                          BoxDecoration(
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
                                        fontSize:
                                            14,
                                      ),
                                ),

                                Text(
                                  '${cls['time']} • ${cls['room']}',
                                  style:
                                      TextStyle(
                                        color:
                                            Colors
                                                .grey
                                                .shade600,
                                        fontSize:
                                            12,
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
}