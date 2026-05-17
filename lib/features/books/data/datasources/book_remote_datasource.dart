import '../../../../core/errors/exceptions.dart';
import '../../../../core/mock/mock_database.dart';
import '../models/book_model.dart';

abstract class BookRemoteDatasource {
  Future<List<BookModel>> getFeaturedBooks();
  Future<List<BookModel>> getContinueReading(String userId);
  Future<List<BookModel>> getRecommendations({int limit = 6});
  Future<List<BookModel>> searchBooks(String query);
  Future<List<BookModel>> getBooksByTag(String tag);
  Future<BookModel> getBookById(String id);
}

class BookMockDatasource implements BookRemoteDatasource {
  final _db = MockDatabase.instance;

  @override
  Future<List<BookModel>> getFeaturedBooks() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _db.featuredBooks;
  }

  @override
  Future<List<BookModel>> getContinueReading(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _db.continueReading;
  }

  @override
  Future<List<BookModel>> getRecommendations({int limit = 6}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _db.recommendations(limit: limit);
  }

  @override
  Future<List<BookModel>> searchBooks(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _db.search(query);
  }

  @override
  Future<List<BookModel>> getBooksByTag(String tag) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _db.byTag(tag);
  }

  @override
  Future<BookModel> getBookById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final book = _db.byId(id);
    if (book == null) throw ServerException('Livro não encontrado.');
    return book;
  }
}
