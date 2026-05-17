import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _newBooks = true;
  bool _readingReminder = true;
  bool _bookmarks = false;
  bool _promotions = false;
  bool _updates = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    final surface = Theme.of(context).colorScheme.surface;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notificações', style: AppTypography.h2(textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textPrimary),
          onPressed: () => Modular.to.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Atividade', style: AppTypography.h2(textPrimary)),
            const SizedBox(height: AppSpacing.sm),
            _NotificationGroup(
              surface: surface,
              isDark: isDark,
              children: [
                _NotificationTile(
                  icon: Icons.auto_stories_outlined,
                  title: 'Novos livros',
                  subtitle: 'Seja notificado quando novos livros forem adicionados',
                  value: _newBooks,
                  accent: accent,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  onChanged: (v) => setState(() => _newBooks = v),
                ),
                _Divider(isDark: isDark),
                _NotificationTile(
                  icon: Icons.alarm_outlined,
                  title: 'Lembrete de leitura',
                  subtitle: 'Receba lembretes para continuar sua leitura',
                  value: _readingReminder,
                  accent: accent,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  onChanged: (v) => setState(() => _readingReminder = v),
                ),
                _Divider(isDark: isDark),
                _NotificationTile(
                  icon: Icons.bookmark_outline,
                  title: 'Favoritos',
                  subtitle: 'Atualizações sobre seus livros favoritos',
                  value: _bookmarks,
                  accent: accent,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  onChanged: (v) => setState(() => _bookmarks = v),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Geral', style: AppTypography.h2(textPrimary)),
            const SizedBox(height: AppSpacing.sm),
            _NotificationGroup(
              surface: surface,
              isDark: isDark,
              children: [
                _NotificationTile(
                  icon: Icons.local_offer_outlined,
                  title: 'Promoções',
                  subtitle: 'Ofertas e conteúdo exclusivo',
                  value: _promotions,
                  accent: accent,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  onChanged: (v) => setState(() => _promotions = v),
                ),
                _Divider(isDark: isDark),
                _NotificationTile(
                  icon: Icons.system_update_outlined,
                  title: 'Atualizações do app',
                  subtitle: 'Novidades e melhorias do aplicativo',
                  value: _updates,
                  accent: accent,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  onChanged: (v) => setState(() => _updates = v),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationGroup extends StatelessWidget {
  final Color surface;
  final bool isDark;
  final List<Widget> children;
  const _NotificationGroup({required this.surface, required this.isDark, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(16)),
      child: Column(children: children),
    );
  }
}

class _Divider extends StatelessWidget {
  final bool isDark;
  const _Divider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.md + 40),
      child: Divider(height: 1, color: isDark ? AppColors.dividerDark : AppColors.dividerLight),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;
  final ValueChanged<bool> onChanged;

  const _NotificationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: accent),
      title: Text(title, style: AppTypography.body(textPrimary)),
      subtitle: Text(subtitle, style: AppTypography.caption(textSecondary)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: accent,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
