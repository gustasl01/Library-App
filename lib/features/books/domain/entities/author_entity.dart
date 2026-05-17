class AuthorEntity {
  final String id;
  final String name;
  final String? imageUrl;
  final String? bio;
  final int? totalBooks;

  const AuthorEntity({
    required this.id,
    required this.name,
    this.imageUrl,
    this.bio,
    this.totalBooks,
  });
}
