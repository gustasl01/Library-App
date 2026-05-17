import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    final surface = Theme.of(context).colorScheme.surface;

    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações', style: AppTypography.h2(textPrimary)),
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
            Text('Conta', style: AppTypography.h2(textPrimary)),
            const SizedBox(height: AppSpacing.sm),
            _SettingsGroup(
              surface: surface,
              children: [
                _SettingsItem(
                  icon: Icons.person_outline,
                  label: 'Informações pessoais',
                  accent: accent,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  onTap: () => Modular.to.pushNamed('/personal-info'),
                ),
                _SettingsDivider(isDark: isDark),
                _SettingsItem(
                  icon: Icons.lock_outline,
                  label: 'Alterar senha',
                  accent: accent,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  onTap: () => Modular.to.pushNamed('/change-password'),
                ),
                _SettingsDivider(isDark: isDark),
                _SettingsItem(
                  icon: Icons.notifications_outlined,
                  label: 'Notificações',
                  accent: accent,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  onTap: () => Modular.to.pushNamed('/notifications'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Preferências', style: AppTypography.h2(textPrimary)),
            const SizedBox(height: AppSpacing.sm),
            _SettingsGroup(
              surface: surface,
              children: [
                _SettingsItem(
                  icon: Icons.language,
                  label: 'Idioma',
                  trailing: Text('Português', style: AppTypography.caption(textSecondary)),
                  accent: accent,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  onTap: () => Modular.to.pushNamed('/language'),
                ),
                _SettingsDivider(isDark: isDark),
                _SettingsItem(
                  icon: Icons.dark_mode_outlined,
                  label: 'Tema',
                  trailing: Text('Sistema', style: AppTypography.caption(textSecondary)),
                  accent: accent,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Sobre', style: AppTypography.h2(textPrimary)),
            const SizedBox(height: AppSpacing.sm),
            _SettingsGroup(
              surface: surface,
              children: [
                _SettingsItem(
                  icon: Icons.info_outline,
                  label: 'Versão do app',
                  trailing: Text('1.0.0', style: AppTypography.caption(textSecondary)),
                  accent: accent,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  showArrow: false,
                  onTap: () {},
                ),
                _SettingsDivider(isDark: isDark),
                _SettingsItem(
                  icon: Icons.policy_outlined,
                  label: 'Política de privacidade',
                  accent: accent,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  onTap: () {},
                ),
                _SettingsDivider(isDark: isDark),
                _SettingsItem(
                  icon: Icons.description_outlined,
                  label: 'Termos de uso',
                  accent: accent,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final Color surface;
  final List<Widget> children;
  const _SettingsGroup({required this.surface, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  final bool isDark;
  const _SettingsDivider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.md + 40),
      child: Divider(
        height: 1,
        color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onTap;
  final bool showArrow;

  const _SettingsItem({
    required this.icon,
    required this.label,
    this.trailing,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.onTap,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Icon(icon, color: accent),
      title: Text(label, style: AppTypography.body(textPrimary)),
      trailing: trailing ?? (showArrow ? Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight) : null),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
