import 'package:flutter/material.dart';
import '../../widgets/common/primary_page_header.dart';
import '../../core/repositories/repository_provider.dart';
import '../../core/models/syllabus.dart';
import '../settings/settings_page.dart';

class SyllabusPage extends StatefulWidget {
  final String role;

  const SyllabusPage({super.key, required this.role});

  @override
  State<SyllabusPage> createState() => _SyllabusPageState();
}

class _SyllabusPageState extends State<SyllabusPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Syllabus> syllabusList = [];
  bool isLoading = true;
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
    final repo = RepositoryProvider.of(context).syllabusRepository;
    final data = await repo.getSyllabus();
    if (mounted) {
      setState(() {
        syllabusList = data;
        isLoading = false;
      });
      _tabController = TabController(length: syllabusList.length, vsync: this);
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
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
              title: 'Syllabus',
              subtitle: 'Subject-wise syllabus coverage',
              onSettingsPressed: () => showSettingsSheet(context),
            ),
          ),
          if (isLoading)
            const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
          else if (syllabusList.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.menu_book_outlined, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text('No syllabus data', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                  ],
                ),
              ),
            )
          else ...[
            SliverToBoxAdapter(
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: Theme.of(context).colorScheme.primary,
                indicatorColor: Theme.of(context).colorScheme.primary,
                tabs: syllabusList.map((s) => Tab(text: s.subject)).toList(),
                onTap: (_) => setState(() {}),
              ),
            ),
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: syllabusList.map((s) => _buildSyllabusContent(s)).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSyllabusContent(Syllabus syllabus) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildProgressSummary(syllabus),
        const SizedBox(height: 16),
        ...syllabus.chapters.asMap().entries.map((entry) {
          final index = entry.key;
          final chapter = entry.value;
          final isFirst = index == 0;
          final isLast = index == syllabus.chapters.length - 1;
          return _buildChapterCard(chapter, isFirst, isLast);
        }),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildProgressSummary(Syllabus syllabus) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Syllabus Progress', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text('${syllabus.completedChapters}/${syllabus.totalChapters} chapters completed',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
              ],
            ),
          ),
          SizedBox(
            width: 56,
            height: 56,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: syllabus.overallProgress / 100,
                  strokeWidth: 6,
                  backgroundColor: Theme.of(context).colorScheme.outlineVariant,
                ),
                Text('${syllabus.overallProgress.round()}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterCard(SyllabusChapter chapter, bool isFirst, bool isLast) {
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

    final color = chapter.status == 'Completed'
        ? Colors.green
        : chapter.status == 'Ongoing'
            ? Theme.of(context).colorScheme.primary
            : Colors.grey;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: borderRadius),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(
              chapter.status == 'Completed' ? Icons.check_circle : chapter.status == 'Ongoing' ? Icons.play_circle : Icons.lock,
              color: color,
              size: 20,
            ),
          ),
          title: Text(chapter.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(chapter.description, style: TextStyle(color: Colors.grey.shade600, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: chapter.progress / 100,
                        backgroundColor: Theme.of(context).colorScheme.outlineVariant,
                        color: color,
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('${chapter.progress}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
                ],
              ),
            ],
          ),
          children: [
            if (chapter.topics.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: chapter.topics.map((topic) => Chip(
                  label: Text(topic, style: const TextStyle(fontSize: 11)),
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                )).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
