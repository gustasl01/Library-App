import '../../domain/entities/book_entity.dart';
import '../../domain/usecases/books/get_books_usecase.dart';

class BookRepository implements GetBooksUsecase {
  @override
  Future<List<BookEntity>> call() async {
    return [];
  }
}
