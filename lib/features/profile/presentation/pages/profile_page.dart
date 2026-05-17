import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../shared/widgets/app_bottom_nav.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileBloc>()..add(ProfileFetchRequested()),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final primary = isDark ? AppColors.primaryDark : AppColors.primaryLight;
    final surface = Theme.of(context).colorScheme.surface;

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSignedOut) Modular.to.navigate('/login');
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            final name = state is ProfileLoaded ? state.name : 'User';
            final email = state is ProfileLoaded ? state.email : '';

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 240,
                  pinned: true,
                  automaticallyImplyLeading: false,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.settings_outlined, color: Colors.white),
                      onPressed: () => Modular.to.pushNamed('/settings'),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [primary, primary.withValues(alpha: 0.8)],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: MediaQuery.of(context).padding.top + AppSpacing.md),
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            child: Text(
                              name.isNotEmpty ? name[0].toUpperCase() : 'U',
                              style: AppTypography.display(Colors.white),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(name, style: AppTypography.h2(Colors.white)),
                          const SizedBox(height: AppSpacing.xs),
                          Text(email, style: AppTypography.caption(Colors.white70)),
                          const SizedBox(height: AppSpacing.md),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Estatísticas', style: AppTypography.h2(textPrimary)),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Expanded(child: _StatCard(icon: Icons.menu_book_rounded, value: '24', label: 'Lidos', surface: surface, textPrimary: textPrimary, textSecondary: textSecondary)),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(child: _StatCard(icon: Icons.bookmark_rounded, value: '12', label: 'Favoritos', surface: surface, textPrimary: textPrimary, textSecondary: textSecondary)),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(child: _StatCard(icon: Icons.star_rounded, value: '18', label: 'Reviews', surface: surface, textPrimary: textPrimary, textSecondary: textSecondary)),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text('Conta', style: AppTypography.h2(textPrimary)),
                        const SizedBox(height: AppSpacing.sm),
                        _SettingsItem(icon: Icons.person_outline, label: 'Informações pessoais', textPrimary: textPrimary, surface: surface, onTap: () => Modular.to.pushNamed('/personal-info')),
                        _SettingsItem(icon: Icons.lock_outline, label: 'Alterar senha', textPrimary: textPrimary, surface: surface, onTap: () => Modular.to.pushNamed('/change-password')),
                        _SettingsItem(icon: Icons.notifications_outlined, label: 'Notificações', textPrimary: textPrimary, surface: surface, onTap: () => Modular.to.pushNamed('/notifications')),
                        const SizedBox(height: AppSpacing.lg),
                        Text('Preferências', style: AppTypography.h2(textPrimary)),
                        const SizedBox(height: AppSpacing.sm),
                        _SettingsItem(icon: Icons.language, label: 'Idioma', trailing: Text('Português', style: AppTypography.caption(textSecondary)), textPrimary: textPrimary, surface: surface, onTap: () => Modular.to.pushNamed('/language')),
                        const SizedBox(height: AppSpacing.lg),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => BlocProvider.of<ProfileBloc>(context).add(ProfileSignOutRequested()),
                            icon: const Icon(Icons.logout, color: Colors.red),
                            label: const Text('Sair', style: TextStyle(color: Colors.red)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                              minimumSize: const Size(double.infinity, 52),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: const AppBottomNav(currentIndex: 3),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: accent, size: 28),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: AppTypography.h2(textPrimary)),
          Text(label, style: AppTypography.label(textSecondary)),
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final Color textPrimary;
  final Color surface;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.label,
    this.trailing,
    required this.textPrimary,
    required this.surface,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: accent),
        title: Text(label, style: AppTypography.body(textPrimary)),
        trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
