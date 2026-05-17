import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpWithEmailParams {
  final String name;
  final String email;
  final String password;
  const SignUpWithEmailParams({
    required this.name,
    required this.email,
    required this.password,
  });
}

class SignUpWithEmail implements UseCase<UserEntity, SignUpWithEmailParams> {
  final AuthRepository _repository;
  SignUpWithEmail(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignUpWithEmailParams params) =>
      _repository.signUpWithEmail(
        name: params.name,
        email: params.email,
        password: params.password,
      );
}
