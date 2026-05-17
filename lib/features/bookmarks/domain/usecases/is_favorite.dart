import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/bookmarks_repository.dart';

class IsFavorite implements UseCase<bool, String> {
  final BookmarksRepository _repository;
  IsFavorite(this._repository);

  @override
  Future<Either<Failure, bool>> call(String bookId) =>
      _repository.isFavorite(bookId);
}
