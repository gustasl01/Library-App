sealed class SearchEvent {}

class SearchFetchInitialRequested extends SearchEvent {}

class SearchQueryChanged extends SearchEvent {
  final String query;
  SearchQueryChanged(this.query);
}

class SearchCleared extends SearchEvent {}

class SearchTagSelected extends SearchEvent {
  final String tag;
  SearchTagSelected(this.tag);
}
