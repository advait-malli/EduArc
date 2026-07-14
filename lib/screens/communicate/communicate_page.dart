import 'package:flutter/material.dart';
import '../../widgets/common/primary_page_header.dart';
import '../../widgets/common/info_row.dart';
import '../../core/services/title_service.dart';
import '../../core/utils/responsive_layout.dart';
import '../settings/settings_page.dart';
import '../../core/repositories/repository_provider.dart';
import '../../core/models/message.dart';
import '../../core/models/calendar.dart';
import '../../core/utils/subject_helpers.dart';

class CommunicatePage extends StatefulWidget {
  final String role;

  const CommunicatePage({super.key, required this.role});

  @override
  State<CommunicatePage> createState() => _CommunicatePageState();
}

class _CommunicatePageState extends State<CommunicatePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Message> announcements = [];
  List<Message> personalMessages = [];
  List<NewsItem> circulars = [];
  bool isLoading = true;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
    final repo = RepositoryProvider.of(context).messageRepository;
    final newsRepo = RepositoryProvider.of(context).newsRepository as dynamic;
    final ann = await repo.getAnnouncements();
    final msgs = await repo.getPersonalMessages();
    final circ = await newsRepo.getCirculars();
    if (mounted) setState(() { announcements = ann; personalMessages = msgs; circulars = circ; isLoading = false; });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TitleService.setTitle('Communicate');

    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: PrimaryPageHeader(
                  title: 'Communicate',
                  subtitle: 'Messages and announcements',
                  onSettingsPressed: () {
                      showSettingsSheet(context);
                  },
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
                        Tab(text: 'Announcements'),
                        Tab(text: 'Messages'),
                        Tab(text: 'Circulars'),
                      ],
                      onTap: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildMessageList(announcements, isAnnouncement: true),
                    _buildMessageList(personalMessages, isAnnouncement: false),
                    _buildCircularsList(),
                  ],
                ),
              ),
            ],
          ),
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
      onPressed: () => _showNewMessageSheet(context),
      child: const Icon(Icons.add),
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
    );
  }

  Widget _buildSecondaryFab(BuildContext context) {
    return FloatingActionButton.small(
      onPressed: () => _showNewMessageSheet(context),
      child: const Icon(Icons.add),
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
    );
  }

  Widget _buildMessageList(List<Message> messages,
      {required bool isAnnouncement}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        final color = isAnnouncement
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.tertiary;
        final icon = isAnnouncement
            ? Icons.campaign
            : iconForSubject(msg.senderRole ?? '');
        final isFirst = index == 0;
        final isLast = index == messages.length - 1;

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
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: borderRadius,
          ),
          child: InkWell(
            borderRadius: borderRadius,
            onTap: () => _showMessageDetails(context, msg, isAnnouncement),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Icon(icon, color: color, size: 20),
                      ),
                      if (!isAnnouncement && msg.isUnread)
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAnnouncement
                              ? msg.senderName
                              : '${msg.senderName} (${msg.senderRole ?? msg.subject})',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          msg.message,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatTime(msg.timestamp),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCircularsList() {
    if (circulars.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.campaign_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text('No circulars', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: circulars.length,
      itemBuilder: (context, index) {
        final circular = circulars[index];
        final isFirst = index == 0;
        final isLast = index == circulars.length - 1;
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

        final color = Theme.of(context).colorScheme.primary;

        return Container(
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: borderRadius,
          ),
          child: InkWell(
            borderRadius: borderRadius,
            onTap: () => _showCircularBottomSheet(context, circular),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Icon(Icons.campaign, color: color, size: 20),
                      ),
                      if (circular.isImportant)
                        Container(
                          width: 10, height: 10,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(circular.title,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(circular.summary,
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(_formatTime(circular.publishedDate),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCircularBottomSheet(BuildContext context, NewsItem circular) {
    final color = Theme.of(context).colorScheme.primary;

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
                  width: 40, height: 4,
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
                    child: Icon(Icons.campaign, color: color, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(circular.title,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                        Text(circular.author ?? 'Administration',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              InfoRow(label: 'Published', value: _formatTime(circular.publishedDate)),
              const SizedBox(height: 24),
              Text('Details',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(circular.content,
                style: TextStyle(color: Colors.grey.shade700, height: 1.5)),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonal(
                  onPressed: () => Navigator.pop(context),
                  style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
                  child: const Text('Close'),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showMessageDetails(
      BuildContext context, Message msg, bool isAnnouncement) {
    // mark as read if unread
    if (!isAnnouncement && msg.isUnread) {
      RepositoryProvider.of(context).messageRepository.markAsRead(msg.id);
    }

    final color = isAnnouncement
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.tertiary;
    final icon = isAnnouncement
        ? Icons.campaign
        : iconForSubject(msg.senderRole ?? '');

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
                    child: Icon(icon, color: color, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.senderName,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          msg.senderRole ?? msg.subject,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isAnnouncement && msg.isUnread)
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              InfoRow(label: 'From', value: msg.senderName),
              if (!isAnnouncement) ...[
                const SizedBox(height: 12),
                InfoRow(label: 'Subject', value: msg.senderRole ?? msg.subject),
              ],
              const SizedBox(height: 12),
              InfoRow(label: 'Time', value: _formatTime(msg.timestamp)),
              const SizedBox(height: 24),
              Text(
                'Message',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                msg.message,
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
                  if (!isAnnouncement) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showReplySheet(context, msg);
                        },
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                        ),
                        child: const Text('Reply'),
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

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  void _showNewMessageSheet(BuildContext context) {
    final color = Theme.of(context).colorScheme.tertiary;
    final recipientCtrl = TextEditingController();
    final subjectCtrl = TextEditingController();
    final messageCtrl = TextEditingController();
    bool sending = false;
    final isTeacher = widget.role == 'teacher';

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
                    width: 40, height: 4,
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
                      child: Icon(Icons.message, color: Theme.of(context).colorScheme.tertiary, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('New Message', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                          Text(isTeacher ? 'Send a message to students' : 'Send a message to your teacher',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: recipientCtrl,
                  decoration: InputDecoration(
                    labelText: 'Recipient',
                    hintText: 'Enter email address',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: subjectCtrl,
                  decoration: InputDecoration(
                    labelText: 'Subject', hintText: 'Enter message subject',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.subject),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: messageCtrl,
                  maxLines: 6,
                  decoration: InputDecoration(
                    labelText: 'Message', hintText: 'Type your message here',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 12, top: 12),
                      child: Icon(Icons.message),
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
                        onPressed: sending ? null : () async {
                          if (recipientCtrl.text.isEmpty || subjectCtrl.text.isEmpty || messageCtrl.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please fill all fields')),
                            );
                            return;
                          }
                          setSheetState(() => sending = true);
                          try {
                            await RepositoryProvider.of(this.context).messageRepository.sendMessage(
                              recipientId: recipientCtrl.text,
                              subject: subjectCtrl.text,
                              message: messageCtrl.text,
                            );
                            if (ctx.mounted) Navigator.pop(ctx);
                            await _loadData();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Message sent!')),
                              );
                            }
                          } catch (e) {
                            setSheetState(() => sending = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed: $e')),
                            );
                          }
                        },
                        style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
                        child: sending
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Send'),
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

  void _showReplySheet(BuildContext context, Message original) {
    final color = Theme.of(context).colorScheme.tertiary;
    final messageCtrl = TextEditingController();
    bool sending = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) => Padding(
            padding: const EdgeInsets.all(24),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              controller: scrollController,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4,
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
                      child: Icon(Icons.reply, color: color, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Reply', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                          Text('To: ${original.senderName}', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Original message', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(original.message, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: messageCtrl,
                  maxLines: 6,
                  decoration: InputDecoration(
                    labelText: 'Your reply', hintText: 'Type your reply here',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 12, top: 12),
                      child: Icon(Icons.message),
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
                        onPressed: sending ? null : () async {
                          if (messageCtrl.text.isEmpty) return;
                          setSheetState(() => sending = true);
                          try {
                            await RepositoryProvider.of(this.context).messageRepository.sendMessage(
                              recipientId: original.senderId,
                              subject: 'Re: ${original.subject}',
                              message: messageCtrl.text,
                            );
                            if (ctx.mounted) Navigator.pop(ctx);
                            await _loadData();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Reply sent!')),
                              );
                            }
                          } catch (e) {
                            setSheetState(() => sending = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed: $e')),
                            );
                          }
                        },
                        style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
                        child: sending
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Send Reply'),
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
