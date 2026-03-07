import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/app_module/app_module.dart';
import 'core/config/supabase_config.dart';
import 'core/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await SupabaseConfig.initialize();

    // Flag para ignorar o estado inicial e só reagir a mudanças
    bool isInitialLoad = true;

    // Listener global — persiste durante toda a vida do app
    SupabaseConfig.client.auth.onAuthStateChange.listen((data) async {
      final session = data.session;
      final event = data.event;
      
      debugPrint('Auth event: $event, session: ${session != null}');

      // Ignora o evento inicial (INITIAL_SESSION) para não conflitar com AuthGatePage
      if (isInitialLoad) {
        isInitialLoad = false;
        debugPrint('Auth: Ignorando evento inicial');
        return;
      }

      if (event == AuthChangeEvent.signedIn && session != null) {
        debugPrint('Auth: Usuário logou, processando perfil e navegando');
        await Future.delayed(const Duration(milliseconds: 300));
        final authService = AuthService();
        try {
          await authService.ensureUserProfile();
        } catch (e) {
          debugPrint('ensureUserProfile error: $e');
        }
        Modular.to.navigate('/home');
      } else if (event == AuthChangeEvent.signedOut) {
        debugPrint('Auth: Usuário deslogou');
        Modular.to.navigate('/login');
      }
    });

    runApp(ModularApp(module: AppModule(), child: const MainApp()));
  } catch (e) {
    // Se falhar ao inicializar, exibir erro
    runApp(ErrorApp(error: e.toString()));
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Library App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF5B4B8A),
          primary: Color(0xFF5B4B8A),
        ),
        scaffoldBackgroundColor: Colors.grey[50],
        fontFamily: 'Roboto',
      ),
      routerConfig: Modular.routerConfig,
    );
  }
}

class ErrorApp extends StatelessWidget {
  final String error;

  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'Erro ao Inicializar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                SizedBox(height: 32),
                Text(
                  '⚠️ Configuração do Supabase não encontrada.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
