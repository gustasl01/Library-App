import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';

class AuthService {
  final SupabaseClient _client = SupabaseConfig.client;

  User? get currentUser => _client.auth.currentUser;

  bool get isAuthenticated => currentUser != null;

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(email: email, password: password);
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

    // Garante perfil na tabela public.users, usada pelas policies.
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

    final metadata = user.userMetadata ?? <String, dynamic>{};
    final fullName = (metadata['full_name'] ?? metadata['name'] ?? 'User').toString();
    final email = user.email ?? '';

    await _client.from('users').upsert({
      'id': user.id,
      'name': fullName,
      'email': email,
    });
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
