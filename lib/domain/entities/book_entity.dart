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

  BookEntity({
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

  factory BookEntity.fromMap(Map<String, dynamic> map) {
    return BookEntity(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      author: map['author_name'] as String? ?? '',
      coverColor: map['cover_color'] as String? ?? '#3B82F6',
      coverImage: map['cover_image'] as String?,
      currentChapter: map['current_chapter'] as int?,
      totalChapters: map['total_chapters'] as int?,
      progress: (map['progress'] as num?)?.toDouble(),
      rating: (map['rating'] as num?)?.toDouble(),
      description: map['description'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author_name': author,
      'cover_color': coverColor,
      'cover_image': coverImage,
      'current_chapter': currentChapter,
      'total_chapters': totalChapters,
      'progress': progress,
      'rating': rating,
      'description': description,
    };
  }

  @override
  String toString() => 'BookEntity(id: $id, title: $title, author: $author)';
}
