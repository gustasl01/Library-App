import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static String get url => dotenv.env['SUPABASE_URL'] ?? '';
  static String get anonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  static bool get debugMode => (dotenv.env['DEBUG'] ?? 'false') == 'true';

  static Future<void> initialize() async {
    try {
      await dotenv.load(fileName: '.env');

      if (url.isEmpty || anonKey.isEmpty) {
        throw Exception(
          'Credenciais do Supabase não configuradas. '
          'Verifique o arquivo .env com SUPABASE_URL e SUPABASE_ANON_KEY',
        );
      }

      await Supabase.initialize(
        url: url,
        anonKey: anonKey,
        debug: debugMode,
      );
    } catch (e) {
      throw Exception('Erro ao inicializar Supabase: $e');
    }
  }

  static SupabaseClient get client => Supabase.instance.client;

  static String? get userId => client.auth.currentUser?.id;

  static bool get isAuthenticated => client.auth.currentUser != null;
}
