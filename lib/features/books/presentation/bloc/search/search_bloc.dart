import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/tag_entity.dart';
import '../../../domain/usecases/get_books_by_tag.dart';
import '../../../domain/usecases/get_recommendations.dart';
import '../../../domain/usecases/get_top_authors.dart';
import '../../../domain/usecases/search_books.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchBooks _searchBooks;
  final GetRecommendations _getRecommendations;
  final GetTopAuthors _getTopAuthors;
  final GetBooksByTag _getBooksByTag;

  static const _staticTags = [
    TagEntity(id: '2594092c-0d68-4a98-860b-ca9c1b47bad7', name: 'Adventure', isHighlighted: true),
    TagEntity(id: 'fff5f745-f4ce-4e16-a33d-2acc05b124cf', name: 'Romance', isHighlighted: true),
    TagEntity(id: '053a7def-b664-4fc5-98e1-477198e4c1b9', name: 'Fantasy', isHighlighted: false),
    TagEntity(id: '58ecbee3-e1cb-4038-9f9f-51c69c1506f3', name: 'Horror', isHighlighted: false),
    TagEntity(id: '545162fb-7c17-4a70-b5f5-c4a371096c32', name: 'Mystery', isHighlighted: false),
    TagEntity(id: 'cb347b7c-26dc-40c2-8509-50bcf78460dd', name: 'Thriller', isHighlighted: false),
    TagEntity(id: '321ccd5b-dd57-47f1-84ed-d2c2d1c534c3', name: 'Action', isHighlighted: false),
    TagEntity(id: '80155c4c-7fea-4c84-b432-f91442867353', name: 'Science Fiction', isHighlighted: false),
  ];

  SearchBloc({
    required SearchBooks searchBooks,
    required GetRecommendations getRecommendations,
    required GetTopAuthors getTopAuthors,
    required GetBooksByTag getBooksByTag,
  })  : _searchBooks = searchBooks,
        _getRecommendations = getRecommendations,
        _getTopAuthors = getTopAuthors,
        _getBooksByTag = getBooksByTag,
        super(SearchInitial()) {
    on<SearchFetchInitialRequested>(_onFetchInitial);
    on<SearchQueryChanged>(_onQueryChanged);
    on<SearchCleared>(_onCleared);
    on<SearchTagSelected>(_onTagSelected);
  }

  Future<void> _onFetchInitial(SearchFetchInitialRequested event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    final booksResult = await _getRecommendations(6);
    final authorsResult = await _getTopAuthors(5);

    emit(SearchBrowse(
      topBooks: booksResult.fold((_) => [], (b) => b),
      topAuthors: authorsResult.fold((_) => [], (a) => a),
      tags: _staticTags,
    ));
  }

  Future<void> _onQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) async {
    if (event.query.trim().isEmpty) {
      add(SearchFetchInitialRequested());
      return;
    }
    emit(SearchLoading());
    final result = await _searchBooks(event.query.trim());
    result.fold(
      (failure) => emit(SearchError(message: failure.message)),
      (books) => emit(SearchResults(books: books, query: event.query)),
    );
  }

  Future<void> _onCleared(SearchCleared event, Emitter<SearchState> emit) async {
    add(SearchFetchInitialRequested());
  }

  Future<void> _onTagSelected(SearchTagSelected event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    final result = await _getBooksByTag(event.tag);
    result.fold(
      (failure) => emit(SearchError(message: failure.message)),
      (books) => emit(SearchResults(books: books, query: event.tag)),
    );
  }
}
