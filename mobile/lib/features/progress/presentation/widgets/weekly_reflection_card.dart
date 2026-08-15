import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class WeeklyReflectionCard extends StatelessWidget {
  const WeeklyReflectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: AppColors.champagneSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.edit_note_rounded,
                  color: AppColors.goldDark,
                  size: 19,
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Weekly reflection', style: AppTextStyles.title),
                    const SizedBox(height: 3),
                    Text(
                      'Take a moment to look back.',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          _ReflectionPrompt(
            icon: Icons.check_circle_outline_rounded,
            text: 'What went well this week?',
          ),

          const SizedBox(height: AppSpacing.sm),

          _ReflectionPrompt(
            icon: Icons.help_outline_rounded,
            text: 'What made things difficult?',
          ),

          const SizedBox(height: AppSpacing.sm),

          _ReflectionPrompt(
            icon: Icons.arrow_forward_rounded,
            text: 'What would you like to improve?',
          ),
        ],
      ),
    );
  }
}

class _ReflectionPrompt extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ReflectionPrompt({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 17, color: AppColors.goldDark),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: AppColors.muted,
          ),
        ],
      ),
    );
  }
}
