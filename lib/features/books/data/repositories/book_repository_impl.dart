import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/book_entity.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/book_remote_datasource.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDatasource _datasource;
  final String? Function() _getUserId;

  BookRepositoryImpl(this._datasource, this._getUserId);

  @override
  Future<Either<Failure, List<BookEntity>>> getFeaturedBooks() async {
    try {
      final books = await _datasource.getFeaturedBooks();
      return Right(books);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<BookEntity>>> getContinueReading() async {
    final userId = _getUserId();
    if (userId == null) return const Right([]);
    try {
      final books = await _datasource.getContinueReading(userId);
      return Right(books);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<BookEntity>>> getRecommendations({int limit = 6}) async {
    try {
      final books = await _datasource.getRecommendations(limit: limit);
      return Right(books);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<BookEntity>>> searchBooks(String query) async {
    try {
      final books = await _datasource.searchBooks(query);
      return Right(books);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<BookEntity>>> getBooksByTag(String tag) async {
    try {
      final books = await _datasource.getBooksByTag(tag);
      return Right(books);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, BookEntity>> getBookById(String id) async {
    try {
      final book = await _datasource.getBookById(id);
      return Right(book);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
