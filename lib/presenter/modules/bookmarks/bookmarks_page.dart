import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../core/config/supabase_config.dart';
import '../../../domain/entities/book_entity.dart';
import '../../../infra/repositories/book_repository.dart';
import '../../../shared/components/book_cover/book_cover_widget.dart';
import '../../../shared/components/bottom_navigation/bottom_navigation_widget.dart';
import '../../../shared/components/shimmer/shimmer_loading.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  final BookRepository _bookRepository = BookRepository();
  late Future<List<BookEntity>> _favoriteBooksFuture;

  @override
  void initState() {
    super.initState();
    _favoriteBooksFuture = _loadBooks();
  }

  Future<List<BookEntity>> _loadBooks() async {
    try {
      if (SupabaseConfig.isAuthenticated) {
        final favorites = await _bookRepository.getFavorites();
        if (favorites.isNotEmpty) return favorites;
      }

      final featured = await _bookRepository.getFeatured();
      return featured.take(8).toList();
    } catch (_) {
      return [
        BookEntity(
          id: 'book-1',
          title: 'The Weight of Things',
          author: 'Terellye',
          coverColor: '0xFF1E3A8A',
          currentChapter: 4,
          totalChapters: 8,
          progress: 0.5,
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BookEntity>>(
      future: _favoriteBooksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            body: const SafeArea(child: BookmarksShimmer()),
            bottomNavigationBar: BottomNavigationWidget(currentIndex: 2),
          );
        }

        final favoriteBooks = snapshot.data ?? [];

        return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF5B4B8A),
                      Color(0xFF6B5B9A),
                    ],
                  ),
                ),
                padding: EdgeInsets.fromLTRB(20, 60, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'My Favorites',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '📚',
                          style: TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${favoriteBooks.length} books saved',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            backgroundColor: Color(0xFF5B4B8A),
          ),
          SliverPadding(
            padding: EdgeInsets.all(20),
            sliver: favoriteBooks.isEmpty
                ? SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '🔖',
                            style: TextStyle(fontSize: 80),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'No favorites yet',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Start adding books to your favorites',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return _FavoriteBookCard(book: favoriteBooks[index]);
                      },
                      childCount: favoriteBooks.length,
                    ),
                  ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: 2,
      ),
    );
      },
    );
  }
}

class _FavoriteBookCard extends StatelessWidget {
  final BookEntity book;

  const _FavoriteBookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Modular.to.pushNamed('/book-detail', arguments: book);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BookCoverWidget(
                coverImage: book.coverImage,
                coverColor: book.coverColor,
                width: 70,
                height: 100,
                borderRadius: 8,
                fallbackEmoji: '📖',
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
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
                      'By ${book.author}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    if (book.progress != null) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: book.progress,
                                    backgroundColor: Colors.grey[200],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFFFDD835),
                                    ),
                                    minHeight: 6,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '${(book.progress! * 100).toInt()}%',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          if (book.currentChapter != null && book.totalChapters != null)
                            Text(
                              'Chapter ${book.currentChapter} of ${book.totalChapters}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              Icons.star,
                              size: 14,
                              color: Color(0xFFFDD835),
                            );
                          }),
                          SizedBox(width: 6),
                          Text(
                            '9.5',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: IconButton(
                  icon: Icon(
                    Icons.bookmark,
                    color: Color(0xFFFDD835),
                    size: 28,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
