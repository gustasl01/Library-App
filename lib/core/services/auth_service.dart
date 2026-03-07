import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';

class AuthService {
  final SupabaseClient _client = SupabaseConfig.client;

  User? get currentUser => _client.auth.currentUser;

  bool get isAuthenticated => currentUser != null;

  // ✅ Expõe o stream de autenticação
  Stream<Session?> get authStateChanges =>
      _client.auth.onAuthStateChange.map((data) => data.session);

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      throw Exception('Erro de autenticação: ${e.message}');
    } catch (e) {
      // Captura erros de rede/handshake
      if (e.toString().contains('HandshakeException')) {
        throw Exception(
          'Erro de conexão SSL. Verifique sua conexão com a internet e '
          'se a URL do Supabase está correta.',
        );
      }
      throw Exception('Erro ao fazer login: $e');
    }
  }

  Future<void> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signUp(email: email, password: password);
    final user = response.user;

    if (user == null) {
      throw Exception('Nao foi possivel criar o usuario.');
    }

    await _client.from('users').upsert({
      'id': user.id,
      'name': name,
      'email': email,
    });
  }

  Future<void> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.flutter://login-callback/',
    );
  }

  Future<void> ensureUserProfile() async {
    final user = currentUser;
    if (user == null) return;

    final existing = await _client
        .from('users')
        .select('id')
        .eq('id', user.id)
        .maybeSingle();

    if (existing != null) return;

    final metadata = user.userMetadata ?? <String, dynamic>{};
    final fullName = (metadata['full_name'] ?? metadata['name'] ?? 'User').toString();
    final email = user.email ?? '';

    await _client.from('users').insert({
      'id': user.id,
      'name': fullName,
      'email': email,
    });
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
