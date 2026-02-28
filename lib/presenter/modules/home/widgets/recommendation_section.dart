import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../domain/entities/book_entity.dart';

class RecommendationSection extends StatelessWidget {
  const RecommendationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<BookEntity> recommendations = [
      BookEntity(
        title: 'Shine',
        author: 'JESSICA JUNG',
        coverColor: '0xFFFDD835',
      ),
      BookEntity(
        title: 'Shatter Me',
        author: 'Author Name',
        coverColor: '0xFF3B82F6',
      ),
      BookEntity(
        title: 'Psychology of Money',
        author: 'MORGAN HOUSEL',
        coverColor: '0xFFE5E7EB',
      ),
    ];

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
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                return _BookCard(book: recommendations[index]);
              },
            ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              height: 160,
              decoration: BoxDecoration(
                color: Color(int.parse(book.coverColor)),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '📚',
                  style: TextStyle(fontSize: 50),
                ),
              ),
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
