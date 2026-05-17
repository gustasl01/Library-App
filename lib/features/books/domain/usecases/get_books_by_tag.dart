import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/book_entity.dart';
import '../repositories/book_repository.dart';

class GetBooksByTag implements UseCase<List<BookEntity>, String> {
  final BookRepository _repository;
  GetBooksByTag(this._repository);

  @override
  Future<Either<Failure, List<BookEntity>>> call(String tag) =>
      _repository.getBooksByTag(tag);
}
