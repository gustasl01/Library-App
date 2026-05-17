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
import '../../../books/domain/entities/book_entity.dart';
import '../bloc/bookmarks_bloc.dart';
import '../bloc/bookmarks_event.dart';
import '../bloc/bookmarks_state.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BookmarksBloc>()..add(BookmarksFetchRequested()),
      child: const _BookmarksView(),
    );
  }
}

class _BookmarksView extends StatelessWidget {
  const _BookmarksView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final primary = isDark ? AppColors.primaryDark : AppColors.primaryLight;

    return Scaffold(
      body: BlocBuilder<BookmarksBloc, BookmarksState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 140,
                pinned: true,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [primary, primary.withValues(alpha: 0.8)],
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      MediaQuery.of(context).padding.top + AppSpacing.md,
                      AppSpacing.md,
                      AppSpacing.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Favoritos', style: AppTypography.h1(Colors.white)),
                        const SizedBox(height: AppSpacing.xs),
                        if (state is BookmarksSuccess)
                          Text('${state.books.length} livros salvos', style: AppTypography.caption(Colors.white70)),
                      ],
                    ),
                  ),
                ),
              ),
              if (state is BookmarksLoading)
                const SliverFillRemaining(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: GridBookShimmer(),
                  ),
                ),
              if (state is BookmarksSuccess && state.books.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bookmark_border, size: 80, color: textSecondary),
                        const SizedBox(height: AppSpacing.md),
                        Text('Nenhum favorito ainda', style: AppTypography.h2(textPrimary)),
                        const SizedBox(height: AppSpacing.sm),
                        Text('Adicione livros aos favoritos para vê-los aqui', style: AppTypography.body(textSecondary), textAlign: TextAlign.center),
                        const SizedBox(height: AppSpacing.lg),
                        ElevatedButton(
                          onPressed: () => Modular.to.navigate('/search'),
                          child: const Text('Explorar livros'),
                        ),
                      ],
                    ),
                  ),
                ),
              if (state is BookmarksSuccess && state.books.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => AnimationConfiguration.staggeredList(
                        position: index,
                        child: SlideAnimation(
                          verticalOffset: 24,
                          child: FadeInAnimation(
                            child: _BookmarkCard(
                              book: state.books[index],
                              textPrimary: textPrimary,
                              textSecondary: textSecondary,
                            ),
                          ),
                        ),
                      ),
                      childCount: state.books.length,
                    ),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
            ],
          );
        },
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
    );
  }
}

class _BookmarkCard extends StatelessWidget {
  final BookEntity book;
  final Color textPrimary;
  final Color textSecondary;

  const _BookmarkCard({required this.book, required this.textPrimary, required this.textSecondary});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = Theme.of(context).colorScheme.surface;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return GestureDetector(
      onTap: () => Modular.to.pushNamed('/book-detail', arguments: book),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            BookCoverWidget(
              coverColor: book.coverColor,
              title: book.title,
              author: book.author,
              width: 70,
              height: 100,
              borderRadius: 10,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(book.title, style: AppTypography.bodyMedium(textPrimary), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: AppSpacing.xs),
                  Text(book.author, style: AppTypography.caption(textSecondary)),
                  if (book.progress != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: book.progress,
                        backgroundColor: isDark ? AppColors.dividerDark : AppColors.dividerLight,
                        valueColor: AlwaysStoppedAnimation<Color>(accent),
                        minHeight: 5,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text('${((book.progress ?? 0) * 100).toInt()}% lido', style: AppTypography.label(textSecondary)),
                  ],
                  if (book.rating != null && book.progress == null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Icon(Icons.star_rounded, size: 14, color: accent),
                        const SizedBox(width: 4),
                        Text(book.rating!.toStringAsFixed(1), style: AppTypography.label(textSecondary)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.bookmark, color: accent),
              onPressed: () => BlocProvider.of<BookmarksBloc>(context).add(
                    BookmarkToggled(bookId: book.id, isFavorite: true),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
