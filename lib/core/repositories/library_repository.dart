import '../models/library.dart';
import '../services/api_service.dart';
import 'interfaces.dart';

class LibraryRepository implements ILibraryRepository {
  final ApiService _api = ApiService();

  @override
  Future<List<LibraryBook>> getBooks() async {
    final List<Map<String, dynamic>> booksJson = await _api.getLibraryBooks();
    return booksJson.map((json) => LibraryBook.fromJson(json)).toList();
  }

  @override
  Future<List<LibraryRecord>> getRecords() async {
    final List<Map<String, dynamic>> recordsJson = await _api.getLibraryRecords();
    return recordsJson.map((json) => LibraryRecord.fromJson(json)).toList();
  }

  @override
  Future<bool> issueBook(String bookId) async {
    await _api.issueBook(bookId);
    return true;
  }

  @override
  Future<bool> returnBook(String recordId) async {
    await _api.returnBook(recordId);
    return true;
  }
}
