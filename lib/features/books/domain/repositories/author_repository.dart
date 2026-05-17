import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/author_entity.dart';

abstract class AuthorRepository {
  Future<Either<Failure, List<AuthorEntity>>> getTopAuthors({int limit = 5});
  Future<Either<Failure, List<AuthorEntity>>> searchAuthors(String query);
}
