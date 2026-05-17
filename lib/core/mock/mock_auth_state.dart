import '../../features/auth/domain/entities/user_entity.dart';

class MockAuthState {
  MockAuthState._();
  static final MockAuthState instance = MockAuthState._();

  UserEntity? _currentUser;
  UserEntity? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  void signIn(UserEntity user) => _currentUser = user;
  void signOut() => _currentUser = null;
  void updateName(String name) {
    if (_currentUser == null) return;
    _currentUser = UserEntity(id: _currentUser!.id, name: name, email: _currentUser!.email);
  }
}
