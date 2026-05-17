import '../../domain/entities/author_entity.dart';

class AuthorModel extends AuthorEntity {
  const AuthorModel({
    required super.id,
    required super.name,
    super.imageUrl,
    super.bio,
    super.totalBooks,
  });

  factory AuthorModel.fromMap(Map<String, dynamic> map) {
    return AuthorModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      imageUrl: map['image_url'] as String?,
      bio: map['bio'] as String?,
      totalBooks: map['total_books'] as int?,
    );
  }
}
