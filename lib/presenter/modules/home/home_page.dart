import 'package:flutter/material.dart';
import 'widgets/header_section.dart';
import 'widgets/exercise_card.dart';
import 'widgets/continue_reading_section.dart';
import 'widgets/recommendation_section.dart';
import '../../../shared/components/bottom_navigation/bottom_navigation_widget.dart';
import '../../../infra/repositories/book_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<void> _preloadFuture;

  @override
  void initState() {
    super.initState();
    // Dispara as duas queries em paralelo ao invés de sequencial
    _preloadFuture = Future.wait([
      BookRepository().getFeatured().timeout(const Duration(seconds: 5)),
      BookRepository().getContinueReading().timeout(const Duration(seconds: 5)),
    ]).catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderSection(userName: 'Demo'),
              ExerciseCard(),
              SizedBox(height: 10),
              ContinueReadingSection(),
              SizedBox(height: 10),
              RecommendationSection(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: 0,
      ),
    );
  }
}
