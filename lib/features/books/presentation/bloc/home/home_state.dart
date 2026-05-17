import '../../../domain/entities/book_entity.dart';

sealed class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<BookEntity> continueReading;
  final List<BookEntity> recommendations;
  HomeSuccess({required this.continueReading, required this.recommendations});
}

class HomeError extends HomeState {
  final String message;
  HomeError({required this.message});
}
