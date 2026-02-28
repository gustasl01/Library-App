import 'package:flutter/material.dart';
import '../../../../domain/entities/author_entity.dart';

class PopularTagsSection extends StatelessWidget {
  const PopularTagsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<TagEntity> tags = [
      TagEntity(id: 'tag-1', name: 'Adventure', isHighlighted: true),
      TagEntity(id: 'tag-2', name: 'Action'),
      TagEntity(id: 'tag-3', name: 'Romance', isHighlighted: true),
      TagEntity(id: 'tag-4', name: 'Future'),
      TagEntity(id: 'tag-5', name: 'Horor'),
      TagEntity(id: 'tag-6', name: 'Comedy'),
      TagEntity(id: 'tag-7', name: 'Detective'),
      TagEntity(id: 'tag-8', name: 'School', isHighlighted: true),
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
