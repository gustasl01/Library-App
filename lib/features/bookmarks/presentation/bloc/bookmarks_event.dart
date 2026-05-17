sealed class BookmarksEvent {}

class BookmarksFetchRequested extends BookmarksEvent {}

class BookmarkToggled extends BookmarksEvent {
  final String bookId;
  final bool isFavorite;
  BookmarkToggled({required this.bookId, required this.isFavorite});
}
