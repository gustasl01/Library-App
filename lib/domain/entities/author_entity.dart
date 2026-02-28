class AuthorEntity {
  final String id;
  final String name;
  final String imageUrl;
  final String? bio;
  final int? totalBooks;

  AuthorEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.bio,
    this.totalBooks,
  });

  factory AuthorEntity.fromMap(Map<String, dynamic> map) {
    return AuthorEntity(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      imageUrl: map['image_url'] as String? ?? '',
      bio: map['bio'] as String?,
      totalBooks: map['total_books'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'bio': bio,
      'total_books': totalBooks,
    };
  }

  @override
  String toString() => 'AuthorEntity(id: $id, name: $name)';
}

class TagEntity {
  final String id;
  final String name;
  final bool isHighlighted;

  TagEntity({
    required this.id,
    required this.name,
    this.isHighlighted = false,
  });

  factory TagEntity.fromMap(Map<String, dynamic> map) {
    return TagEntity(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      isHighlighted: map['is_highlighted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'is_highlighted': isHighlighted,
    };
  }

  @override
  String toString() => 'TagEntity(id: $id, name: $name)';
}
