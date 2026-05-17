import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/book_entity.dart';
import '../repositories/book_repository.dart';

class GetRecommendations implements UseCase<List<BookEntity>, int> {
  final BookRepository _repository;
  GetRecommendations(this._repository);

  @override
  Future<Either<Failure, List<BookEntity>>> call(int limit) =>
      _repository.getRecommendations(limit: limit);
}
