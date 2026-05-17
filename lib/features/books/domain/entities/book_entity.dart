class BookEntity {
  final String id;
  final String title;
  final String author;
  final String coverColor;
  final String? coverImage;
  final int? currentChapter;
  final int? totalChapters;
  final double? progress;
  final double? rating;
  final String? description;

  const BookEntity({
    required this.id,
    required this.title,
    required this.author,
    required this.coverColor,
    this.coverImage,
    this.currentChapter,
    this.totalChapters,
    this.progress,
    this.rating,
    this.description,
  });
}
