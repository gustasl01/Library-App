import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../widgets/common/bottom_navigation.dart';
import '../book_detail/book_detail_screen.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  int _currentIndex = 2; // Bookmarks is at index 2

  void _onNavigationTap(int index) {
    if (index == 0) {
      // Navigate back to home
      Navigator.pop(context);
    } else if (index == 1) {
      // Navigate to search
      Navigator.pop(context);
    } else if (index == 3) {
      // Navigate to profile - would need to implement navigation
      Navigator.pop(context);
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Book> favoriteBooks = [
      Book(
        title: 'The Weight of Things',
        author: 'Terellye',
        coverColor: '0xFF1E3A8A',
        currentChapter: 4,
        totalChapters: 8,
        progress: 0.5,
      ),
      Book(
        title: 'Shine',
        author: 'Jessica Jung',
        coverColor: '0xFFFDD835',
      ),
      Book(
        title: 'Shatter Me',
        author: 'Tahereh Mafi',
        coverColor: '0xFF3B82F6',
      ),
      Book(
        title: 'Psychology of Money',
        author: 'Morgan Housel',
        coverColor: '0xFFE5E7EB',
      ),
      Book(
        title: 'Si Anak Badai',
        author: 'Terellye',
        coverColor: '0xFF1E3A8A',
      ),
      Book(
        title: 'Get Well Soon Heart',
        author: 'Deedain',
        coverColor: '0xFFFEE2E2',
      ),
      Book(
        title: 'Coraline',
        author: 'Neil Gaiman',
        coverColor: '0xFF6B21A8',
      ),
      Book(
        title: 'Summer To Remember',
        author: 'suzatthefirst',
        coverColor: '0xFF3B82F6',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Header
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

          // Bookmarked Books List
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

          // Bottom spacing for navigation bar
          SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onNavigationTap,
      ),
    );
  }
}

class _FavoriteBookCard extends StatelessWidget {
  final Book book;

  const _FavoriteBookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailScreen(book: book),
          ),
        );
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
              // Book Cover
              Container(
                width: 70,
                height: 100,
                decoration: BoxDecoration(
                  color: Color(int.parse(book.coverColor)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '📖',
                    style: TextStyle(fontSize: 35),
                  ),
                ),
              ),
              SizedBox(width: 16),

              // Book Info
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
                  
                  // Progress bar if available
                  if (book.progress != null) ...[
                    Flexible(
                      child: Column(
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
                    ),
                  ] else ...[
                    // Rating for books without progress
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

            // Bookmark Icon
            Container(
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(
                  Icons.bookmark,
                  color: Color(0xFFFDD835),
                  size: 28,
                ),
                onPressed: () {
                  // Remove from favorites logic here
                },
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
