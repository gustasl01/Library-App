import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../domain/entities/book_entity.dart';

class TopBookSection extends StatelessWidget {
  const TopBookSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<BookEntity> books = [
      BookEntity(
        id: 'book-5',
        title: 'Si Anak Badai',
        author: 'By Terellye',
        coverColor: '0xFF1E3A8A',
      ),
      BookEntity(
        id: 'book-6',
        title: 'The Phycology Of Money',
        author: 'By Howard',
        coverColor: '0xFFE5E7EB',
      ),
      BookEntity(
        id: 'book-7',
        title: 'Shine',
        author: 'By Jessica',
        coverColor: '0xFFFDD835',
      ),
      BookEntity(
        id: 'book-8',
        title: 'Get Well Soon Heart',
        author: 'By Deedain',
        coverColor: '0xFFFEE2E2',
      ),
      BookEntity(
        id: 'book-9',
        title: 'Coraline',
        author: 'Neil Gaiman',
        coverColor: '0xFF6B21A8',
      ),
      BookEntity(
        id: 'book-10',
        title: 'Summer To Remember',
        author: 'By suzatthefirst',
        coverColor: '0xFF3B82F6',
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Book',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.65,
            ),
            itemCount: books.length,
            itemBuilder: (context, index) {
              return _TopBookCard(book: books[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _TopBookCard extends StatelessWidget {
  final BookEntity book;

  const _TopBookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Modular.to.pushNamed('/book-detail', arguments: book);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
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
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          Text(
            book.author,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
