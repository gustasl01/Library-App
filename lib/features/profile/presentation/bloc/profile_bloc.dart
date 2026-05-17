import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/domain/usecases/sign_out.dart';
import '../../../auth/domain/usecases/update_password.dart';
import '../../../auth/domain/usecases/update_user_name.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository _authRepository;
  final SignOut _signOut;
  final UpdatePassword _updatePassword;
  final UpdateUserName _updateUserName;

  ProfileBloc({
    required AuthRepository authRepository,
    required SignOut signOut,
    required UpdatePassword updatePassword,
    required UpdateUserName updateUserName,
  })  : _authRepository = authRepository,
        _signOut = signOut,
        _updatePassword = updatePassword,
        _updateUserName = updateUserName,
        super(ProfileInitial()) {
    on<ProfileFetchRequested>(_onFetch);
    on<ProfileSignOutRequested>(_onSignOut);
    on<ProfileUpdatePasswordRequested>(_onUpdatePassword);
    on<ProfileUpdateNameRequested>(_onUpdateName);
  }

  void _onFetch(ProfileFetchRequested event, Emitter<ProfileState> emit) {
    final user = _authRepository.currentUser;
    if (user == null) {
      emit(ProfileSignedOut());
      return;
    }
    emit(ProfileLoaded(name: user.name ?? 'User', email: user.email ?? ''));
  }

  Future<void> _onSignOut(ProfileSignOutRequested event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final result = await _signOut(NoParams());
    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (_) => emit(ProfileSignedOut()),
    );
  }

  Future<void> _onUpdatePassword(ProfileUpdatePasswordRequested event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final result = await _updatePassword(event.newPassword);
    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (_) => emit(ProfilePasswordUpdated()),
    );
  }

  Future<void> _onUpdateName(ProfileUpdateNameRequested event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final result = await _updateUserName(event.name);
    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (_) => emit(ProfileNameUpdated(name: event.name)),
    );
  }
}
