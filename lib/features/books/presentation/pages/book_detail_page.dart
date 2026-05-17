import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../shared/widgets/book_cover_widget.dart';
import '../../../bookmarks/presentation/bloc/bookmarks_bloc.dart';
import '../../../bookmarks/presentation/bloc/bookmarks_event.dart';
import '../../../bookmarks/presentation/bloc/bookmarks_state.dart';
import '../../domain/entities/book_entity.dart';
import 'book_reader_page.dart';

class BookDetailPage extends StatelessWidget {
  final BookEntity book;
  const BookDetailPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BookmarksBloc>()..add(BookmarksFetchRequested()),
      child: _BookDetailView(book: book),
    );
  }
}

class _BookDetailView extends StatelessWidget {
  final BookEntity book;
  const _BookDetailView({required this.book});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    final surface = Theme.of(context).colorScheme.surface;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 16),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              BlocBuilder<BookmarksBloc, BookmarksState>(
                builder: (context, state) {
                  final isFav = state is BookmarksSuccess &&
                      state.books.any((b) => b.id == book.id);
                  return IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFav ? Icons.bookmark : Icons.bookmark_border,
                        color: isFav ? accent : Colors.white,
                        size: 20,
                      ),
                    ),
                    onPressed: () => BlocProvider.of<BookmarksBloc>(context).add(
                          BookmarkToggled(bookId: book.id, isFavorite: isFav),
                        ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  BookCoverWidget(
                    coverColor: book.coverColor,
                    title: book.title,
                    author: book.author,
                    width: double.infinity,
                    height: double.infinity,
                    borderRadius: 0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(book.title, style: AppTypography.h1(textPrimary)),
                            const SizedBox(height: AppSpacing.xs),
                            Text('Por ${book.author}', style: AppTypography.body(textSecondary)),
                          ],
                        ),
                      ),
                      if (book.rating != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.star_rounded, color: accent, size: 16),
                              const SizedBox(width: 4),
                              Text(book.rating!.toStringAsFixed(1), style: AppTypography.label(accent)),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, _, _) => BookReaderPage(book: book),
                          transitionsBuilder: (_, anim, _, child) => FadeTransition(opacity: anim, child: child),
                          transitionDuration: const Duration(milliseconds: 400),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(backgroundColor: accent),
                      icon: const Icon(Icons.menu_book_rounded, size: 18),
                      label: const Text('Ler agora'),
                    ),
                  ),
                  if (book.description != null) ...[
                    const SizedBox(height: AppSpacing.lg),
                    Text('Sinopse', style: AppTypography.h2(textPrimary)),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      book.description!,
                      style: AppTypography.body(textSecondary).copyWith(height: 1.6),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _Stat(label: 'Capítulos', value: '${book.totalChapters ?? "-"}', textPrimary: textPrimary, textSecondary: textSecondary),
                        _Divider(),
                        _Stat(label: 'Progresso', value: '${((book.progress ?? 0) * 100).toInt()}%', textPrimary: textPrimary, textSecondary: textSecondary),
                        _Divider(),
                        _Stat(label: 'Avaliação', value: book.rating?.toStringAsFixed(1) ?? '-', textPrimary: textPrimary, textSecondary: textSecondary),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color textPrimary;
  final Color textSecondary;

  const _Stat({required this.label, required this.value, required this.textPrimary, required this.textSecondary});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTypography.h2(textPrimary)),
        const SizedBox(height: AppSpacing.xs),
        Text(label, style: AppTypography.caption(textSecondary)),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 40,
      width: 1,
      color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
    );
  }
}
