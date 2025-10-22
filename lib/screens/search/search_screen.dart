import 'package:flutter/material.dart';
import 'widgets/search_bar_widget.dart' as custom;
import 'widgets/popular_tags_section.dart';
import 'widgets/top_author_section.dart';
import 'widgets/top_book_section.dart';
import '../../widgets/common/bottom_navigation.dart';
import '../profile/profile_screen.dart';
import '../bookmarks/bookmarks_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _currentIndex = 1; // Search is at index 1

  void _onNavigationTap(int index) {
    if (index == 0) {
      // Navigate back to home
      Navigator.pop(context);
    } else if (index == 2) {
      // Navigate to bookmarks screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BookmarksScreen()),
      );
    } else if (index == 3) {
      // Navigate to profile screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            custom.SearchBar(),
            SizedBox(height: 10),
            PopularTagsSection(),
            TopAuthorSection(),
            TopBookSection(),
            SizedBox(height: 80), // Space for bottom navigation
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onNavigationTap,
      ),
    );
  }
}
