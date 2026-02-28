import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'core/app_module/app_module.dart';

void main() {
  runApp(ModularApp(module: AppModule(), child: const MainApp()));
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
