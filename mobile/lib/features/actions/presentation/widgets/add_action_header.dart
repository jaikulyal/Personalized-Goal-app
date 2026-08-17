import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class AddActionHeader extends StatelessWidget {
  final String goalTitle;

  const AddActionHeader({super.key, required this.goalTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ADD ACTION',
          style: AppTextStyles.label.copyWith(
            letterSpacing: 1.4,
            color: AppColors.gold,
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        Text('Plan the next step.', style: AppTextStyles.headline),

        const SizedBox(height: AppSpacing.xs),

        Text(
          'Choose exactly when you want to work on this action.',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.muted),
        ),

        const SizedBox(height: AppSpacing.lg),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.champagneSoft,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.flag_rounded,
                color: AppColors.goldDark,
                size: 18,
              ),

              const SizedBox(width: AppSpacing.sm),

              Expanded(
                child: Text(
                  goalTitle,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
