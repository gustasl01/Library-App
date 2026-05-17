import '../../domain/entities/book_entity.dart';

class BookModel extends BookEntity {
  const BookModel({
    required super.id,
    required super.title,
    required super.author,
    required super.coverColor,
    super.coverImage,
    super.currentChapter,
    super.totalChapters,
    super.progress,
    super.rating,
    super.description,
  });

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      author: map['author_name'] as String? ?? '',
      coverColor: map['cover_color'] as String? ?? '#2C3E50',
      coverImage: map['cover_image'] as String?,
      currentChapter: map['current_chapter'] as int?,
      totalChapters: map['total_chapters'] as int?,
      progress: _toDouble(map['progress']),
      rating: _toDouble(map['rating']),
      description: map['description'] as String?,
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
