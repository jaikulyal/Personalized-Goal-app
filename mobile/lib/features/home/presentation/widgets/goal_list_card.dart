import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class GoalListCard extends StatelessWidget {
  final String title;
  final String category;
  final double progress;
  final bool isCompleted;
  final VoidCallback? onTap;

  const GoalListCard({
    super.key,
    required this.title,
    required this.category,
    required this.progress,
    required this.isCompleted,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).round();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isCompleted
                ? AppColors.gold.withValues(alpha: 0.10)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isCompleted
                  ? AppColors.gold.withValues(alpha: 0.35)
                  : AppColors.primary.withValues(alpha: 0.07),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? AppColors.gold : AppColors.champagneSoft,
                ),
                child: Icon(
                  isCompleted
                      ? Icons.check_rounded
                      : Icons.track_changes_rounded,
                  size: 20,
                  color: isCompleted ? AppColors.primary : AppColors.goldDark,
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      category.toUpperCase(),
                      style: AppTextStyles.label.copyWith(
                        fontSize: 9,
                        letterSpacing: 1,
                        color: AppColors.goldDark,
                      ),
                    ),

                    const SizedBox(height: 9),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        minHeight: 4,
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.07,
                        ),
                        valueColor: AlwaysStoppedAnimation(
                          isCompleted ? AppColors.gold : AppColors.goldDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$percentage%',
                    style: TextStyle(
                      color: isCompleted
                          ? AppColors.goldDark
                          : AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.muted,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
