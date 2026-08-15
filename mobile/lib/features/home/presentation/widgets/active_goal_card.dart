import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class ActiveGoalCard extends StatelessWidget {
  final String title;
  final String category;
  final double progress;
  final int daysRemaining;

  const ActiveGoalCard({
    super.key,
    required this.title,
    required this.category,
    required this.progress,
    required this.daysRemaining,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TOP ROW
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.champagneSoft,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  category.toUpperCase(),
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.goldDark,
                    fontSize: 9,
                    letterSpacing: 0.9,
                  ),
                ),
              ),

              const Spacer(),

              Icon(Icons.more_horiz_rounded, color: AppColors.muted, size: 20),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // TITLE
          Text(
            title,
            style: AppTextStyles.title.copyWith(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // PROGRESS
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      Container(
                        height: 5,
                        color: AppColors.primary.withValues(alpha: 0.08),
                      ),
                      FractionallySizedBox(
                        widthFactor: progress.clamp(0.0, 1.0),
                        child: Container(
                          height: 5,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF80681F),
                                AppColors.gold,
                                Color(0xFFFFE58A),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Text(
                '$percentage%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // FOOTER
          Row(
            children: [
              Icon(Icons.schedule_rounded, size: 14, color: AppColors.muted),
              const SizedBox(width: 5),
              Text(
                '$daysRemaining days remaining',
                style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
