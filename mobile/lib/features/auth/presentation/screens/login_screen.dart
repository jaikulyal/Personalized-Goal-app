import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'register_screen.dart';
import '../../data/auth_repository.dart';
import '/core/navigation/main_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthRepository _authRepository = AuthRepository();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Please enter your email and password.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _authRepository.login(
        email: email,
        password: password,
      );

      if (!mounted) return;

      _showMessage('Welcome back, ${result.user.name}.');

      // Temporary destination.
      // We will replace this with the real dashboard next.
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const MainShell()));
    } catch (error) {
      if (!mounted) return;

      final message = error.toString().replaceFirst('Exception: ', '');

      _showMessage(message);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.lg,
            AppSpacing.screen,
            AppSpacing.xxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Welcome\nback.', style: AppTextStyles.display),

              const SizedBox(height: AppSpacing.md),

              const Text(
                'Sign in and continue where you left off.',
                style: AppTextStyles.bodySmall,
              ),

              const SizedBox(height: AppSpacing.xxl),

              Text('EMAIL', style: AppTextStyles.label),

              const SizedBox(height: AppSpacing.sm),

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(hintText: 'you@example.com'),
              ),

              const SizedBox(height: AppSpacing.lg),

              Text('PASSWORD', style: AppTextStyles.label),

              const SizedBox(height: AppSpacing.sm),

              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Forgot password?'),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF80681F),
                        AppColors.gold,
                        Color(0xFFFFE58A),
                        AppColors.gold,
                        Color(0xFF80681F),
                      ],
                      stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withValues(alpha: 0.30),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: _isLoading ? null : _login,
                      child: Center(
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary,
                                  ),
                                ),
                              )
                            : const Text(
                                'Sign In',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.2,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.divider)),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Text(
                      'OR',
                      style: AppTextStyles.label.copyWith(fontSize: 10),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.divider)),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.gold.withValues(alpha: 0.10),
                        Colors.white.withValues(alpha: 0.04),
                        AppColors.gold.withValues(alpha: 0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.65),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withValues(alpha: 0.10),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        // Google authentication comes later.
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) {
                              return const LinearGradient(
                                colors: [
                                  AppColors.goldDark,
                                  AppColors.gold,
                                  Color(0xFFFFE58A),
                                  AppColors.gold,
                                  AppColors.goldDark,
                                ],
                              ).createShader(bounds);
                            },
                            //blendMode: BlendMode.srcIn,
                            child: const Icon(
                              Icons.g_mobiledata_rounded,
                              size: 27,
                            ),
                          ),
                          const SizedBox(width: 10),
                          ShaderMask(
                            shaderCallback: (bounds) {
                              return const LinearGradient(
                                colors: [
                                  AppColors.goldDark,
                                  AppColors.gold,
                                  Color(0xFFFFE58A),
                                  AppColors.gold,
                                  AppColors.goldDark,
                                ],
                              ).createShader(bounds);
                            },
                            //blendMode: BlendMode.srcIn,
                            child: const Text(
                              'Continue with Google',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: AppTextStyles.bodySmall,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Create one',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
