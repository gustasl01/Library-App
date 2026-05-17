class TagEntity {
  final String id;
  final String name;
  final bool isHighlighted;

  const TagEntity({
    required this.id,
    required this.name,
    this.isHighlighted = false,
  });
}
