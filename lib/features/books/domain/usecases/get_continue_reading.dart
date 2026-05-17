import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/book_entity.dart';
import '../repositories/book_repository.dart';

class GetContinueReading implements UseCase<List<BookEntity>, NoParams> {
  final BookRepository _repository;
  GetContinueReading(this._repository);

  @override
  Future<Either<Failure, List<BookEntity>>> call(NoParams params) =>
      _repository.getContinueReading();
}
