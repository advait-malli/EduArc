import 'package:flutter/material.dart';
import '../../widgets/common/primary_page_header.dart';
import '../../widgets/common/info_row.dart';
import '../../core/services/title_service.dart';
import '../settings/settings_page.dart';
import '../../core/utils/responsive_layout.dart';
import '../../core/repositories/repository_provider.dart';
import '../../core/models/homework.dart';
import '../../core/models/message.dart';
import '../../core/utils/subject_helpers.dart';

class HomeworkPage extends StatefulWidget {
  final String role;

  const HomeworkPage({super.key, required this.role});

  @override
  State<HomeworkPage> createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<HomeworkPage> {
  List<Homework> homeworks = [];
  List<Message> messages = [];
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
    final repo = RepositoryProvider.of(context).homeworkRepository;
    final msgRepo = RepositoryProvider.of(context).messageRepository;
    final hw = await repo.getHomeworkList();
    final msgs = await msgRepo.getPersonalMessages();
    if (mounted) setState(() { homeworks = hw; messages = msgs; isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    // Set page title
    TitleService.setTitle('Homework');

    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: PrimaryPageHeader(
                  title: 'Homework',
                  subtitle: 'Assignments & study materials',
                  onSettingsPressed: () {
                      showSettingsSheet(context);
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  children: List.generate(homeworks.length, (index) {
                    final hw = homeworks[index];
                    final color = Theme.of(context).colorScheme.primary;
                    final isFirst = index == 0;
                    final isLast = index == homeworks.length - 1;
                    final dueStr = '${hw.dueDate.month}/${hw.dueDate.day}/${hw.dueDate.year}';

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
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: borderRadius,
                      ),
                      child: InkWell(
                        borderRadius: borderRadius,
                        onTap: () => _showHomeworkDetails(context, hw),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(100),
                              ),
                    child: Icon(
                                  iconForSubject(hw.subject),
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
                                    hw.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${hw.subject} • Due: $dueStr',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: hw.status == 'Submitted'
                                    ? Theme.of(context).colorScheme.primaryContainer
                                          .withValues(alpha: 0.2)
                                    : Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer
                                          .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                hw.status,
                                style: TextStyle(
                                  color: hw.status == 'Submitted'
                                      ? Theme.of(context).colorScheme.onPrimaryContainer
                                      : Theme.of(context).colorScheme.onSecondaryContainer,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              ),
            ],
          ),
          if (widget.role == 'Teacher')
            if (isMobile)
              Positioned(
                right: 16,
                bottom: 80,
                child: _buildSecondaryFab(context),
              )
            else
              Positioned(
                right: 16,
                bottom: 16,
                child: _buildPrimaryFab(context),
              ),
        ],
      ),
    );
  }

  Widget _buildPrimaryFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showNewHomeworkSheet(context),
      child: const Icon(Icons.add),
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
    );
  }

  Widget _buildSecondaryFab(BuildContext context) {
    return FloatingActionButton.small(
      onPressed: () => _showNewHomeworkSheet(context),
      child: const Icon(Icons.add),
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
    );
  }

  void _showHomeworkDetails(BuildContext context, Homework hw) {
    final color = Theme.of(context).colorScheme.primary;
    final dueStr = '${hw.dueDate.month}/${hw.dueDate.day}/${hw.dueDate.year}';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(iconForSubject(hw.subject), color: Theme.of(context).colorScheme.primary, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hw.title,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          hw.subject,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              InfoRow(label: 'Subject', value: hw.subject),
              const SizedBox(height: 12),
              InfoRow(label: 'Due Date', value: dueStr),
              const SizedBox(height: 12),
              InfoRow(
                label: 'Status',
                value: hw.status,
                valueColor: hw.status == 'Submitted'
                    ? Colors.green
                    : Colors.orange,
              ),
              const SizedBox(height: 24),
              Text(
                'Description',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                hw.description,
                style: TextStyle(color: Colors.grey.shade700, height: 1.5),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () => Navigator.pop(context),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Text('Close'),
                    ),
                  ),
                  if (hw.status != 'Submitted') ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Homework submitted successfully!'),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                        ),
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showNewHomeworkSheet(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final titleCtrl = TextEditingController();
    final dueDateCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String selectedSubject = 'Mathematics';
    bool creating = false;

    final subjects = ['Mathematics', 'Biology', 'English', 'Chemistry', 'Physics', 'History'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) => Padding(
            padding: const EdgeInsets.all(24),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              controller: scrollController,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(iconForSubject(selectedSubject), color: color, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('New Homework',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                          Text('Create a new assignment',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(
                    labelText: 'Title', hintText: 'Enter homework title',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.title),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedSubject,
                  decoration: InputDecoration(
                    labelText: 'Subject',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.school),
                  ),
                  items: subjects.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (v) {
                    if (v != null) setSheetState(() => selectedSubject = v);
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: dueDateCtrl,
                  decoration: InputDecoration(
                    labelText: 'Due Date', hintText: 'YYYY-MM-DD',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descCtrl,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Description', hintText: 'Enter homework description',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 12, top: 12),
                      child: Icon(Icons.description),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.tonal(
                        onPressed: () => Navigator.pop(ctx),
                        style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: creating ? null : () async {
                          if (titleCtrl.text.isEmpty || dueDateCtrl.text.isEmpty || descCtrl.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please fill all fields')),
                            );
                            return;
                          }
                          setSheetState(() => creating = true);
                          try {
                            final dueDate = DateTime.parse(dueDateCtrl.text);
                            await RepositoryProvider.of(this.context).homeworkRepository.createHomework(
                              title: titleCtrl.text,
                              subject: selectedSubject,
                              description: descCtrl.text,
                              dueDate: dueDate,
                              subjectIcon: selectedSubject.toLowerCase(),
                              assignedTo: 'user_student',
                            );
                            if (ctx.mounted) Navigator.pop(ctx);
                            await _loadData();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Homework created!')),
                              );
                            }
                          } catch (e) {
                            setSheetState(() => creating = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed: $e')),
                            );
                          }
                        },
                        style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
                        child: creating
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Create'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
