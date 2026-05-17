import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String _selected = 'pt';

  static const _languages = [
    ('pt', 'Português', '🇧🇷'),
    ('en', 'English', '🇺🇸'),
    ('es', 'Español', '🇪🇸'),
    ('fr', 'Français', '🇫🇷'),
    ('de', 'Deutsch', '🇩🇪'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    final surface = Theme.of(context).colorScheme.surface;

    return Scaffold(
      appBar: AppBar(
        title: Text('Idioma', style: AppTypography.h2(textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textPrimary),
          onPressed: () => Modular.to.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecione o idioma do aplicativo',
              style: AppTypography.body(textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: _languages.asMap().entries.map((entry) {
                  final index = entry.key;
                  final (code, name, flag) = entry.value;
                  final isLast = index == _languages.length - 1;

                  return Column(
                    children: [
                      ListTile(
                        leading: Text(flag, style: const TextStyle(fontSize: 24)),
                        title: Text(name, style: AppTypography.body(textPrimary)),
                        trailing: _selected == code
                            ? Icon(Icons.check_circle_rounded, color: accent)
                            : Icon(
                                Icons.circle_outlined,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                        onTap: () => setState(() => _selected = code),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: index == 0 ? const Radius.circular(16) : Radius.zero,
                            bottom: isLast ? const Radius.circular(16) : Radius.zero,
                          ),
                        ),
                      ),
                      if (!isLast)
                        Padding(
                          padding: const EdgeInsets.only(left: AppSpacing.md + 48),
                          child: Divider(
                            height: 1,
                            color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
                          ),
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Idioma salvo com sucesso!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Modular.to.pop();
                },
                style: ElevatedButton.styleFrom(backgroundColor: accent),
                child: const Text('Confirmar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
