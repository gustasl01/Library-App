import '../../../books/domain/entities/book_entity.dart';

sealed class BookmarksState {}

class BookmarksInitial extends BookmarksState {}

class BookmarksLoading extends BookmarksState {}

class BookmarksSuccess extends BookmarksState {
  final List<BookEntity> books;
  BookmarksSuccess({required this.books});
}

class BookmarksError extends BookmarksState {
  final String message;
  BookmarksError({required this.message});
}
