import 'package:flutter/material.dart';
import '../../domain/entities/book_entity.dart';
import '../../infra/repositories/book_repository.dart';

/// Exemplo de widget que busca dados do Supabase
class ExampleBooksWidget extends StatefulWidget {
  const ExampleBooksWidget({super.key});

  @override
  State<ExampleBooksWidget> createState() => _ExampleBooksWidgetState();
}

class _ExampleBooksWidgetState extends State<ExampleBooksWidget> {
  final BookRepository _bookRepository = BookRepository();
  late Future<List<BookEntity>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = _bookRepository.getFeatured();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BookEntity>>(
      future: _booksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text('Erro ao carregar livros: ${snapshot.error}'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _booksFuture = _bookRepository.getFeatured();
                    });
                  },
                  child: Text('Tentar Novamente'),
                ),
              ],
            ),
          );
        }

        final books = snapshot.data ?? [];

        if (books.isEmpty) {
          return Center(child: Text('Nenhum livro encontrado'));
        }

        return ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return BookTile(book: book);
          },
        );
      },
    );
  }
}

class BookTile extends StatelessWidget {
  final BookEntity book;

  const BookTile({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 80,
          decoration: BoxDecoration(
            color: Color(int.parse(book.coverColor.replaceFirst('#', '0xFF'))),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text('📖', style: TextStyle(fontSize: 24)),
          ),
        ),
        title: Text(book.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('By ${book.author}'),
            if (book.rating != null)
              Row(
                children: [
                  Icon(Icons.star, size: 16, color: Colors.amber),
                  SizedBox(width: 4),
                  Text('${book.rating}'),
                ],
              ),
          ],
        ),
        trailing: book.totalChapters != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${book.currentChapter ?? 0}/${book.totalChapters}',
                    style: TextStyle(fontSize: 12),
                  ),
                  if (book.progress != null)
                    LinearProgressIndicator(
                      value: book.progress,
                      minHeight: 4,
                    ),
                ],
              )
            : null,
      ),
    );
  }
}
