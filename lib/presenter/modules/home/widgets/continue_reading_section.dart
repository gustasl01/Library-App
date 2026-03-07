import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../domain/entities/book_entity.dart';
import '../../../../infra/repositories/book_repository.dart';
import '../../../../shared/components/book_cover/book_cover_widget.dart';
import '../../../../shared/components/shimmer/shimmer_loading.dart';

class ContinueReadingSection extends StatefulWidget {
  const ContinueReadingSection({super.key});

  @override
  State<ContinueReadingSection> createState() => ContinueReadingSectionState();
}

class ContinueReadingSectionState extends State<ContinueReadingSection> {
  final BookRepository _bookRepository = BookRepository();
  late Future<BookEntity?> _bookFuture;

  @override
  void initState() {
    super.initState();
    _bookFuture = _loadContinueReadingBook();
  }

  void refresh() {
    setState(() {
      _bookFuture = _loadContinueReadingBook();
    });
  }

  Future<BookEntity?> _loadContinueReadingBook() async {
    try {
      final reading = await _bookRepository.getContinueReading()
          .timeout(const Duration(seconds: 5));
      if (reading.isNotEmpty) return reading.first;
    } catch (_) {
      // Usuario pode nao estar autenticado.
    }

    try {
      final featured = await _bookRepository.getFeatured()
          .timeout(const Duration(seconds: 5));
      if (featured.isNotEmpty) return featured.first;
    } catch (_) {
      // Fallback abaixo.
    }

    return BookEntity(
      id: 'book-1',
      title: 'The Weight of Things',
      author: 'Terellye',
      coverColor: '0xFF1E3A8A',
      currentChapter: 4,
      totalChapters: 8,
      progress: 0.5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Continue Reading',
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
          SizedBox(height: 20),
          FutureBuilder<BookEntity?>(
            future: _bookFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ContinueReadingShimmer();
              }

              final book = snapshot.data;
              if (book == null) {
                return const SizedBox.shrink();
              }

              return _ContinueReadingCard(book: book);
            },
          ),
        ],
      ),
    );
  }
}

class _ContinueReadingCard extends StatelessWidget {
  final BookEntity book;

  const _ContinueReadingCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Modular.to.pushNamed('/book-detail', arguments: book);
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              BookCoverWidget(
                coverImage: book.coverImage,
                coverColor: book.coverColor,
                width: 80,
                height: 120,
                borderRadius: 8,
                fallbackEmoji: '📖',
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      book.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  SizedBox(height: 4),
                  Text(
                    'Chapter ${book.currentChapter ?? 1} of ${book.totalChapters ?? '-'}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: book.progress ?? 0.0,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFFFDD835),
                          ),
                          minHeight: 6,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${((book.progress ?? 0.0) * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFDD835),
                        foregroundColor: Colors.black87,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      )
    );
  }
}
