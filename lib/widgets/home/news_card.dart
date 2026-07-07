import 'package:flutter/material.dart';
import '../../core/models/calendar.dart';
import '../../core/repositories/repository_provider.dart';

IconData _iconForCategory(String category) {
  switch (category.toLowerCase()) {
    case 'circular': return Icons.campaign;
    case 'announcement': return Icons.volume_up;
    case 'news': return Icons.library_books;
    default: return Icons.article;
  }
}

class NewsCard extends StatefulWidget {
  final bool scrollable;

  const NewsCard({super.key, this.scrollable = false});

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  List<NewsItem> _news = [];
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
    final repo = RepositoryProvider.of(context).newsRepository;
    final items = await repo.getNewsList();
    if (mounted) setState(() => _news = items);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Card(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Circulars & News', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
                const Spacer(),
                IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {}, iconSize: 20),
              ],
            ),
            const SizedBox(height: 16),
            if (_news.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(child: Text('No news', style: TextStyle(color: Colors.grey.shade500))),
              )
            else if (widget.scrollable)
              Expanded(child: ListView(children: _buildItems(color)))
            else
              ListView(shrinkWrap: true, children: _buildItems(color)),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildItems(Color color) {
    return List.generate(_news.length, (index) {
      final item = _news[index];
      return _NewsItem(
        title: item.title,
        date: '${item.publishedDate.month}/${item.publishedDate.day}/${item.publishedDate.year}',
        icon: _iconForCategory(item.category),
        color: color,
        isFirst: index == 0,
        isLast: index == _news.length - 1,
      );
    });
  }
}

class _NewsItem extends StatelessWidget {
  final String title;
  final String date;
  final IconData icon;
  final Color color;
  final bool isFirst;
  final bool isLast;

  const _NewsItem({
    required this.title,
    required this.date,
    required this.icon,
    required this.color,
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
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(date, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
        ],
      ),
    );
  }
}
