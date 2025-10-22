class Author {
  final String name;
  final String imageUrl;

  Author({
    required this.name,
    required this.imageUrl,
  });
}

class Tag {
  final String name;
  final bool isHighlighted;

  Tag({
    required this.name,
    this.isHighlighted = false,
  });
}
