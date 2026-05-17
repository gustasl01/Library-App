import '../../../../core/mock/mock_database.dart';
import '../../../books/data/models/book_model.dart';

abstract class BookmarksRemoteDatasource {
  Future<List<BookModel>> getFavorites(String userId);
  Future<void> addToFavorites({required String userId, required String bookId});
  Future<void> removeFromFavorites({required String userId, required String bookId});
  Future<bool> isFavorite({required String userId, required String bookId});
}

class BookmarksMockDatasource implements BookmarksRemoteDatasource {
  final _db = MockDatabase.instance;

  @override
  Future<List<BookModel>> getFavorites(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _db.favorites;
  }

  @override
  Future<void> addToFavorites({required String userId, required String bookId}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _db.addFavorite(bookId);
  }

  @override
  Future<void> removeFromFavorites({required String userId, required String bookId}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _db.removeFavorite(bookId);
  }

  @override
  Future<bool> isFavorite({required String userId, required String bookId}) async {
    return _db.isFavorite(bookId);
  }
}
