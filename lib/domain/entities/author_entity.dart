class AuthorEntity {
  final String name;
  final String imageUrl;

  AuthorEntity({
    required this.name,
    required this.imageUrl,
  });
}

class TagEntity {
  final String name;
  final bool isHighlighted;

  TagEntity({
    required this.name,
    this.isHighlighted = false,
  });
}
