import '../../domain/entities/author_entity.dart';
import '../../domain/usecases/authors/get_authors_usecase.dart';

class AuthorRepository implements GetAuthorsUsecase {
  @override
  Future<List<AuthorEntity>> call() async {
    return [];
  }
}
