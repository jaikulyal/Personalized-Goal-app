import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class WeeklyProgressCard extends StatelessWidget {
  final int completedActions;
  final int plannedActions;

  const WeeklyProgressCard({
    super.key,
    required this.completedActions,
    required this.plannedActions,
  });

  @override
  Widget build(BuildContext context) {
    final progress = plannedActions == 0
        ? 0.0
        : (completedActions / plannedActions).clamp(0.0, 1.0);

    final percentage = (progress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.16),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
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
                  color: AppColors.champagneSoft,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  'THIS WEEK',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.goldDark,
                    fontSize: 10,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '$percentage%',
                style: const TextStyle(
                  color: AppColors.gold,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$completedActions',
                style: const TextStyle(
                  color: AppColors.surface,
                  fontSize: 48,
                  height: 0.95,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6, bottom: 4),
                child: Text(
                  '/ $plannedActions',
                  style: TextStyle(
                    color: AppColors.muted.withValues(alpha: 0.9),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xs),

          Text(
            'planned actions completed',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.muted),
          ),

          const SizedBox(height: AppSpacing.lg),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: const Color(0xFF393835),
              valueColor: const AlwaysStoppedAnimation(AppColors.gold),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'WEEKLY MOMENTUM',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.muted,
                  fontSize: 9,
                  letterSpacing: 1.1,
                ),
              ),
              Text(
                '$completedActions of $plannedActions',
                style: const TextStyle(
                  color: AppColors.surface,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
