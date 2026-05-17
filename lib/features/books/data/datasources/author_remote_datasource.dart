import '../../../../core/mock/mock_database.dart';
import '../models/author_model.dart';

abstract class AuthorRemoteDatasource {
  Future<List<AuthorModel>> getTopAuthors({int limit = 5});
  Future<List<AuthorModel>> searchAuthors(String query);
}

class AuthorMockDatasource implements AuthorRemoteDatasource {
  final _db = MockDatabase.instance;

  @override
  Future<List<AuthorModel>> getTopAuthors({int limit = 5}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _db.topAuthors.take(limit).toList();
  }

  @override
  Future<List<AuthorModel>> searchAuthors(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _db.searchAuthors(query);
  }
}
