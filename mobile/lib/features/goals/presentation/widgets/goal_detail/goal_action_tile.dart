import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../actions/data/local/action_local_model.dart';

class GoalActionTile extends StatelessWidget {
  final ActionLocalModel action;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const GoalActionTile({
    super.key,
    required this.action,
    required this.onTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: action.isCompleted
              ? AppColors.gold.withValues(alpha: 0.10)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: action.isCompleted
                ? AppColors.gold.withValues(alpha: 0.30)
                : AppColors.primary.withValues(alpha: 0.07),
          ),
        ),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Icon(
                action.isCompleted
                    ? Icons.check_circle_rounded
                    : Icons.circle_outlined,
                key: ValueKey(action.isCompleted),
                color: action.isCompleted ? AppColors.gold : AppColors.muted,
                size: 21,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    action.title,
                    style: AppTextStyles.body.copyWith(
                      color: action.isCompleted
                          ? AppColors.muted
                          : AppColors.primary,
                      decoration: action.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 12,
                        color: AppColors.muted,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        _formatActionDate(action.scheduledDate),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.muted,
                          fontSize: 11,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Icon(
                        Icons.access_time_rounded,
                        size: 12,
                        color: AppColors.muted,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        _formatActionTime(action.scheduledDate),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.muted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            GestureDetector(
              onTap: onEdit,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.champagneSoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  color: AppColors.goldDark,
                  size: 17,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatActionDate(DateTime date) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final actionDate = DateTime(date.year, date.month, date.day);

    final difference = actionDate.difference(today).inDays;

    if (difference == 0) {
      return 'Today';
    }

    if (difference == 1) {
      return 'Tomorrow';
    }

    if (difference == -1) {
      return 'Yesterday';
    }

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String _formatActionTime(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;

    final minute = date.minute.toString().padLeft(2, '0');

    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }
}
