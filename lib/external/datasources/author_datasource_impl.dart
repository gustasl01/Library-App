import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/author_entity.dart';
import '../../core/config/supabase_config.dart';

class AuthorDatasourceImpl {
  final SupabaseClient _client = SupabaseConfig.client;

  /// Buscar todos os autores
  Future<List<AuthorEntity>> getAuthors() async {
    try {
      final response = await _client
          .from('authors')
          .select()
          .order('name', ascending: true);

      return (response as List)
          .map((author) => AuthorEntity.fromMap(author as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar autores: $e');
    }
  }

  /// Buscar autor por ID
  Future<AuthorEntity> getAuthorById(String id) async {
    try {
      final response = await _client
          .from('authors')
          .select()
          .eq('id', id)
          .single();

      return AuthorEntity.fromMap(response);
    } catch (e) {
      throw Exception('Erro ao buscar autor: $e');
    }
  }

  /// Buscar top autores (por número de livros)
  Future<List<AuthorEntity>> getTopAuthors({int limit = 10}) async {
    try {
      final response = await _client
          .from('authors')
          .select()
          .order('total_books', ascending: false)
          .limit(limit);

      return (response as List)
          .map((author) => AuthorEntity.fromMap(author as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar top autores: $e');
    }
  }

  /// Buscar livros de um autor
  Future<List<Map<String, dynamic>>> getAuthorBooks(String authorId) async {
    try {
      final response = await _client
          .from('books')
          .select()
          .eq('author_id', authorId)
          .order('created_at', ascending: false);

      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Erro ao buscar livros do autor: $e');
    }
  }

  /// Buscar autores por busca
  Future<List<AuthorEntity>> searchAuthors(String query) async {
    try {
      final response = await _client
          .from('authors')
          .select()
          .ilike('name', '%$query%')
          .order('name', ascending: true);

      return (response as List)
          .map((author) => AuthorEntity.fromMap(author as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar autores: $e');
    }
  }
}
