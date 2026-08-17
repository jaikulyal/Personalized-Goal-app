import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'focus_goal_card.dart';

class HomeFocusGoalSection extends StatelessWidget {
  final String title;
  final double progress;
  final int daysRemaining;
  final VoidCallback onTap;

  const HomeFocusGoalSection({
    super.key,
    required this.title,
    required this.progress,
    required this.daysRemaining,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Focus goal', style: AppTextStyles.title),
            const Spacer(),
            Text(
              'Your priority',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.muted),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        FocusGoalCard(
          title: title,
          progress: progress,
          daysRemaining: daysRemaining,
          onTap: onTap,
        ),
      ],
    );
  }
}
