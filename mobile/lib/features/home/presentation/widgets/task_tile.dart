import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class TaskTile extends StatelessWidget {
  final String title;
  final bool completed;
  final VoidCallback? onTap;

  const TaskTile({
    super.key,
    required this.title,
    required this.completed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: completed ? AppColors.goldSoft : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: completed
                ? AppColors.gold.withValues(alpha: 0.35)
                : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: completed ? AppColors.gold : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: completed ? AppColors.gold : AppColors.secondary,
                  width: 1.5,
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

            const SizedBox(width: AppSpacing.md),

            Expanded(
              child: Text(
                title,
                style: AppTextStyles.body.copyWith(
                  color: completed ? AppColors.goldDark : AppColors.primary,
                  decoration: completed ? TextDecoration.lineThrough : null,
                ),
              ),
            ),

            if (completed)
              Text(
                'DONE',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.goldDark,
                  fontSize: 10,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
