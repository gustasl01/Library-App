sealed class AuthEvent {}

class AuthSignInWithEmailRequested extends AuthEvent {
  final String email;
  final String password;
  AuthSignInWithEmailRequested({required this.email, required this.password});
}

class AuthSignUpWithEmailRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  AuthSignUpWithEmailRequested({required this.name, required this.email, required this.password});
}

class AuthSignInWithGoogleRequested extends AuthEvent {}

class AuthSignOutRequested extends AuthEvent {}
