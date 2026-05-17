import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/author_entity.dart';
import '../../domain/repositories/author_repository.dart';
import '../datasources/author_remote_datasource.dart';

class AuthorRepositoryImpl implements AuthorRepository {
  final AuthorRemoteDatasource _datasource;
  AuthorRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<AuthorEntity>>> getTopAuthors({int limit = 5}) async {
    try {
      final authors = await _datasource.getTopAuthors(limit: limit);
      return Right(authors);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<AuthorEntity>>> searchAuthors(String query) async {
    try {
      final authors = await _datasource.searchAuthors(query);
      return Right(authors);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
