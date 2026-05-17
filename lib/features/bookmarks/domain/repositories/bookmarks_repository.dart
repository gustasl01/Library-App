import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../books/domain/entities/book_entity.dart';

abstract class BookmarksRepository {
  Future<Either<Failure, List<BookEntity>>> getFavorites();
  Future<Either<Failure, void>> addToFavorites(String bookId);
  Future<Either<Failure, void>> removeFromFavorites(String bookId);
  Future<Either<Failure, bool>> isFavorite(String bookId);
}
