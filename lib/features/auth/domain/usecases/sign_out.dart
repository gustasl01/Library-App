import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class SignOut implements UseCase<void, NoParams> {
  final AuthRepository _repository;
  SignOut(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) =>
      _repository.signOut();
}
