import '../../../../core/errors/exceptions.dart';
import '../../../../core/mock/mock_auth_state.dart';
import '../../../auth/domain/entities/user_entity.dart';

abstract class AuthRemoteDatasource {
  Future<UserEntity> signInWithEmail({required String email, required String password});
  Future<UserEntity> signUpWithEmail({required String name, required String email, required String password});
  Future<void> signInWithGoogle();
  Future<void> signOut();
  Future<void> updatePassword(String newPassword);
  Future<void> updateUserName(String name);
  UserEntity? get currentUser;
}

class AuthMockDatasource implements AuthRemoteDatasource {
  @override
  UserEntity? get currentUser => MockAuthState.instance.currentUser;

  @override
  Future<UserEntity> signInWithEmail({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (password.length < 6) throw const AppAuthException('Senha incorreta.');
    final user = UserEntity(
      id: 'mock-user-1',
      name: email.split('@').first,
      email: email,
    );
    MockAuthState.instance.signIn(user);
    return user;
  }

  @override
  Future<UserEntity> signUpWithEmail({required String name, required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (password.length < 6) throw const AppAuthException('A senha deve ter pelo menos 6 caracteres.');
    return UserEntity(id: 'mock-user-1', name: name, email: email);
  }

  @override
  Future<void> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 600));
    const user = UserEntity(id: 'mock-user-1', name: 'Usuário Google', email: 'usuario@gmail.com');
    MockAuthState.instance.signIn(user);
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
    MockAuthState.instance.signOut();
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (newPassword.length < 6) throw const AppAuthException('A senha deve ter pelo menos 6 caracteres.');
  }

  @override
  Future<void> updateUserName(String name) async {
    await Future.delayed(const Duration(milliseconds: 400));
    MockAuthState.instance.updateName(name);
  }
}
