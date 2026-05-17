import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final surface = Theme.of(context).colorScheme.surface;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
        if (state is AuthAuthenticated) {
          Modular.to.navigate('/home');
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.accentDark : AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text('Library App', style: AppTypography.h2(textPrimary)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text('Bem-vindo de volta', style: AppTypography.display(textPrimary)),
                    const SizedBox(height: AppSpacing.sm),
                    Text('Acesse sua conta para continuar lendo', style: AppTypography.body(textSecondary)),
                    const SizedBox(height: AppSpacing.xl),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'E-mail',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              validator: (v) {
                                final value = (v ?? '').trim();
                                if (value.isEmpty) return 'Informe seu e-mail';
                                if (!value.contains('@')) return 'E-mail inválido';
                                return null;
                              },
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscure,
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  onPressed: () => setState(() => _obscure = !_obscure),
                                  icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                                ),
                              ),
                              validator: (v) {
                                if ((v ?? '').isEmpty) return 'Informe sua senha';
                                return null;
                              },
                            ),
                            const SizedBox(height: AppSpacing.md),
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                final loading = state is AuthLoading;
                                return ElevatedButton(
                                  onPressed: loading ? null : _submit,
                                  child: loading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                        )
                                      : const Text('Entrar'),
                                );
                              },
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Row(
                              children: [
                                Expanded(child: Divider(color: isDark ? AppColors.dividerDark : AppColors.dividerLight)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                                  child: Text('ou', style: AppTypography.caption(textSecondary)),
                                ),
                                Expanded(child: Divider(color: isDark ? AppColors.dividerDark : AppColors.dividerLight)),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                            OutlinedButton.icon(
                              onPressed: () {
                                BlocProvider.of<AuthBloc>(context).add(AuthSignInWithGoogleRequested());
                              },
                              icon: Image.asset('assets/images/google_logo.png', width: 20, height: 20),
                              label: const Text('Continuar com Google'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Não tem conta?', style: AppTypography.body(textSecondary)),
                        TextButton(
                          onPressed: () => Modular.to.pushNamed('/register'),
                          child: Text('Criar conta', style: AppTypography.bodyMedium(accent)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    BlocProvider.of<AuthBloc>(context).add(AuthSignInWithEmailRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ));
  }
}
