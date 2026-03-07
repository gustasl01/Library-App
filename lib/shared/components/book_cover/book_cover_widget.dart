import 'package:flutter/material.dart';

class BookCoverWidget extends StatelessWidget {
  final String? coverImage;
  final String coverColor;
  final double width;
  final double height;
  final double borderRadius;
  final String fallbackEmoji;
  final List<BoxShadow>? boxShadow;

  const BookCoverWidget({
    super.key,
    required this.coverImage,
    required this.coverColor,
    required this.width,
    required this.height,
    this.borderRadius = 12,
    this.fallbackEmoji = '📚',
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = coverImage != null && coverImage!.trim().isNotEmpty;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: _parseColor(coverColor),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: hasImage
          ? Image.network(
              coverImage!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _fallback();
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
            )
          : _fallback(),
    );
  }

  Widget _fallback() {
    return Container(
      color: _parseColor(coverColor),
      alignment: Alignment.center,
      child: Text(
        fallbackEmoji,
        style: const TextStyle(fontSize: 42),
      ),
    );
  }

  Color _parseColor(String raw) {
    final value = raw.trim();

    if (value.startsWith('#')) {
      return Color(int.parse('0xFF${value.substring(1)}'));
    }

    if (value.startsWith('0x')) {
      return Color(int.parse(value));
    }

    return const Color(0xFF3B82F6);
  }
}
