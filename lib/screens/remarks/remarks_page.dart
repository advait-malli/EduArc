import 'package:flutter/material.dart';
import '../../widgets/common/primary_page_header.dart';
import '../../core/repositories/repository_provider.dart';
import '../../core/models/remark.dart';
import '../settings/settings_page.dart';

class RemarksPage extends StatefulWidget {
  final String role;

  const RemarksPage({super.key, required this.role});

  @override
  State<RemarksPage> createState() => _RemarksPageState();
}

class _RemarksPageState extends State<RemarksPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Remark> remarks = [];
  List<Achievement> achievements = [];
  bool isLoading = true;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    final repo = RepositoryProvider.of(context).remarksRepository;
    final r = await repo.getRemarks();
    final a = await repo.getAchievements();
    if (mounted) setState(() { remarks = r; achievements = a; isLoading = false; });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PrimaryPageHeader(
              title: 'Remarks & Achievements',
              subtitle: 'Teacher feedback and recognitions',
              onSettingsPressed: () => showSettingsSheet(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelColor: Theme.of(context).colorScheme.primary,
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  tabs: const [
                    Tab(text: 'Remarks'),
                    Tab(text: 'Achievements'),
                  ],
                  onTap: (_) => setState(() {}),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          if (isLoading)
            const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
          else
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildRemarksList(),
                  _buildAchievementsList(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRemarksList() {
    if (remarks.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.rate_review_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text('No remarks yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: remarks.length,
      itemBuilder: (context, index) {
        final remark = remarks[index];
        final isFirst = index == 0;
        final isLast = index == remarks.length - 1;
        BorderRadius borderRadius;
        if (isFirst && isLast) {
          borderRadius = BorderRadius.circular(24);
        } else if (isFirst) {
          borderRadius = const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10));
        } else if (isLast) {
          borderRadius = const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24));
        } else {
          borderRadius = BorderRadius.circular(10);
        }

        final color = remark.type == 'Behavior'
            ? Colors.orange
            : remark.type == 'Academic'
                ? Theme.of(context).colorScheme.primary
                : Colors.teal;

        return Container(
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: borderRadius),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(_iconForType(remark.type), color: color, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(remark.teacherName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          Text(remark.subject, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(remark.type, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(remark.remark, style: TextStyle(color: Colors.grey.shade700, fontSize: 13, height: 1.4)),
                const SizedBox(height: 6),
                Text(_formatDate(remark.date), style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAchievementsList() {
    if (achievements.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text('No achievements yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final ach = achievements[index];
        final isFirst = index == 0;
        final isLast = index == achievements.length - 1;
        BorderRadius borderRadius;
        if (isFirst && isLast) {
          borderRadius = BorderRadius.circular(24);
        } else if (isFirst) {
          borderRadius = const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10));
        } else if (isLast) {
          borderRadius = const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24));
        } else {
          borderRadius = BorderRadius.circular(10);
        }

        final color = ach.category == 'Academic'
            ? Colors.amber
            : ach.category == 'Sports'
                ? Colors.green
                : ach.category == 'Arts'
                    ? Colors.purple
                    : Colors.blue;

        return Container(
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: borderRadius),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(Icons.emoji_events, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ach.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(ach.description, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(ach.category, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
                          ),
                          const SizedBox(width: 8),
                          Text('by ${ach.awardedBy}', style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'Behavior': return Icons.psychology;
      case 'Academic': return Icons.school;
      default: return Icons.star;
    }
  }

  String _formatDate(DateTime date) {
    final months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month]} ${date.year}';
  }
}
