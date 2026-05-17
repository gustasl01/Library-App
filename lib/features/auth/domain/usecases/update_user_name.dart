import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class UpdateUserName implements UseCase<void, String> {
  final AuthRepository _repository;
  UpdateUserName(this._repository);

  @override
  Future<Either<Failure, void>> call(String name) =>
      _repository.updateUserName(name);
}
