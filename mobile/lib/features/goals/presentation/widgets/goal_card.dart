import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/goal_model.dart';

class GoalCard extends StatelessWidget {
  final GoalModel goal;
  final VoidCallback? onTap;

  const GoalCard({super.key, required this.goal, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isCompleted = goal.completed;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isCompleted ? AppColors.goldSoft : AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isCompleted
                ? AppColors.gold.withValues(alpha: 0.45)
                : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.gold.withValues(alpha: 0.18)
                        : AppColors.champagneSoft,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    goal.category.toUpperCase(),
                    style: AppTextStyles.label.copyWith(
                      fontSize: 9,
                      color: AppColors.goldDark,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  isCompleted
                      ? Icons.check_circle_rounded
                      : Icons.arrow_outward_rounded,
                  color: isCompleted ? AppColors.goldDark : AppColors.secondary,
                  size: 21,
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            Text(
              goal.title,
              style: AppTextStyles.title.copyWith(
                fontSize: 22,
                color: isCompleted ? AppColors.goldDark : AppColors.primary,
              ),
            ),

            if (goal.description.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                goal.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall,
              ),
            ],

            const SizedBox(height: AppSpacing.lg),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PROGRESS',
                  style: AppTextStyles.label.copyWith(fontSize: 9),
                ),
                Text(
                  '${(goal.progress * 100).round()}%',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isCompleted ? AppColors.goldDark : AppColors.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.sm),

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: goal.progress,
                minHeight: 5,
                backgroundColor: isCompleted
                    ? AppColors.gold.withValues(alpha: 0.15)
                    : AppColors.border,
                valueColor: AlwaysStoppedAnimation(
                  isCompleted ? AppColors.goldDark : AppColors.gold,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            Text(
              isCompleted
                  ? 'COMPLETED'
                  : '${goal.daysRemaining} days remaining',
              style: AppTextStyles.label.copyWith(
                fontSize: 9,
                color: isCompleted ? AppColors.goldDark : AppColors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
