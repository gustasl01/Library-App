import 'package:flutter/material.dart';
import 'widgets/header_section.dart';
import 'widgets/exercise_card.dart';
import 'widgets/continue_reading_section.dart';
import 'widgets/recommendation_section.dart';
import '../../../shared/components/bottom_navigation/bottom_navigation_widget.dart';
import '../../../infra/repositories/book_repository.dart';
import '../../../domain/entities/book_entity.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<void> _preloadFuture;
  final GlobalKey<ContinueReadingSectionState> _continueReadingKey = GlobalKey();
  final GlobalKey<RecommendationSectionState> _recommendationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Dispara as duas queries em paralelo ao invés de sequencial
    _preloadFuture = Future.wait([
      BookRepository().getFeatured().timeout(const Duration(seconds: 5)),
      BookRepository().getContinueReading().timeout(const Duration(seconds: 5)),
    ]).catchError((_) => <List<BookEntity>>[]);
    
    await _preloadFuture;
  }

  Future<void> _onRefresh() async {
    // Recarrega os dados ao puxar para baixo
    await _loadData();
    
    // Força refresh dos widgets filhos
    _continueReadingKey.currentState?.refresh();
    _recommendationKey.currentState?.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: Color(0xFF5B4B8A),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderSection(),
                ExerciseCard(),
                SizedBox(height: 10),
                ContinueReadingSection(key: _continueReadingKey),
                SizedBox(height: 10),
                RecommendationSection(key: _recommendationKey),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: 0,
      ),
    );
  }
}
