import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

class GoalEmptyActions extends StatelessWidget {
  final VoidCallback onAddAction;

  const GoalEmptyActions({super.key, required this.onAddAction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAddAction,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.07)),
        ),
        child: Column(
          children: [
            const Icon(Icons.add_task_rounded, color: AppColors.gold, size: 30),

            const SizedBox(height: AppSpacing.sm),

            Text('Add an action', style: AppTextStyles.title),

            const SizedBox(height: 4),

            Text(
              'Add an action to start tracking this goal.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.muted),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.md),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded, color: AppColors.surface, size: 17),

                  SizedBox(width: 6),

                  Text(
                    'Add Action',
                    style: TextStyle(
                      color: AppColors.surface,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
