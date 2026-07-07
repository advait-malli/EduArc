import 'package:flutter/material.dart';
import '../../screens/homework/homework_page.dart';
import '../../core/models/homework.dart';
import '../../core/repositories/repository_provider.dart';
import '../../core/utils/subject_helpers.dart';

class HomeworkCard extends StatefulWidget {
  final String role;
  final bool scrollable;

  const HomeworkCard({super.key, required this.role, this.scrollable = false});

  @override
  State<HomeworkCard> createState() => _HomeworkCardState();
}

class _HomeworkCardState extends State<HomeworkCard> {
  List<Homework> _homework = [];
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
    final repo = RepositoryProvider.of(context).homeworkRepository;
    final hw = await repo.getHomeworkList();
    if (mounted) setState(() => _homework = hw);
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
                Text(
                  'Homework',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => HomeworkPage(role: widget.role)),
                    );
                  },
                  iconSize: 20,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_homework.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text('No homework assigned', style: TextStyle(color: Colors.grey.shade500)),
                ),
              )
            else if (widget.scrollable)
              Expanded(
                child: ListView(children: _buildItems()),
              )
            else
              ListView(shrinkWrap: true, children: _buildItems()),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildItems() {
    return List.generate(_homework.length, (index) {
      final hw = _homework[index];
      return _HomeworkItem(
        title: hw.title,
        subject: hw.subject,
        isFirst: index == 0,
        isLast: index == _homework.length - 1,
      );
    });
  }
}

class _HomeworkItem extends StatelessWidget {
  final String title;
  final String subject;
  final bool isFirst;
  final bool isLast;

  const _HomeworkItem({
    required this.title,
    required this.subject,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
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
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(subject, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
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
