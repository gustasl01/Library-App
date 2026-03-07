import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../core/config/supabase_config.dart';

class AuthGatePage extends StatefulWidget {
  const AuthGatePage({super.key});

  @override
  State<AuthGatePage> createState() => _AuthGatePageState();
}

class _AuthGatePageState extends State<AuthGatePage> {
  @override
  void initState() {
    super.initState();
    // Espera o primeiro frame ser renderizado antes de navegar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (SupabaseConfig.isAuthenticated) {
        Modular.to.navigate('/home');
      } else {
        Modular.to.navigate('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
