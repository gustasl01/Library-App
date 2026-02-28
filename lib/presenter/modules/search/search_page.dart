import 'package:flutter/material.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/popular_tags_section.dart';
import 'widgets/top_author_section.dart';
import 'widgets/top_book_section.dart';
import '../../../shared/components/bottom_navigation/bottom_navigation_widget.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBarWidget(),
            SizedBox(height: 10),
            PopularTagsSection(),
            TopAuthorSection(),
            TopBookSection(),
            SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: 1,
      ),
    );
  }
}
