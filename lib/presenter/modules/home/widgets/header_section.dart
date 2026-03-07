import 'package:flutter/material.dart';
import '../../../../core/services/auth_service.dart';

class HeaderSection extends StatelessWidget {
  final AuthService _authService = AuthService();

  HeaderSection({super.key});

  String get _userName {
    final user = _authService.currentUser;
    if (user == null) return 'Guest';
    
    final metadata = user.userMetadata ?? {};
    final name = metadata['full_name'] ?? metadata['name'] ?? user.email?.split('@').first ?? 'User';
    
    // Pega apenas o primeiro nome
    return name.toString().split(' ').first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF5B4B8A),
            Color(0xFF6B5B9A),
          ],
        ),
      ),
      padding: EdgeInsets.fromLTRB(20, 60, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Hello, $_userName',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Text(
                '👋',
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'what do you want to\nread today?',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
