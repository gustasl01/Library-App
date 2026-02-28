import '../../domain/entities/book_entity.dart';

abstract class BookDatasource {
  Future<List<BookEntity>> getBooks();
  Future<BookEntity> getBookById(String id);
}
