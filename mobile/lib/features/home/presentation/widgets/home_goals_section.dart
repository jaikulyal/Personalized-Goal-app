import 'package:flutter/material.dart';

//import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../goals/data/local/goal_local_model.dart';
import 'goal_list_card.dart';

class HomeGoalsSection extends StatelessWidget {
  final List<GoalLocalModel> goals;
  final int Function(GoalLocalModel goal) daysRemaining;
  final void Function(GoalLocalModel goal) onGoalTap;

  const HomeGoalsSection({
    super.key,
    required this.goals,
    required this.daysRemaining,
    required this.onGoalTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('My Goals', style: AppTextStyles.title),
            Text('${goals.length}', style: AppTextStyles.bodySmall),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        ...goals.map(
          (goal) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: GoalListCard(
              title: goal.title,
              category: goal.category,
              progress: goal.progress,
              isCompleted: goal.isCompleted,
              onTap: () => onGoalTap(goal),
            ),
          ),
        ),
      ],
    );
  }
}
