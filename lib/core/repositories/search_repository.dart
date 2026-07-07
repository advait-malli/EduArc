import 'interfaces.dart';
import '../services/search_service.dart';

class SearchRepository implements ISearchRepository {
  @override
  List<String> getPopularSuggestions() => [];

  @override
  List<SearchItem> search(String query) => SearchService.search(query);
}
