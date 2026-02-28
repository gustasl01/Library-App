class BookEntity {
  final String title;
  final String author;
  final String coverColor;
  final String? coverImage;
  final int? currentChapter;
  final int? totalChapters;
  final double? progress;

  BookEntity({
    required this.title,
    required this.author,
    required this.coverColor,
    this.coverImage,
    this.currentChapter,
    this.totalChapters,
    this.progress,
  });
}
