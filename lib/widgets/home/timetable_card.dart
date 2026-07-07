import 'package:flutter/material.dart';
import '../../core/models/timetable.dart';
import '../../core/repositories/repository_provider.dart';
import '../../core/utils/subject_helpers.dart';

class TimetableCard extends StatefulWidget {
  final bool scrollable;

  const TimetableCard({super.key, this.scrollable = false});

  @override
  State<TimetableCard> createState() => _TimetableCardState();
}

class _TimetableCardState extends State<TimetableCard> {
  String selected = 'Today';
  List<TimetableClass> _classes = [];
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    final repo = RepositoryProvider.of(context).timetableRepository;
    final classes = await repo.getTodayClasses();
    if (mounted) setState(() => _classes = classes);
  }

  Future<void> _switchDay(String day) async {
    setState(() => selected = day);
    final repo = RepositoryProvider.of(context).timetableRepository;
    final classes = day == 'Today'
        ? await repo.getTodayClasses()
        : await repo.getTomorrowClasses();
    if (mounted) setState(() => _classes = classes);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Timetable', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
                const Spacer(),
                IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {}, iconSize: 20),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'Today', label: Text('Today')),
                  ButtonSegment(value: 'Tomorrow', label: Text('Tomorrow')),
                ],
                selected: {selected},
                onSelectionChanged: (value) => _switchDay(value.first),
              ),
            ),
            const SizedBox(height: 12),
            if (_classes.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(child: Text('No classes scheduled', style: TextStyle(color: Colors.grey.shade500))),
              )
            else if (widget.scrollable)
              Expanded(child: ListView(children: _buildItems()))
            else
              ListView(shrinkWrap: true, children: _buildItems()),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildItems() {
    return List.generate(_classes.length, (index) {
      final cls = _classes[index];
      return _ClassItem(
        subject: cls.subject,
        subtitle: '${cls.startTime} - ${cls.endTime} \u2022 ${cls.room}',
        isFirst: index == 0,
        isLast: index == _classes.length - 1,
      );
    });
  }
}

class _ClassItem extends StatelessWidget {
  final String subject;
  final String subtitle;
  final bool isFirst;
  final bool isLast;

  const _ClassItem({
    required this.subject,
    required this.subtitle,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius;
    if (isFirst && isLast) {
      borderRadius = BorderRadius.circular(24);
    } else if (isFirst) {
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(24), topRight: Radius.circular(24),
        bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10),
      );
    } else if (isLast) {
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(10), topRight: Radius.circular(10),
        bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24),
      );
    } else {
      borderRadius = BorderRadius.circular(10);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: borderRadius,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(iconForSubject(subject), color: Theme.of(context).colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
