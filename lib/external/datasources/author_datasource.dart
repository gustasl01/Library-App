import '../../domain/entities/author_entity.dart';

abstract class AuthorDatasource {
  Future<List<AuthorEntity>> getAuthors();
  Future<AuthorEntity> getAuthorById(String id);
}
