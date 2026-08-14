import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class FocusGoalCard extends StatelessWidget {
  final String title;
  final double progress;
  final int daysRemaining;

  const FocusGoalCard({
    super.key,
    required this.title,
    required this.progress,
    required this.daysRemaining,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
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
                  'FOCUS GOAL',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.goldDark,
                    fontSize: 10,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_outward_rounded,
                color: AppColors.surface,
                size: 20,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          Text(
            title,
            style: const TextStyle(
              color: AppColors.surface,
              fontSize: 30,
              height: 1.05,
              fontWeight: FontWeight.w600,
              letterSpacing: -1,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PROGRESS',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.muted,
                  fontSize: 10,
                ),
              ),
              Text(
                '$percentage%',
                style: const TextStyle(
                  color: AppColors.surface,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: const Color(0xFF393835),
              valueColor: const AlwaysStoppedAnimation(AppColors.champagne),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          Text(
            '$daysRemaining days remaining',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
