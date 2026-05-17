sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String userId;
  final String? displayName;
  final String? email;
  AuthAuthenticated({required this.userId, this.displayName, this.email});
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}

class AuthRegistrationSuccess extends AuthState {}
