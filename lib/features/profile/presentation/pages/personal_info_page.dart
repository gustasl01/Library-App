import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class PersonalInfoPage extends StatelessWidget {
  const PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileBloc>()..add(ProfileFetchRequested()),
      child: const _PersonalInfoView(),
    );
  }
}

class _PersonalInfoView extends StatefulWidget {
  const _PersonalInfoView();

  @override
  State<_PersonalInfoView> createState() => _PersonalInfoViewState();
}

class _PersonalInfoViewState extends State<_PersonalInfoView> {
  late final TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileNameUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nome atualizado com sucesso!'), backgroundColor: Colors.green),
          );
          Modular.to.pop();
        }
        if (state is ProfileLoaded) {
          _nameController.text = state.name;
        }
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Informações pessoais', style: AppTypography.h2(textPrimary)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: textPrimary),
            onPressed: () => Modular.to.pop(),
          ),
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            String email = '';
            if (state is ProfileLoaded) {
              email = state.email;
              if (_nameController.text.isEmpty) {
                _nameController.text = state.name;
              }
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: accent.withValues(alpha: 0.15),
                        child: Text(
                          _nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : 'U',
                          style: AppTypography.display(accent),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text('Nome', style: AppTypography.label(textSecondary)),
                    const SizedBox(height: AppSpacing.xs),
                    TextFormField(
                      controller: _nameController,
                      style: AppTypography.body(textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Seu nome',
                        hintStyle: AppTypography.body(textSecondary),
                        prefixIcon: Icon(Icons.person_outline, color: accent),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe seu nome' : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text('E-mail', style: AppTypography.label(textSecondary)),
                    const SizedBox(height: AppSpacing.xs),
                    TextFormField(
                      initialValue: email,
                      readOnly: true,
                      style: AppTypography.body(textSecondary),
                      decoration: InputDecoration(
                        hintText: 'E-mail',
                        prefixIcon: Icon(Icons.email_outlined, color: textSecondary),
                        suffixIcon: Icon(Icons.lock_outline, color: textSecondary, size: 16),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'O e-mail não pode ser alterado por aqui.',
                      style: AppTypography.caption(textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            BlocProvider.of<ProfileBloc>(context).add(
                                  ProfileUpdateNameRequested(name: _nameController.text.trim()),
                                );
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: accent),
                        child: const Text('Salvar alterações'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
