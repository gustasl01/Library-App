import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class UpdatePassword implements UseCase<void, String> {
  final AuthRepository _repository;
  UpdatePassword(this._repository);

  @override
  Future<Either<Failure, void>> call(String newPassword) =>
      _repository.updatePassword(newPassword);
}
