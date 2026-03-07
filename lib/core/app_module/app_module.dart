import 'package:flutter_modular/flutter_modular.dart';
import '../../domain/entities/book_entity.dart';
import '../../presenter/modules/auth/auth_gate_page.dart';
import '../../presenter/modules/auth/login_page.dart';
import '../../presenter/modules/auth/register_page.dart';
import '../../presenter/modules/book_detail/book_detail_page.dart';
import '../../presenter/modules/bookmarks/bookmarks_page.dart';
import '../../presenter/modules/home/home_page.dart';
import '../../presenter/modules/profile/profile_page.dart';
import '../../presenter/modules/search/search_page.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {}

  @override
  void routes(RouteManager r) {
    // ✅ AuthGatePage como rota inicial - controla fluxo de autenticação
    r.child(
      '/',
      child: (context) => const AuthGatePage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      '/login',
      child: (context) => const LoginPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      '/register',
      child: (context) => const RegisterPage(),
      transition: TransitionType.rightToLeft,
    );
    r.child(
      '/home',
      child: (context) => const HomePage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      '/search',
      child: (context) => const SearchPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      '/bookmarks',
      child: (context) => const BookmarksPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      '/profile',
      child: (context) => const ProfilePage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      '/book-detail',
      child: (context) => BookDetailPage(
        book: r.args.data as BookEntity,
      ),
      transition: TransitionType.rightToLeft,
    );
  }
}

