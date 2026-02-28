import 'package:flutter/material.dart';

class TopAuthorSection extends StatelessWidget {
  const TopAuthorSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> authors = [
      {'name': 'Terellye', 'color': '0xFF4B5563'},
      {'name': 'Howard', 'color': '0xFFE5E7EB'},
      {'name': 'Jessica', 'color': '0xFF3B82F6'},
      {'name': 'Terellye', 'color': '0xFFEC4899'},
      {'name': 'Dee', 'color': '0xFF10B981'},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Author',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: authors.length,
              itemBuilder: (context, index) {
                return _AuthorAvatar(
                  name: authors[index]['name']!,
                  color: Color(int.parse(authors[index]['color']!)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthorAvatar extends StatelessWidget {
  final String name;
  final Color color;

  const _AuthorAvatar({
    required this.name,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '👤',
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
