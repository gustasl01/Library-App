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
import '../../../auth/data/datasources/auth_remote_datasource.dart';
import 'all_books_page.dart';
import '../../domain/entities/book_entity.dart';
import '../bloc/home/home_bloc.dart';
import '../bloc/home/home_event.dart';
import '../bloc/home/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(HomeFetchRequested()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  String get _userName {
    final user = sl<AuthRemoteDatasource>().currentUser;
    if (user == null) return 'Leitor';
    final name = user.name ?? user.email ?? 'Leitor';
    return name.split(' ').first;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final primary = isDark ? AppColors.primaryDark : AppColors.primaryLight;

    return Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async => BlocProvider.of<HomeBloc>(context).add(HomeRefreshRequested()),
            color: isDark ? AppColors.accentDark : AppColors.accentLight,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _Header(userName: _userName, textPrimary: textPrimary, textSecondary: textSecondary, primary: primary),
                ),
                if (state is HomeLoading)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        children: [
                          ContinueReadingShimmer(),
                          SizedBox(height: AppSpacing.lg),
                          GridBookShimmer(count: 4),
                        ],
                      ),
                    ),
                  ),
                if (state is HomeSuccess) ...[
                  if (state.continueReading.isNotEmpty)
                    SliverToBoxAdapter(
                      child: _ContinueReadingSection(
                        books: state.continueReading,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: _SectionHeader(
                      title: 'Recomendados',
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      onVerMais: () => Modular.to.pushNamed('/all-books', arguments: AllBooksArgs(title: 'Recomendados', books: state.recommendations)),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: AppSpacing.sm,
                        mainAxisSpacing: AppSpacing.sm,
                        childAspectRatio: 0.65,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => AnimationConfiguration.staggeredGrid(
                          position: index,
                          columnCount: 2,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: _BookGridCard(book: state.recommendations[index]),
                            ),
                          ),
                        ),
                        childCount: state.recommendations.length,
                      ),
                    ),
                  ),
                ],
                const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }
}

class _Header extends StatelessWidget {
  final String userName;
  final Color textPrimary;
  final Color textSecondary;
  final Color primary;

  const _Header({
    required this.userName,
    required this.textPrimary,
    required this.textSecondary,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Olá, $userName 👋',
                      style: AppTypography.h1(Colors.white)),
                  const SizedBox(height: AppSpacing.xs),
                  Text('O que vamos ler hoje?',
                      style: AppTypography.body(Colors.white70)),
                ],
              ),
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: const Icon(Icons.person, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback? onVerMais;

  const _SectionHeader({
    required this.title,
    required this.textPrimary,
    required this.textSecondary,
    this.onVerMais,
  });

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).brightness == Brightness.dark
        ? AppColors.accentDark
        : AppColors.accentLight;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.lg, AppSpacing.md, AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTypography.h2(textPrimary)),
          GestureDetector(
            onTap: onVerMais,
            child: Text('Ver mais', style: AppTypography.caption(onVerMais != null ? accent : textSecondary)),
          ),
        ],
      ),
    );
  }
}

class _ContinueReadingSection extends StatelessWidget {
  final List<BookEntity> books;
  final Color textPrimary;
  final Color textSecondary;

  const _ContinueReadingSection({
    required this.books,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final book = books.first;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = Theme.of(context).colorScheme.surface;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            title: 'Continue Lendo',
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onVerMais: () => Modular.to.pushNamed('/all-books', arguments: AllBooksArgs(title: 'Continue Lendo', books: books)),
          ),
          GestureDetector(
            onTap: () => Modular.to.pushNamed('/book-detail', arguments: book),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                    blurRadius: 16,
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
                    width: 80,
                    height: 116,
                    borderRadius: 8,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(book.title, style: AppTypography.bodyMedium(textPrimary), maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: AppSpacing.xs),
                        Text('Capítulo ${book.currentChapter ?? 1} de ${book.totalChapters ?? '?'}',
                            style: AppTypography.caption(textSecondary)),
                        const SizedBox(height: AppSpacing.sm),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: book.progress ?? 0,
                            backgroundColor: isDark ? AppColors.dividerDark : AppColors.dividerLight,
                            valueColor: AlwaysStoppedAnimation<Color>(accent),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text('${((book.progress ?? 0) * 100).toInt()}% concluído',
                            style: AppTypography.label(textSecondary)),
                        const SizedBox(height: AppSpacing.sm),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accent,
                              minimumSize: const Size(double.infinity, 40),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text('Continuar', style: AppTypography.label(Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookGridCard extends StatelessWidget {
  final BookEntity book;
  const _BookGridCard({required this.book});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

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
