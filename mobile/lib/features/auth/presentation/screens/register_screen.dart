import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'login_screen.dart';
import '../../data/auth_repository.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthRepository _authRepository = AuthRepository();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showMessage('Please complete all fields.');
      return;
    }

    if (password.length < 8) {
      _showMessage('Password must be at least 8 characters.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _authRepository.register(
        name: name,
        email: email,
        password: password,
      );

      if (!mounted) return;

      _showMessage('Welcome, ${result.user.name}.');

      // Temporary destination.
      // We will replace this with the real Home screen.
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
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
              RichText(
                text: TextSpan(
                  style: AppTextStyles.display,
                  children: [
                    const TextSpan(text: 'Your '),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: ShaderMask(
                        shaderCallback: (bounds) {
                          return const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.goldDark,
                              AppColors.gold,
                              Color(0xFFFFE58A),
                              AppColors.gold,
                              AppColors.goldDark,
                            ],
                            stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.srcIn,
                        child: Text('Journey', style: AppTextStyles.display),
                      ),
                    ),
                    const TextSpan(text: ' Begins'),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              const Text(
                'Create your account and start making progress.',
                style: AppTextStyles.bodySmall,
              ),

              const SizedBox(height: AppSpacing.xxl),

              _FieldLabel(label: 'NAME'),

              const SizedBox(height: AppSpacing.sm),

              TextField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'Your name',
                  hintStyle: TextStyle(
                    color: AppColors.primary.withValues(alpha: 0.35),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              _FieldLabel(label: 'EMAIL'),

              const SizedBox(height: AppSpacing.sm),

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'your@example.com',
                  hintStyle: TextStyle(
                    color: AppColors.primary.withValues(alpha: 0.35),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              _FieldLabel(label: 'PASSWORD'),

              const SizedBox(height: AppSpacing.sm),

              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: 'At least 8 characters',
                  hintStyle: TextStyle(
                    color: AppColors.secondary.withValues(alpha: 0.65),
                  ),
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
                      color: AppColors.secondary.withValues(alpha: 0.65),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

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
                      onTap: _isLoading ? null : _register,
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
                                'Create Account',
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
                      'Already have an account? ',
                      style: AppTextStyles.bodySmall,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign in',
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

class _FieldLabel extends StatelessWidget {
  final String label;

  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label, style: AppTextStyles.label);
  }
}
