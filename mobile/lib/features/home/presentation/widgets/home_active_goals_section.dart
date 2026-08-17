import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../goals/data/local/goal_local_model.dart';
import 'active_goal_card.dart';

class HomeActiveGoalsSection extends StatelessWidget {
  final List<GoalLocalModel> goals;
  final int Function(GoalLocalModel goal) daysRemaining;
  final void Function(GoalLocalModel goal) onGoalTap;

  const HomeActiveGoalsSection({
    super.key,
    required this.goals,
    required this.daysRemaining,
    required this.onGoalTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeGoals = goals.where((goal) => !goal.isCompleted).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Active goals', style: AppTextStyles.title),

            const Spacer(),

            Text(
              'View all',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.goldDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        if (activeGoals.isEmpty)
          Text(
            'No active goals yet.',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.muted),
          )
        else
          ...activeGoals
              .take(3)
              .map(
                (goal) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: GestureDetector(
                    onTap: () => onGoalTap(goal),
                    child: ActiveGoalCard(
                      title: goal.title,
                      category: goal.category,
                      progress: goal.progress,
                      daysRemaining: daysRemaining(goal),
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
