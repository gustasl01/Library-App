import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/widgets/book_cover_widget.dart';
import '../../domain/entities/book_entity.dart';

class AllBooksArgs {
  final String title;
  final List<BookEntity> books;
  const AllBooksArgs({required this.title, required this.books});
}

class AllBooksPage extends StatelessWidget {
  final AllBooksArgs args;
  const AllBooksPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.title, style: AppTypography.h2(textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textPrimary),
          onPressed: () => Modular.to.pop(),
        ),
      ),
      body: args.books.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.library_books_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: AppSpacing.md),
                  Text('Nenhum livro disponível', style: AppTypography.body(textSecondary)),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.sm,
                mainAxisSpacing: AppSpacing.sm,
                childAspectRatio: 0.65,
              ),
              itemCount: args.books.length,
              itemBuilder: (context, index) {
                final book = args.books[index];
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
              },
            ),
    );
  }
}
