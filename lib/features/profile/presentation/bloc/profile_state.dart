sealed class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String name;
  final String email;
  ProfileLoaded({required this.name, required this.email});
}

class ProfileSignedOut extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;
  ProfileError({required this.message});
}

class ProfilePasswordUpdated extends ProfileState {}

class ProfileNameUpdated extends ProfileState {
  final String name;
  ProfileNameUpdated({required this.name});
}
