import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class SignInWithGoogle implements UseCase<void, NoParams> {
  final AuthRepository _repository;
  SignInWithGoogle(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) =>
      _repository.signInWithGoogle();
}
