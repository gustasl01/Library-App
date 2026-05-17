class UserEntity {
  final String id;
  final String? name;
  final String? email;

  const UserEntity({
    required this.id,
    this.name,
    this.email,
  });
}
