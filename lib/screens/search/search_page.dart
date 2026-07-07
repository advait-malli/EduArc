import 'package:flutter/material.dart';
import '../../core/repositories/repository_provider.dart';
import '../../core/services/search_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<SearchItem> _results = [];
  List<String> _suggestions = [];
  bool _isSearching = false;
  bool _loaded = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      _suggestions = RepositoryProvider.of(context).searchRepository.getPopularSuggestions();
    }
  }

  void _performSearch(String query) {
    if (!_loaded) return;
    setState(() {
      _isSearching = query.isNotEmpty;
      _results = RepositoryProvider.of(context).searchRepository.search(query);
    });
  }

  void _navigateToResult(SearchItem item) {
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navigating to ${item.title}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              isMobile ? 16 : 24,
              16,
              isMobile ? 16 : 24,
              12,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search homework, classes, messages...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                    ),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                    onChanged: _performSearch,
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _performSearch('');
                    },
                  ),
              ],
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (!_isSearching) {
      return _buildSuggestions();
    }

    if (_results.isEmpty) {
      return _buildNoResults();
    }

    return _buildResults();
  }

  Widget _buildSuggestions() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Popular searches',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
          ),
        ),
        ..._suggestions.map((suggestion) => ListTile(
              leading: const Icon(Icons.search),
              title: Text(suggestion),
              onTap: () {
                _searchController.text = suggestion;
                _performSearch(suggestion);
              },
            )),
      ],
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching for something else',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    final groupedResults = <String, List<SearchItem>>{};
    for (final item in _results) {
      groupedResults.putIfAbsent(item.category, () => []).add(item);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: groupedResults.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                entry.key,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
              ),
            ),
            ...entry.value.map((item) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: item.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item.icon, color: item.color, size: 24),
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(item.subtitle),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _navigateToResult(item),
                  ),
                )),
            const SizedBox(height: 8),
          ],
        );
      }).toList(),
    );
  }
}
