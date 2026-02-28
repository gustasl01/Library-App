import '../../domain/entities/book_entity.dart';
import '../../domain/usecases/books/get_books_usecase.dart';
import '../../external/datasources/book_datasource_impl.dart';

class BookRepository implements GetBooksUsecase {
  final BookDatasourceImpl _datasource = BookDatasourceImpl();

  @override
  Future<List<BookEntity>> call() async {
    return await _datasource.getBooks();
  }

  Future<List<BookEntity>> getFeatured() async {
    return await _datasource.getFeaturedBooks();
  }

  Future<List<BookEntity>> search(String query) async {
    return await _datasource.searchBooks(query);
  }

  Future<List<BookEntity>> getContinueReading() async {
    return await _datasource.getContinueReadingBooks();
  }

  Future<List<BookEntity>> getByTag(String tagName) async {
    return await _datasource.getBooksByTag(tagName);
  }

  Future<List<BookEntity>> getRecommendations({int limit = 5}) async {
    return await _datasource.getRecommendations(limit: limit);
  }

  Future<BookEntity> getBookById(String id) async {
    return await _datasource.getBookById(id);
  }

  Future<void> addToFavorites(String bookId) async {
    return await _datasource.addToFavorites(bookId);
  }

  Future<void> removeFromFavorites(String bookId) async {
    return await _datasource.removeFromFavorites(bookId);
  }

  Future<bool> isFavorite(String bookId) async {
    return await _datasource.isFavorite(bookId);
  }

  Future<List<BookEntity>> getFavorites() async {
    return await _datasource.getFavoriteBooks();
  }

  Future<void> updateReadingProgress(
    String bookId, {
    required int currentChapter,
    required double progress,
  }) async {
    return await _datasource.updateReadingProgress(
      bookId,
      currentChapter: currentChapter,
      progress: progress,
    );
  }

  Future<Map<String, dynamic>?> getReadingProgress(String bookId) async {
    return await _datasource.getReadingProgress(bookId);
  }
}
