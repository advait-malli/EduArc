import 'package:flutter/material.dart';
import '../../widgets/common/primary_page_header.dart';
import '../../widgets/common/info_row.dart';
import '../settings/settings_page.dart';
import '../../core/services/title_service.dart';
import '../../core/utils/responsive_layout.dart';

class CommunicatePage extends StatefulWidget {
  final String role;

  const CommunicatePage({super.key, required this.role});

  @override
  State<CommunicatePage> createState() => _CommunicatePageState();
}

class _CommunicatePageState extends State<CommunicatePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> announcements = [
    {
      'sender': 'Admin',
      'role': 'School',
      'message': 'School will be closed on Friday for maintenance',
      'time': '1d ago',
      'icon': Icons.campaign,
    },
    {
      'sender': 'Principal',
      'role': 'School',
      'message': 'Parent-teacher meetings next week',
      'time': '2d ago',
      'icon': Icons.campaign,
    },
  ];

  final List<Map<String, dynamic>> personalMessages = [
    {
      'sender': 'Mr. Smith',
      'role': 'Mathematics',
      'message': 'Please submit your homework by tomorrow',
      'time': '2h ago',
      'icon': Icons.calculate,
      'unread': true,
    },
    {
      'sender': 'Ms. Johnson',
      'role': 'Biology',
      'message': 'Lab session postponed to next week',
      'time': '5h ago',
      'icon': Icons.science,
      'unread': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsPage()),
                    );
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

  Widget _buildMessageList(List<Map<String, dynamic>> messages,
      {required bool isAnnouncement}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        final color = isAnnouncement
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.tertiary;
        final icon = isAnnouncement ? Icons.campaign : (msg['icon'] as IconData);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 22,
                  ),
                ),
                if (!isAnnouncement && (msg['unread'] as bool))
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
            title: Text(
              isAnnouncement
                  ? '${msg['sender']}'
                  : '${msg['sender']} (${msg['role']})',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              msg['message']!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              msg['time']!,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
            ),
            onTap: () => _showMessageDetails(context, msg, isAnnouncement),
          ),
        );
      },
    );
  }

  void _showMessageDetails(BuildContext context, Map<String, dynamic> msg,
      bool isAnnouncement) {
    final color = isAnnouncement
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.tertiary;
    final icon = isAnnouncement ? Icons.campaign : (msg['icon'] as IconData);

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
                      color: color.withOpacity(0.1),
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
                          msg['sender'],
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          msg['role'],
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isAnnouncement && (msg['unread'] as bool))
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
              InfoRow(label: 'From', value: msg['sender']),
              if (!isAnnouncement) ...[
                const SizedBox(height: 12),
                InfoRow(label: 'Subject', value: msg['role']),
              ],
              const SizedBox(height: 12),
              InfoRow(label: 'Time', value: msg['time']),
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
                msg['message'],
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Reply functionality coming soon!'),
                            ),
                          );
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

  void _showNewMessageSheet(BuildContext context) {
    final color = Theme.of(context).colorScheme.tertiary;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
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
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.message,
                      color: color,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'New Message',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Send a message to students',
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
              TextField(
                decoration: InputDecoration(
                  labelText: 'Recipient',
                  hintText: 'Enter student name or class',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Subject',
                  hintText: 'Enter message subject',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.subject),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                maxLines: 6,
                decoration: InputDecoration(
                  labelText: 'Message',
                  hintText: 'Type your message here',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                      onPressed: () => Navigator.pop(context),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Message sent successfully!'),
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Text('Send'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 16),
            ],
          ),
        ),
      ),
    );
  }
}
