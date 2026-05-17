import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/book_entity.dart';
import '../repositories/book_repository.dart';

class SearchBooks implements UseCase<List<BookEntity>, String> {
  final BookRepository _repository;
  SearchBooks(this._repository);

  @override
  Future<Either<Failure, List<BookEntity>>> call(String query) =>
      _repository.searchBooks(query);
}
