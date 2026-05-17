import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInWithEmailParams {
  final String email;
  final String password;
  const SignInWithEmailParams({required this.email, required this.password});
}

class SignInWithEmail implements UseCase<UserEntity, SignInWithEmailParams> {
  final AuthRepository _repository;
  SignInWithEmail(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignInWithEmailParams params) =>
      _repository.signInWithEmail(email: params.email, password: params.password);
}
