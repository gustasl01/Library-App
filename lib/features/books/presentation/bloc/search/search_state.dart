import '../../../domain/entities/author_entity.dart';
import '../../../domain/entities/book_entity.dart';
import '../../../domain/entities/tag_entity.dart';

sealed class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchBrowse extends SearchState {
  final List<BookEntity> topBooks;
  final List<AuthorEntity> topAuthors;
  final List<TagEntity> tags;
  SearchBrowse({required this.topBooks, required this.topAuthors, required this.tags});
}

class SearchResults extends SearchState {
  final List<BookEntity> books;
  final String query;
  SearchResults({required this.books, required this.query});
}

class SearchError extends SearchState {
  final String message;
  SearchError({required this.message});
}
