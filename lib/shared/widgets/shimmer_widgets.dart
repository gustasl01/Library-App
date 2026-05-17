import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF2A2A38) : Colors.grey[300]!,
      highlightColor: isDark ? const Color(0xFF3A3A4A) : Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class BookCardShimmer extends StatelessWidget {
  const BookCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(width: 120, height: 160, borderRadius: 12),
          const SizedBox(height: 8),
          const ShimmerBox(width: 100, height: 12, borderRadius: 4),
          const SizedBox(height: 4),
          const ShimmerBox(width: 80, height: 10, borderRadius: 4),
        ],
      ),
    );
  }
}

class ContinueReadingShimmer extends StatelessWidget {
  const ContinueReadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          ShimmerBox(width: 80, height: 120, borderRadius: 8),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: double.infinity, height: 18, borderRadius: 4),
                SizedBox(height: 8),
                ShimmerBox(width: 100, height: 12, borderRadius: 4),
                SizedBox(height: 16),
                ShimmerBox(width: double.infinity, height: 6, borderRadius: 4),
                SizedBox(height: 8),
                ShimmerBox(width: double.infinity, height: 44, borderRadius: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GridBookShimmer extends StatelessWidget {
  final int count;
  const GridBookShimmer({super.key, this.count = 6});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemCount: count,
      itemBuilder: (_, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          ShimmerBox(width: double.infinity, height: 180, borderRadius: 12),
          SizedBox(height: 8),
          ShimmerBox(width: 100, height: 12, borderRadius: 4),
          SizedBox(height: 4),
          ShimmerBox(width: 80, height: 10, borderRadius: 4),
        ],
      ),
    );
  }
}
