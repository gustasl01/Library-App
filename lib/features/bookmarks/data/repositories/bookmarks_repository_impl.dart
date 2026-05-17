import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../books/domain/entities/book_entity.dart';
import '../../domain/repositories/bookmarks_repository.dart';
import '../datasources/bookmarks_remote_datasource.dart';

class BookmarksRepositoryImpl implements BookmarksRepository {
  final BookmarksRemoteDatasource _datasource;
  final String? Function() _getUserId;

  BookmarksRepositoryImpl(this._datasource, this._getUserId);

  @override
  Future<Either<Failure, List<BookEntity>>> getFavorites() async {
    final userId = _getUserId();
    if (userId == null) return const Right([]);
    try {
      final books = await _datasource.getFavorites(userId);
      return Right(books);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addToFavorites(String bookId) async {
    final userId = _getUserId();
    if (userId == null) return Left(const AuthFailure('Não autenticado'));
    try {
      await _datasource.addToFavorites(userId: userId, bookId: bookId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromFavorites(String bookId) async {
    final userId = _getUserId();
    if (userId == null) return Left(const AuthFailure('Não autenticado'));
    try {
      await _datasource.removeFromFavorites(userId: userId, bookId: bookId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(String bookId) async {
    final userId = _getUserId();
    if (userId == null) return const Right(false);
    try {
      final result = await _datasource.isFavorite(userId: userId, bookId: bookId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
