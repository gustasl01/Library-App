import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../core/constants/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({super.key, required this.currentIndex});

  static const _routes = ['/home', '/search', '/bookmarks', '/profile'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedColor = isDark ? AppColors.accentDark : AppColors.primaryLight;
    final surface = Theme.of(context).colorScheme.surface;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home_rounded, index: 0, currentIndex: currentIndex, selectedColor: selectedColor, routes: _routes),
              _NavItem(icon: Icons.search_rounded, index: 1, currentIndex: currentIndex, selectedColor: selectedColor, routes: _routes),
              _NavItem(icon: Icons.bookmark_rounded, index: 2, currentIndex: currentIndex, selectedColor: selectedColor, routes: _routes),
              _NavItem(icon: Icons.person_rounded, index: 3, currentIndex: currentIndex, selectedColor: selectedColor, routes: _routes),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final int index;
  final int currentIndex;
  final Color selectedColor;
  final List<String> routes;

  const _NavItem({
    required this.icon,
    required this.index,
    required this.currentIndex,
    required this.selectedColor,
    required this.routes,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;
    return GestureDetector(
      onTap: () {
        if (!isSelected) Modular.to.navigate(routes[index]);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isSelected ? selectedColor : Colors.grey,
          size: 24,
        ),
      ),
    );
  }
}
