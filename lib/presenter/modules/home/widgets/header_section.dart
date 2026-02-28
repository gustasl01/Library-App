import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final String userName;

  const HeaderSection({
    super.key,
    required this.userName,
  });

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
                'Hello, $userName',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
