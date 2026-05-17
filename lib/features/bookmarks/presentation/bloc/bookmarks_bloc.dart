import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/add_to_favorites.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/remove_from_favorites.dart';
import 'bookmarks_event.dart';
import 'bookmarks_state.dart';

class BookmarksBloc extends Bloc<BookmarksEvent, BookmarksState> {
  final GetFavorites _getFavorites;
  final AddToFavorites _addToFavorites;
  final RemoveFromFavorites _removeFromFavorites;

  BookmarksBloc({
    required GetFavorites getFavorites,
    required AddToFavorites addToFavorites,
    required RemoveFromFavorites removeFromFavorites,
  })  : _getFavorites = getFavorites,
        _addToFavorites = addToFavorites,
        _removeFromFavorites = removeFromFavorites,
        super(BookmarksInitial()) {
    on<BookmarksFetchRequested>(_onFetch);
    on<BookmarkToggled>(_onToggle);
  }

  Future<void> _onFetch(BookmarksFetchRequested event, Emitter<BookmarksState> emit) async {
    emit(BookmarksLoading());
    final result = await _getFavorites(NoParams());
    result.fold(
      (failure) => emit(BookmarksError(message: failure.message)),
      (books) => emit(BookmarksSuccess(books: books)),
    );
  }

  Future<void> _onToggle(BookmarkToggled event, Emitter<BookmarksState> emit) async {
    if (event.isFavorite) {
      await _removeFromFavorites(event.bookId);
    } else {
      await _addToFavorites(event.bookId);
    }
    add(BookmarksFetchRequested());
  }
}
