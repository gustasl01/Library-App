import 'package:flutter/material.dart';
import 'widgets/header_section.dart';
import 'widgets/exercise_card.dart';
import 'widgets/continue_reading_section.dart';
import 'widgets/recommendation_section.dart';
import '../../widgets/common/bottom_navigation.dart';
import '../search/search_screen.dart';
import '../profile/profile_screen.dart';
import '../bookmarks/bookmarks_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onNavigationTap(int index) {
    if (index == 1) {
      // Navigate to search screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SearchScreen()),
      );
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
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderSection(userName: 'Demo'),
            ExerciseCard(),
            SizedBox(height: 10),
            ContinueReadingSection(),
            SizedBox(height: 10),
            RecommendationSection(),
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
