import 'package:flutter_modular/flutter_modular.dart';
import '../../presenter/modules/home/home_page.dart';
import '../../presenter/modules/search/search_page.dart';
import '../../presenter/modules/bookmarks/bookmarks_page.dart';
import '../../presenter/modules/profile/profile_page.dart';
import '../../presenter/modules/book_detail/book_detail_page.dart';
import '../../domain/entities/book_entity.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    // Aqui você pode adicionar suas injeções de dependência
    // Exemplo: i.addSingleton(() => MeuController());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const HomePage());
    r.child('/search', child: (context) => const SearchPage());
    r.child('/bookmarks', child: (context) => const BookmarksPage());
    r.child('/profile', child: (context) => const ProfilePage());
    r.child('/book-detail',
        child: (context) => BookDetailPage(
              book: r.args.data as BookEntity,
            ));
  }
}

