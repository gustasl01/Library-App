class Book {
  final String title;
  final String author;
  final String coverColor;
  final String? coverImage;
  final int? currentChapter;
  final int? totalChapters;
  final double? progress;

  Book({
    required this.title,
    required this.author,
    required this.coverColor,
    this.coverImage,
    this.currentChapter,
    this.totalChapters,
    this.progress,
  });
}
