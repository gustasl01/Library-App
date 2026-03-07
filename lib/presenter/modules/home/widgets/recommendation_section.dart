import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../domain/entities/book_entity.dart';
import '../../../../infra/repositories/book_repository.dart';
import '../../../../shared/components/book_cover/book_cover_widget.dart';

class RecommendationSection extends StatefulWidget {
  const RecommendationSection({super.key});

  @override
  State<RecommendationSection> createState() => _RecommendationSectionState();
}

class _RecommendationSectionState extends State<RecommendationSection> {
  final BookRepository _bookRepository = BookRepository();
  late Future<List<BookEntity>> _recommendationsFuture;

  @override
  void initState() {
    super.initState();
    _recommendationsFuture = _loadRecommendations();
  }

  Future<List<BookEntity>> _loadRecommendations() async {
    try {
      final books = await _bookRepository.getFeatured()
          .timeout(const Duration(seconds: 5));
      return books.take(6).toList();
    } catch (_) {
      return [
        BookEntity(
          id: 'book-2',
          title: 'Shine',
          author: 'JESSICA JUNG',
          coverColor: '0xFFFDD835',
        ),
        BookEntity(
          id: 'book-3',
          title: 'Shatter Me',
          author: 'Author Name',
          coverColor: '0xFF3B82F6',
        ),
        BookEntity(
          id: 'book-4',
          title: 'Psychology of Money',
          author: 'MORGAN HOUSEL',
          coverColor: '0xFFE5E7EB',
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recommendation',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                'See More',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          FutureBuilder<List<BookEntity>>(
            future: _recommendationsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final recommendations = snapshot.data ?? [];
              if (recommendations.isEmpty) {
                return const SizedBox(
                  height: 200,
                  child: Center(child: Text('Nenhuma recomendacao encontrada')),
                );
              }

              return SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recommendations.length,
                  itemBuilder: (context, index) {
                    return _BookCard(book: recommendations[index]);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  final BookEntity book;

  const _BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Modular.to.pushNamed('/book-detail', arguments: book);
      },
      child: Container(
        width: 120,
        margin: EdgeInsets.only(right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookCoverWidget(
              coverImage: book.coverImage,
              coverColor: book.coverColor,
              width: 120,
              height: 160,
              borderRadius: 12,
              fallbackEmoji: '📚',
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              book.title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2),
            Text(
              book.author,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
