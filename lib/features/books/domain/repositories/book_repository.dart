import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/book_entity.dart';

abstract class BookRepository {
  Future<Either<Failure, List<BookEntity>>> getFeaturedBooks();
  Future<Either<Failure, List<BookEntity>>> getContinueReading();
  Future<Either<Failure, List<BookEntity>>> getRecommendations({int limit = 6});
  Future<Either<Failure, List<BookEntity>>> searchBooks(String query);
  Future<Either<Failure, List<BookEntity>>> getBooksByTag(String tag);
  Future<Either<Failure, BookEntity>> getBookById(String id);
}
