import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/get_continue_reading.dart';
import '../../../domain/usecases/get_featured_books.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetFeaturedBooks _getFeaturedBooks;
  final GetContinueReading _getContinueReading;

  HomeBloc({
    required GetFeaturedBooks getFeaturedBooks,
    required GetContinueReading getContinueReading,
  })  : _getFeaturedBooks = getFeaturedBooks,
        _getContinueReading = getContinueReading,
        super(HomeInitial()) {
    on<HomeFetchRequested>(_onFetch);
    on<HomeRefreshRequested>(_onRefresh);
  }

  Future<void> _onFetch(HomeFetchRequested event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    await _loadData(emit);
  }

  Future<void> _onRefresh(HomeRefreshRequested event, Emitter<HomeState> emit) async {
    await _loadData(emit);
  }

  Future<void> _loadData(Emitter<HomeState> emit) async {
    final results = await Future.wait([
      _getFeaturedBooks(NoParams()),
      _getContinueReading(NoParams()),
    ]);

    final featuredResult = results[0];
    final continueResult = results[1];

    final recommendations = featuredResult.fold((_) => <dynamic>[], (books) => books);
    final continueReading = continueResult.fold((_) => <dynamic>[], (books) => books);

    emit(HomeSuccess(
      continueReading: List.from(continueReading),
      recommendations: List.from(recommendations),
    ));
  }
}
