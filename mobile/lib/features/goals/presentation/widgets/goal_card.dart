import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../../data/local/goal_local_model.dart';

class GoalCard extends StatelessWidget {
  final GoalLocalModel goal;
  final VoidCallback? onTap;

  const GoalCard({super.key, required this.goal, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isCompleted = goal.progress >= 1.0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _ProgressRing(
              progress: goal.progress.clamp(0.0, 1.0),
              isCompleted: isCompleted,
            ),

            const SizedBox(width: AppSpacing.lg),

            Expanded(child: _buildGoalContent(isCompleted)),

            const SizedBox(width: AppSpacing.sm),

            Icon(
              isCompleted
                  ? Icons.check_circle_rounded
                  : Icons.arrow_forward_ios_rounded,
              color: isCompleted ? AppColors.goldDark : AppColors.muted,
              size: isCompleted ? 21 : 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalContent(bool isCompleted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isCompleted
                ? AppColors.gold.withValues(alpha: 0.18)
                : AppColors.champagneSoft,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            goal.category.toUpperCase(),
            style: AppTextStyles.label.copyWith(
              fontSize: 8.5,
              color: AppColors.goldDark,
              letterSpacing: 0.8,
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        Text(
          goal.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.title.copyWith(
            fontSize: 20,
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

        const SizedBox(height: AppSpacing.sm),

        Text(
          isCompleted ? 'COMPLETED' : '${_daysRemaining(goal)} days remaining',
          style: AppTextStyles.label.copyWith(
            fontSize: 9,
            color: isCompleted ? AppColors.goldDark : AppColors.secondary,
          ),
        ),
      ],
    );
  }

  int _daysRemaining(GoalLocalModel goal) {
    if (goal.targetDate == null) {
      return 0;
    }

    final difference = goal.targetDate!.difference(DateTime.now()).inDays;

    return difference < 0 ? 0 : difference;
  }
}

class _ProgressRing extends StatelessWidget {
  final double progress;
  final bool isCompleted;

  const _ProgressRing({required this.progress, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).round();

    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 5,
              valueColor: AlwaysStoppedAnimation(
                isCompleted
                    ? AppColors.gold.withValues(alpha: 0.18)
                    : AppColors.border,
              ),
            ),
          ),

          SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 5,
              strokeCap: StrokeCap.round,
              valueColor: AlwaysStoppedAnimation(
                isCompleted ? AppColors.goldDark : AppColors.gold,
              ),
              backgroundColor: Colors.transparent,
            ),
          ),

          Text(
            '$percentage%',
            style: AppTextStyles.label.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: isCompleted ? AppColors.goldDark : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
