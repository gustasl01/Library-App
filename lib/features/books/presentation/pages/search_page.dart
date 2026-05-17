import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../shared/widgets/app_bottom_nav.dart';
import '../../../../shared/widgets/book_cover_widget.dart';
import '../../../../shared/widgets/shimmer_widgets.dart';
import '../../domain/entities/author_entity.dart';
import '../../domain/entities/book_entity.dart';
import '../../domain/entities/tag_entity.dart';
import '../bloc/search/search_bloc.dart';
import '../bloc/search/search_event.dart';
import '../bloc/search/search_state.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SearchBloc>()..add(SearchFetchInitialRequested()),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Explorar', style: AppTypography.h1(textPrimary)),
                  const SizedBox(height: AppSpacing.md),
                  _SearchBar(controller: _controller, textSecondary: textSecondary, isDark: isDark),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: GridBookShimmer(),
                    );
                  }
                  if (state is SearchBrowse) {
                    return _BrowseView(
                      state: state,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      onTagTap: (tag) {
                        _controller.text = tag;
                        BlocProvider.of<SearchBloc>(context).add(SearchTagSelected(tag));
                      },
                    );
                  }
                  if (state is SearchResults) {
                    return _ResultsView(state: state, textPrimary: textPrimary, textSecondary: textSecondary);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Color textSecondary;
  final bool isDark;

  const _SearchBar({required this.controller, required this.textSecondary, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final fillColor = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;

    return Container(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: (q) => BlocProvider.of<SearchBloc>(context).add(SearchQueryChanged(q)),
        decoration: InputDecoration(
          hintText: 'Buscar livros, autores...',
          hintStyle: AppTypography.body(textSecondary),
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.clear();
                    BlocProvider.of<SearchBloc>(context).add(SearchCleared());
                  },
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}

class _BrowseView extends StatelessWidget {
  final SearchBrowse state;
  final Color textPrimary;
  final Color textSecondary;
  final ValueChanged<String> onTagTap;

  const _BrowseView({
    required this.state,
    required this.textPrimary,
    required this.textSecondary,
    required this.onTagTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tags populares', style: AppTypography.h2(textPrimary)),
          const SizedBox(height: AppSpacing.sm),
          _TagsRow(tags: state.tags, onTagTap: onTagTap),
          const SizedBox(height: AppSpacing.lg),
          Text('Top Autores', style: AppTypography.h2(textPrimary)),
          const SizedBox(height: AppSpacing.sm),
          _AuthorsRow(authors: state.topAuthors, textPrimary: textPrimary, textSecondary: textSecondary),
          const SizedBox(height: AppSpacing.lg),
          Text('Top Livros', style: AppTypography.h2(textPrimary)),
          const SizedBox(height: AppSpacing.sm),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
              childAspectRatio: 0.65,
            ),
            itemCount: state.topBooks.length,
            itemBuilder: (context, index) => AnimationConfiguration.staggeredGrid(
              position: index,
              columnCount: 2,
              child: ScaleAnimation(
                child: FadeInAnimation(child: _BookGridItem(book: state.topBooks[index], textPrimary: textPrimary, textSecondary: textSecondary)),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _ResultsView extends StatelessWidget {
  final SearchResults state;
  final Color textPrimary;
  final Color textSecondary;

  const _ResultsView({required this.state, required this.textPrimary, required this.textSecondary});

  @override
  Widget build(BuildContext context) {
    if (state.books.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: AppSpacing.md),
            Text('Nenhum resultado para "${state.query}"', style: AppTypography.body(textSecondary)),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
        childAspectRatio: 0.65,
      ),
      itemCount: state.books.length,
      itemBuilder: (context, index) => _BookGridItem(book: state.books[index], textPrimary: textPrimary, textSecondary: textSecondary),
    );
  }
}

class _TagsRow extends StatelessWidget {
  final List<TagEntity> tags;
  final ValueChanged<String> onTagTap;
  const _TagsRow({required this.tags, required this.onTagTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: tags.map((tag) {
        return GestureDetector(
          onTap: () => onTagTap(tag.name),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: tag.isHighlighted ? accent.withValues(alpha: 0.12) : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
              border: Border.all(color: tag.isHighlighted ? accent : (isDark ? AppColors.dividerDark : AppColors.dividerLight)),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(tag.name, style: AppTypography.label(tag.isHighlighted ? accent : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
          ),
        );
      }).toList(),
    );
  }
}

class _AuthorsRow extends StatelessWidget {
  final List<AuthorEntity> authors;
  final Color textPrimary;
  final Color textSecondary;

  const _AuthorsRow({required this.authors, required this.textPrimary, required this.textSecondary});

  @override
  Widget build(BuildContext context) {
    if (authors.isEmpty) {
      return const SizedBox(height: 80, child: Center(child: Text('Sem autores')));
    }
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: authors.length,
        itemBuilder: (context, index) {
          final a = authors[index];
          return Container(
            margin: const EdgeInsets.only(right: AppSpacing.md),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFF2C3E50).withValues(alpha: 0.1),
                  child: Text(a.name.isNotEmpty ? a.name[0].toUpperCase() : '?',
                      style: AppTypography.h2(const Color(0xFF2C3E50))),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(a.name.split(' ').first, style: AppTypography.label(textPrimary)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BookGridItem extends StatelessWidget {
  final BookEntity book;
  final Color textPrimary;
  final Color textSecondary;

  const _BookGridItem({required this.book, required this.textPrimary, required this.textSecondary});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => Modular.to.pushNamed('/book-detail', arguments: book),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: BookCoverWidget(
              coverColor: book.coverColor,
              title: book.title,
              author: book.author,
              width: double.infinity,
              height: double.infinity,
              borderRadius: 12,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(book.title, style: AppTypography.label(textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(book.author, style: AppTypography.label(textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
