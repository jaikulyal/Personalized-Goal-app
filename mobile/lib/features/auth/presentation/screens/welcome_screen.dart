import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),

              _BrandMark(),

              const SizedBox(height: AppSpacing.xxl),

              RichText(
                text: TextSpan(
                  style: AppTextStyles.display,
                  children: [
                    TextSpan(
                      text: 'Build',
                      style: AppTextStyles.display.copyWith(
                        color: AppColors.gold,
                      ),
                    ),
                    const TextSpan(text: ' something\nworth '),
                    TextSpan(
                      text: 'finishing.',
                      style: AppTextStyles.display.copyWith(
                        color: AppColors.gold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              Text(
                'Turn your intentions into meaningful progress '
                'one focused step at a time.',
                style: AppTextStyles.body.copyWith(color: AppColors.secondary),
              ),

              const Spacer(),

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
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Center(
                        child: Text(
                          'Get Started',
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

              const SizedBox(height: AppSpacing.sm),

              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: const Text('I already have an account'),
                ),
              ),

              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.north_east_rounded,
            color: AppColors.gold,
            size: 18,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        const Text(
          'GOAL',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
