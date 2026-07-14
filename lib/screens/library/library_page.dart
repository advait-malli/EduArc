import 'package:flutter/material.dart';
import '../../widgets/common/primary_page_header.dart';
import '../../core/repositories/repository_provider.dart';
import '../../core/models/library.dart';
import '../settings/settings_page.dart';

class LibraryPage extends StatefulWidget {
  final String role;

  const LibraryPage({super.key, required this.role});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<LibraryBook> books = [];
  List<LibraryRecord> records = [];
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
    final repo = RepositoryProvider.of(context).libraryRepository;
    final b = await repo.getBooks();
    final r = await repo.getRecords();
    if (mounted) setState(() { books = b; records = r; isLoading = false; });
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
              title: 'Library',
              subtitle: 'Browse & manage books',
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
                    Tab(text: 'Catalog'),
                    Tab(text: 'My Books'),
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
                  _buildCatalog(),
                  _buildMyBooks(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCatalog() {
    if (books.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.library_books_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text('No books in catalog', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        final isFirst = index == 0;
        final isLast = index == books.length - 1;
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
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.book, color: Theme.of(context).colorScheme.primary, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(book.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text(book.author, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(book.category, style: const TextStyle(fontSize: 10)),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${book.availableCopies}/${book.totalCopies} available',
                            style: TextStyle(
                              fontSize: 11,
                              color: book.isAvailable ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                FilledButton.tonal(
                  onPressed: book.isAvailable ? () => _issueBook(book) : null,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: const Text('Issue', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMyBooks() {
    if (records.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bookmark_border, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text('No books issued', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        final isFirst = index == 0;
        final isLast = index == records.length - 1;
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

        final isReturned = record.status == 'Returned';
        final color = isReturned ? Colors.green : record.isOverdue ? Colors.red : Colors.orange;

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
                      child: Icon(isReturned ? Icons.check_circle : Icons.book, color: color, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(record.bookTitle, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text('Issued: ${_formatDate(record.issueDate)}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(record.status, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text('Due: ${_formatDate(record.dueDate)}', style: TextStyle(fontSize: 12, color: record.isOverdue ? Colors.red : Colors.grey.shade600)),
                    const Spacer(),
                    if (!isReturned)
                      FilledButton.tonal(
                        onPressed: () => _returnBook(record),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          visualDensity: VisualDensity.compact,
                        ),
                        child: const Text('Return', style: TextStyle(fontSize: 12)),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _issueBook(LibraryBook book) async {
    try {
      await RepositoryProvider.of(context).libraryRepository.issueBook(book.id);
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('"${book.title}" issued successfully')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to issue: $e')));
      }
    }
  }

  Future<void> _returnBook(LibraryRecord record) async {
    try {
      await RepositoryProvider.of(context).libraryRepository.returnBook(record.id);
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Book returned successfully')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to return: $e')));
      }
    }
  }

  String _formatDate(DateTime date) {
    final months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month]} ${date.year}';
  }
}
