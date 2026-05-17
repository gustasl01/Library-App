import 'package:get_it/get_it.dart';
import '../mock/mock_auth_state.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/sign_in_with_email.dart';
import '../../features/auth/domain/usecases/sign_in_with_google.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/domain/usecases/sign_up_with_email.dart';
import '../../features/auth/domain/usecases/update_password.dart';
import '../../features/auth/domain/usecases/update_user_name.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/books/data/datasources/author_remote_datasource.dart';
import '../../features/books/data/datasources/book_remote_datasource.dart';
import '../../features/books/data/repositories/author_repository_impl.dart';
import '../../features/books/data/repositories/book_repository_impl.dart';
import '../../features/books/domain/repositories/author_repository.dart';
import '../../features/books/domain/repositories/book_repository.dart';
import '../../features/books/domain/usecases/get_books_by_tag.dart';
import '../../features/books/domain/usecases/get_continue_reading.dart';
import '../../features/books/domain/usecases/get_featured_books.dart';
import '../../features/books/domain/usecases/get_recommendations.dart';
import '../../features/books/domain/usecases/get_top_authors.dart';
import '../../features/books/domain/usecases/search_books.dart';
import '../../features/books/presentation/bloc/home/home_bloc.dart';
import '../../features/books/presentation/bloc/search/search_bloc.dart';
import '../../features/bookmarks/data/datasources/bookmarks_remote_datasource.dart';
import '../../features/bookmarks/data/repositories/bookmarks_repository_impl.dart';
import '../../features/bookmarks/domain/repositories/bookmarks_repository.dart';
import '../../features/bookmarks/domain/usecases/add_to_favorites.dart';
import '../../features/bookmarks/domain/usecases/get_favorites.dart';
import '../../features/bookmarks/domain/usecases/remove_from_favorites.dart';
import '../../features/bookmarks/presentation/bloc/bookmarks_bloc.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Auth datasource & repository
  sl.registerLazySingleton<AuthRemoteDatasource>(() => AuthMockDatasource());
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  // Auth usecases
  sl.registerLazySingleton(() => SignInWithEmail(sl()));
  sl.registerLazySingleton(() => SignUpWithEmail(sl()));
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => UpdatePassword(sl()));
  sl.registerLazySingleton(() => UpdateUserName(sl()));

  // Auth bloc (singleton so router can listen to it)
  sl.registerLazySingleton(
    () => AuthBloc(
      signInWithEmail: sl(),
      signUpWithEmail: sl(),
      signInWithGoogle: sl(),
      signOut: sl(),
    ),
  );

  // Books datasource & repository
  sl.registerLazySingleton<BookRemoteDatasource>(() => BookMockDatasource());
  sl.registerLazySingleton<BookRepository>(
    () => BookRepositoryImpl(sl(), () => MockAuthState.instance.currentUser?.id),
  );

  // Author datasource & repository
  sl.registerLazySingleton<AuthorRemoteDatasource>(() => AuthorMockDatasource());
  sl.registerLazySingleton<AuthorRepository>(
    () => AuthorRepositoryImpl(sl()),
  );

  // Books usecases
  sl.registerLazySingleton(() => GetFeaturedBooks(sl()));
  sl.registerLazySingleton(() => GetContinueReading(sl()));
  sl.registerLazySingleton(() => GetRecommendations(sl()));
  sl.registerLazySingleton(() => SearchBooks(sl()));
  sl.registerLazySingleton(() => GetTopAuthors(sl()));
  sl.registerLazySingleton(() => GetBooksByTag(sl()));

  // Books blocs (factory = new instance per page)
  sl.registerFactory(
    () => HomeBloc(getFeaturedBooks: sl(), getContinueReading: sl()),
  );
  sl.registerFactory(
    () => SearchBloc(
      searchBooks: sl(),
      getRecommendations: sl(),
      getTopAuthors: sl(),
      getBooksByTag: sl(),
    ),
  );

  // Bookmarks datasource & repository
  sl.registerLazySingleton<BookmarksRemoteDatasource>(() => BookmarksMockDatasource());
  sl.registerLazySingleton<BookmarksRepository>(
    () => BookmarksRepositoryImpl(sl(), () => MockAuthState.instance.currentUser?.id),
  );

  // Bookmarks usecases
  sl.registerLazySingleton(() => GetFavorites(sl()));
  sl.registerLazySingleton(() => AddToFavorites(sl()));
  sl.registerLazySingleton(() => RemoveFromFavorites(sl()));

  // Bookmarks bloc
  sl.registerFactory(
    () => BookmarksBloc(
      getFavorites: sl(),
      addToFavorites: sl(),
      removeFromFavorites: sl(),
    ),
  );

  // Profile bloc
  sl.registerFactory(
    () => ProfileBloc(
      authRepository: sl(),
      signOut: sl(),
      updatePassword: sl(),
      updateUserName: sl(),
    ),
  );
}
