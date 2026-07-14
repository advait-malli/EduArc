import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../widgets/common/primary_page_header.dart';
import '../../core/repositories/repository_provider.dart';
import '../../core/models/exam_result.dart';
import '../settings/settings_page.dart';

class ResultsPage extends StatefulWidget {
  final String role;

  const ResultsPage({super.key, required this.role});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  List<ExamResult> results = [];
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
    final repo = RepositoryProvider.of(context).resultsRepository;
    final data = await repo.getResults();
    if (mounted) setState(() { results = data; isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PrimaryPageHeader(
              title: 'Results & Performance',
              subtitle: 'Exam results and analytics',
              onSettingsPressed: () => showSettingsSheet(context),
            ),
          ),
          if (isLoading)
            const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
          else if (results.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.assessment_outlined, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text('No results available', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                  ],
                ),
              ),
            )
          else ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: _buildOverallPerformance(context),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildResultCard(context, results[index], index),
                  childCount: results.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ],
      ),
    );
  }

  Widget _buildOverallPerformance(BuildContext context) {
    final avgPercentage = results.isEmpty
        ? 0.0
        : results.map((r) => r.percentage).reduce((a, b) => a + b) / results.length;
    final latest = results.isNotEmpty ? results.first : null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: avgPercentage / 100,
                  strokeWidth: 8,
                  backgroundColor: Theme.of(context).colorScheme.outlineVariant,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Text(
                  '${avgPercentage.toStringAsFixed(1)}%',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Overall Average', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                if (latest != null)
                  Text('Latest: ${latest.examName} — ${latest.grade}',
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                Text('${results.length} exam(s) recorded',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, ExamResult result, int index) {
    final isFirst = index == 0;
    final isLast = index == results.length - 1;
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
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(_iconForType(result.examType), color: Theme.of(context).colorScheme.primary, size: 20),
          ),
          title: Text(result.examName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          subtitle: Text(
            '${result.obtainedMarks}/${result.totalMarks} • ${result.percentage.toStringAsFixed(1)}% • ${result.grade}',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          children: [
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIdx, rod, rodIdx) {
                        final subject = result.subjects[group.x.toInt()];
                        return BarTooltipItem(
                          '${subject.subject}\n${subject.marksObtained}/${subject.maxMarks}',
                          const TextStyle(color: Colors.white, fontSize: 12),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx < result.subjects.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                result.subjects[idx].subject.substring(0, result.subjects[idx].subject.length.clamp(0, 4)),
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  barGroups: result.subjects.asMap().entries.map((entry) {
                    final pct = entry.value.percentage;
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: pct,
                          color: Theme.of(context).colorScheme.primary,
                          width: 24,
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            if (result.remarks != null) ...[
              const SizedBox(height: 8),
              Text(result.remarks!, style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontStyle: FontStyle.italic)),
            ],
          ],
        ),
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'Formative': return Icons.quiz;
      case 'Summative': return Icons.assignment;
      case 'Quarterly': return Icons.calendar_month;
      case 'Annual': return Icons.school;
      default: return Icons.assessment;
    }
  }
}
