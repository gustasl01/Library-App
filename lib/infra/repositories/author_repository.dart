import '../../domain/entities/author_entity.dart';
import '../../domain/usecases/authors/get_authors_usecase.dart';
import '../../external/datasources/author_datasource_impl.dart';

class AuthorRepository implements GetAuthorsUsecase {
  final AuthorDatasourceImpl _datasource = AuthorDatasourceImpl();

  @override
  Future<List<AuthorEntity>> call() async {
    return await _datasource.getAuthors();
  }

  Future<AuthorEntity> getAuthorById(String id) async {
    return await _datasource.getAuthorById(id);
  }

  Future<List<AuthorEntity>> getTopAuthors({int limit = 10}) async {
    return await _datasource.getTopAuthors(limit: limit);
  }

  Future<List<Map<String, dynamic>>> getAuthorBooks(String authorId) async {
    return await _datasource.getAuthorBooks(authorId);
  }

  Future<List<AuthorEntity>> search(String query) async {
    return await _datasource.searchAuthors(query);
  }
}
