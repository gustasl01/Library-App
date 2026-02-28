import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/book_entity.dart';
import '../../core/config/supabase_config.dart';

class BookDatasourceImpl {
  final SupabaseClient _client = SupabaseConfig.client;

  /// Buscar todos os livros
  Future<List<BookEntity>> getBooks() async {
    try {
      final response = await _client
          .from('books')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((book) => BookEntity.fromMap(book as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar livros: $e');
    }
  }

  /// Buscar livro por ID
  Future<BookEntity> getBookById(String id) async {
    try {
      final response = await _client
          .from('books')
          .select()
          .eq('id', id)
          .single();

      return BookEntity.fromMap(response);
    } catch (e) {
      throw Exception('Erro ao buscar livro: $e');
    }
  }

  /// Buscar livros em destaque
  Future<List<BookEntity>> getFeaturedBooks() async {
    try {
      final response = await _client
          .from('books')
          .select()
          .eq('is_featured', true)
          .order('rating', ascending: false)
          .limit(10);

      return (response as List)
          .map((book) => BookEntity.fromMap(book as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar livros em destaque: $e');
    }
  }

  /// Buscar livros por busca (full-text)
  Future<List<BookEntity>> searchBooks(String query) async {
    try {
      final response = await _client.rpc(
        'search_books',
        params: {'search_query': query},
      ) as List;

      return response
          .map((book) => BookEntity.fromMap(book as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar livros: $e');
    }
  }

  /// Buscar livros que o usuário está lendo (continue reading)
  Future<List<BookEntity>> getContinueReadingBooks() async {
    try {
      final userId = SupabaseConfig.userId;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = await _client
          .from('reading_progress')
          .select('books(*)')
          .eq('user_id', userId)
          .lt('progress', 1.0)
          .order('last_read_at', ascending: false)
          .limit(5);

      return (response as List)
          .map((item) =>
              BookEntity.fromMap(item['books'] as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar livros em leitura: $e');
    }
  }

  /// Buscar livros por categoria/tag
  Future<List<BookEntity>> getBooksByTag(String tagName) async {
    try {
      final response = await _client
          .from('books')
          .select('''
            *,
            book_tags(
              tags(name)
            )
          ''')
          .order('rating', ascending: false);

      // Filtrar manualmente pelos livros com a tag
      final books = (response as List)
          .where((book) {
            final bookTags =
                book['book_tags'] as List<dynamic>?;
            return bookTags?.any((bt) =>
                    (bt['tags'] as Map?)?['name'] == tagName) ??
                false;
          })
          .map((book) => BookEntity.fromMap(book as Map<String, dynamic>))
          .toList();

      return books;
    } catch (e) {
      throw Exception('Erro ao buscar livros por tag: $e');
    }
  }

  /// Buscar recomendações (livros em destaque aleatoriamente)
  Future<List<BookEntity>> getRecommendations({int limit = 5}) async {
    try {
      final response = await _client
          .from('books')
          .select()
          .order('rating', ascending: false)
          .limit(limit);

      return (response as List)
          .map((book) => BookEntity.fromMap(book as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar recomendações: $e');
    }
  }

  /// Adicionar livro aos favoritos
  Future<void> addToFavorites(String bookId) async {
    try {
      final userId = SupabaseConfig.userId;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      await _client.from('favorites').insert({
        'user_id': userId,
        'book_id': bookId,
      });
    } catch (e) {
      throw Exception('Erro ao adicionar aos favoritos: $e');
    }
  }

  /// Remover livro dos favoritos
  Future<void> removeFromFavorites(String bookId) async {
    try {
      final userId = SupabaseConfig.userId;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      await _client
          .from('favorites')
          .delete()
          .eq('user_id', userId)
          .eq('book_id', bookId);
    } catch (e) {
      throw Exception('Erro ao remover dos favoritos: $e');
    }
  }

  /// Verificar se livro está nos favoritos
  Future<bool> isFavorite(String bookId) async {
    try {
      final userId = SupabaseConfig.userId;
      if (userId == null) {
        return false;
      }

      final response = await _client
          .from('favorites')
          .select()
          .eq('user_id', userId)
          .eq('book_id', bookId);

      return (response as List).isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Buscar favoritos do usuário
  Future<List<BookEntity>> getFavoriteBooks() async {
    try {
      final userId = SupabaseConfig.userId;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = await _client
          .from('favorites')
          .select('books(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) =>
              BookEntity.fromMap(item['books'] as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar favoritos: $e');
    }
  }

  /// Atualizar progresso de leitura
  Future<void> updateReadingProgress(
    String bookId, {
    required int currentChapter,
    required double progress,
  }) async {
    try {
      final userId = SupabaseConfig.userId;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      await _client.from('reading_progress').upsert({
        'user_id': userId,
        'book_id': bookId,
        'current_chapter': currentChapter,
        'progress': progress,
      });
    } catch (e) {
      throw Exception('Erro ao atualizar progresso: $e');
    }
  }

  /// Obter progresso de leitura
  Future<Map<String, dynamic>?> getReadingProgress(String bookId) async {
    try {
      final userId = SupabaseConfig.userId;
      if (userId == null) {
        return null;
      }

      final response = await _client
          .from('reading_progress')
          .select()
          .eq('user_id', userId)
          .eq('book_id', bookId)
          .maybeSingle();

      return response;
    } catch (e) {
      return null;
    }
  }
}
