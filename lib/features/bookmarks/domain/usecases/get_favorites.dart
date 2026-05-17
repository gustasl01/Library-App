import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../books/domain/entities/book_entity.dart';
import '../repositories/bookmarks_repository.dart';

class GetFavorites implements UseCase<List<BookEntity>, NoParams> {
  final BookmarksRepository _repository;
  GetFavorites(this._repository);

  @override
  Future<Either<Failure, List<BookEntity>>> call(NoParams params) =>
      _repository.getFavorites();
}
