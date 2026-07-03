import 'package:flutter/material.dart';
import '../../screens/homework/homework_page.dart';

class HomeworkCard extends StatelessWidget {
  final String role;

  const HomeworkCard({super.key, required this.role});

  Color _getColor(BuildContext context, String subject) =>
      Theme.of(context).colorScheme.primary;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Homework',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HomeworkPage(role: role),
                      ),
                    );
                  },
                  iconSize: 20,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView(
              shrinkWrap: true,
              children: [
                  _HomeworkItem(
                    title: 'Revision Jobsheet',
                    subject: 'Mathematics',
                    icon: Icons.calculate,
                    color: _getColor(context, 'Mathematics'),
                  ),
                  const SizedBox(height: 12),
                  _HomeworkItem(
                    title: 'Lesson notes for Chapter 4',
                    subject: 'Biology',
                    icon: Icons.science,
                    color: _getColor(context, 'Biology'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _HomeworkItem extends StatelessWidget {
  final String title;
  final String subject;
  final IconData icon;
  final Color color;

  const _HomeworkItem({
    required this.title,
    required this.subject,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subject,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(Icons.notifications_none, color: Colors.grey.shade400, size: 20),
          const SizedBox(width: 8),
          Icon(Icons.settings_outlined, color: Colors.grey.shade400, size: 20),
        ],
      ),
    );
  }
}
