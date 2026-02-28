import '../../entities/author_entity.dart';

abstract class GetAuthorsUsecase {
  Future<List<AuthorEntity>> call();
}
