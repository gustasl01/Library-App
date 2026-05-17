import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'core/mock/mock_auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/books/domain/entities/book_entity.dart';
import 'features/books/presentation/pages/all_books_page.dart';
import 'features/books/presentation/pages/book_detail_page.dart';
import 'features/books/presentation/pages/home_page.dart';
import 'features/books/presentation/pages/search_page.dart';
import 'features/bookmarks/presentation/pages/bookmarks_page.dart';
import 'features/profile/presentation/pages/change_password_page.dart';
import 'features/profile/presentation/pages/language_page.dart';
import 'features/profile/presentation/pages/notifications_page.dart';
import 'features/profile/presentation/pages/personal_info_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/profile/presentation/pages/settings_page.dart';

class AuthGuard extends RouteGuard {
  AuthGuard() : super(redirectTo: '/login');

  @override
  FutureOr<bool> canActivate(String path, ModularRoute route) {
    return MockAuthState.instance.isAuthenticated;
  }
}

class AppModule extends Module {
  @override
  void routes(r) {
    r.child(
      '/login',
      child: (_) => const LoginPage(),
      transition: TransitionType.defaultTransition,
    );
    r.child(
      '/register',
      child: (_) => const RegisterPage(),
      transition: TransitionType.rightToLeft,
    );
    r.child(
      '/book-detail',
      child: (_) => BookDetailPage(book: Modular.args.data as BookEntity),
      guards: [AuthGuard()],
      transition: TransitionType.rightToLeft,
    );
    r.child(
      '/all-books',
      child: (_) => AllBooksPage(args: Modular.args.data as AllBooksArgs),
      guards: [AuthGuard()],
      transition: TransitionType.rightToLeft,
    );
    r.child(
      '/settings',
      child: (_) => const SettingsPage(),
      guards: [AuthGuard()],
      transition: TransitionType.rightToLeft,
    );
    r.child(
      '/personal-info',
      child: (_) => const PersonalInfoPage(),
      guards: [AuthGuard()],
      transition: TransitionType.rightToLeft,
    );
    r.child(
      '/change-password',
      child: (_) => const ChangePasswordPage(),
      guards: [AuthGuard()],
      transition: TransitionType.rightToLeft,
    );
    r.child(
      '/notifications',
      child: (_) => const NotificationsPage(),
      guards: [AuthGuard()],
      transition: TransitionType.rightToLeft,
    );
    r.child(
      '/language',
      child: (_) => const LanguagePage(),
      guards: [AuthGuard()],
      transition: TransitionType.rightToLeft,
    );
    r.child(
      '/home',
      child: (_) => const HomePage(),
      guards: [AuthGuard()],
      transition: TransitionType.defaultTransition,
    );
    r.child(
      '/search',
      child: (_) => const SearchPage(),
      guards: [AuthGuard()],
      transition: TransitionType.defaultTransition,
    );
    r.child(
      '/bookmarks',
      child: (_) => const BookmarksPage(),
      guards: [AuthGuard()],
      transition: TransitionType.defaultTransition,
    );
    r.child(
      '/profile',
      child: (_) => const ProfilePage(),
      guards: [AuthGuard()],
      transition: TransitionType.defaultTransition,
    );
    r.redirect('/', to: '/home');
  }
}
