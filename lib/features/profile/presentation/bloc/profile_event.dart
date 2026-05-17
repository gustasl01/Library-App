sealed class ProfileEvent {}

class ProfileFetchRequested extends ProfileEvent {}

class ProfileSignOutRequested extends ProfileEvent {}

class ProfileUpdatePasswordRequested extends ProfileEvent {
  final String newPassword;
  ProfileUpdatePasswordRequested({required this.newPassword});
}

class ProfileUpdateNameRequested extends ProfileEvent {
  final String name;
  ProfileUpdateNameRequested({required this.name});
}
