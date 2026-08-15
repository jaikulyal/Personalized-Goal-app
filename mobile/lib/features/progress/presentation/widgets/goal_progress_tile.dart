import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/progress_models.dart';

class GoalProgressTile extends StatelessWidget {
  final GoalProgressSummary summary;

  const GoalProgressTile({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final percentage = (summary.progress.clamp(0.0, 1.0) * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      summary.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.title,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      summary.category,
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.goldDark,
                        fontSize: 9,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              Text(
                '$percentage%',
                style: const TextStyle(
                  color: AppColors.goldDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: summary.progress.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: AppColors.background,
              valueColor: const AlwaysStoppedAnimation(AppColors.gold),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${summary.completedActions} of '
                '${summary.plannedActions} actions completed',
                style: AppTextStyles.bodySmall,
              ),

              if (summary.missedActions > 0)
                Text(
                  '${summary.missedActions} missed',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.goldDark,
                    fontSize: 9,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
