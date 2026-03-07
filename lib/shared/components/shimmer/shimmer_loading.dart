import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
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

class ContinueReadingShimmer extends StatelessWidget {
  const ContinueReadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          ShimmerLoading(width: 80, height: 120, borderRadius: 8),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoading(width: double.infinity, height: 20, borderRadius: 4),
                SizedBox(height: 8),
                ShimmerLoading(width: 100, height: 14, borderRadius: 4),
                SizedBox(height: 16),
                ShimmerLoading(width: double.infinity, height: 6, borderRadius: 4),
                SizedBox(height: 8),
                ShimmerLoading(width: double.infinity, height: 40, borderRadius: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RecommendationShimmer extends StatelessWidget {
  const RecommendationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 120,
            margin: EdgeInsets.only(right: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoading(width: 120, height: 160, borderRadius: 12),
                SizedBox(height: 8),
                ShimmerLoading(width: 100, height: 12, borderRadius: 4),
                SizedBox(height: 4),
                ShimmerLoading(width: 80, height: 10, borderRadius: 4),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TopBookShimmer extends StatelessWidget {
  const TopBookShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerLoading(
              width: double.infinity,
              height: 180,
              borderRadius: 12,
            ),
            SizedBox(height: 8),
            ShimmerLoading(width: 100, height: 12, borderRadius: 4),
            SizedBox(height: 4),
            ShimmerLoading(width: 80, height: 10, borderRadius: 4),
          ],
        );
      },
    );
  }
}

class BookmarksShimmer extends StatelessWidget {
  const BookmarksShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
        childAspectRatio: 0.7,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerLoading(
              width: double.infinity,
              height: 200,
              borderRadius: 12,
            ),
            SizedBox(height: 8),
            ShimmerLoading(width: 120, height: 14, borderRadius: 4),
            SizedBox(height: 4),
            ShimmerLoading(width: 80, height: 12, borderRadius: 4),
          ],
        );
      },
    );
  }
}
