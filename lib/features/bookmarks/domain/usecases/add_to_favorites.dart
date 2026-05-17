import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/bookmarks_repository.dart';

class AddToFavorites implements UseCase<void, String> {
  final BookmarksRepository _repository;
  AddToFavorites(this._repository);

  @override
  Future<Either<Failure, void>> call(String bookId) =>
      _repository.addToFavorites(bookId);
}
