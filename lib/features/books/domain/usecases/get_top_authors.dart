import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/author_entity.dart';
import '../repositories/author_repository.dart';

class GetTopAuthors implements UseCase<List<AuthorEntity>, int> {
  final AuthorRepository _repository;
  GetTopAuthors(this._repository);

  @override
  Future<Either<Failure, List<AuthorEntity>>> call(int limit) =>
      _repository.getTopAuthors(limit: limit);
}
