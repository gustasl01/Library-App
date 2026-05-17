import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/sign_in_with_email.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up_with_email.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithEmail _signInWithEmail;
  final SignUpWithEmail _signUpWithEmail;
  final SignInWithGoogle _signInWithGoogle;
  final SignOut _signOut;

  AuthBloc({
    required SignInWithEmail signInWithEmail,
    required SignUpWithEmail signUpWithEmail,
    required SignInWithGoogle signInWithGoogle,
    required SignOut signOut,
  })  : _signInWithEmail = signInWithEmail,
        _signUpWithEmail = signUpWithEmail,
        _signInWithGoogle = signInWithGoogle,
        _signOut = signOut,
        super(AuthInitial()) {
    on<AuthSignInWithEmailRequested>(_onSignInWithEmail);
    on<AuthSignUpWithEmailRequested>(_onSignUpWithEmail);
    on<AuthSignInWithGoogleRequested>(_onSignInWithGoogle);
    on<AuthSignOutRequested>(_onSignOut);
  }

  Future<void> _onSignInWithEmail(
    AuthSignInWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _signInWithEmail(
      SignInWithEmailParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(userId: user.id, displayName: user.name, email: user.email)),
    );
  }

  Future<void> _onSignUpWithEmail(
    AuthSignUpWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _signUpWithEmail(
      SignUpWithEmailParams(name: event.name, email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(AuthRegistrationSuccess()),
    );
  }

  Future<void> _onSignInWithGoogle(
    AuthSignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _signInWithGoogle(NoParams());
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(AuthAuthenticated(userId: 'mock-user-1', displayName: 'Usuário Google', email: 'usuario@gmail.com')),
    );
  }

  Future<void> _onSignOut(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _signOut(NoParams());
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }
}
