import 'package:flutter/material.dart';
import '../../../../domain/entities/author_entity.dart';

class PopularTagsSection extends StatelessWidget {
  const PopularTagsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<TagEntity> tags = [
      TagEntity(name: 'Adventure', isHighlighted: true),
      TagEntity(name: 'Action'),
      TagEntity(name: 'Romance', isHighlighted: true),
      TagEntity(name: 'Future'),
      TagEntity(name: 'Horor'),
      TagEntity(name: 'Comedy'),
      TagEntity(name: 'Detective'),
      TagEntity(name: 'School', isHighlighted: true),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Tags',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: tags.map((tag) => _TagChip(tag: tag)).toList(),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final TagEntity tag;

  const _TagChip({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: tag.isHighlighted ? Color(0xFFFDD835) : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        tag.name,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: tag.isHighlighted ? Colors.black87 : Colors.grey[600],
        ),
      ),
    );
  }
}
