import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

class GoalMilestones extends StatelessWidget {
  final double progress;

  const GoalMilestones({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Milestones', style: AppTextStyles.title),

        const SizedBox(height: AppSpacing.md),

        _Milestone(title: 'Define the goal', completed: true),

        _Milestone(
          title: 'Complete first milestone',
          completed: progress >= 0.25,
        ),

        _Milestone(title: 'Reach 75% progress', completed: progress >= 0.75),

        _Milestone(title: 'Complete the goal', completed: progress >= 1.0),
      ],
    );
  }
}

class _Milestone extends StatelessWidget {
  final String title;
  final bool completed;

  const _Milestone({required this.title, required this.completed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: completed ? AppColors.gold : AppColors.surface,
              border: Border.all(
                color: completed
                    ? AppColors.gold
                    : AppColors.primary.withValues(alpha: 0.15),
              ),
            ),
            child: completed
                ? const Icon(
                    Icons.check_rounded,
                    size: 16,
                    color: AppColors.primary,
                  )
                : null,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style: AppTextStyles.body.copyWith(
                color: completed ? AppColors.muted : AppColors.primary,
                decoration: completed ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
