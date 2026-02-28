import 'package:flutter/material.dart';
import 'widgets/header_section.dart';
import 'widgets/exercise_card.dart';
import 'widgets/continue_reading_section.dart';
import 'widgets/recommendation_section.dart';
import '../../../shared/components/bottom_navigation/bottom_navigation_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
            SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: 0,
      ),
    );
  }
}
