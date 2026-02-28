import '../../entities/book_entity.dart';

abstract class GetBooksUsecase {
  Future<List<BookEntity>> call();
}
