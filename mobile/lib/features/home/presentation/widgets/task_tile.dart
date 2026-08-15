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
    this.completed = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: completed
            ? AppColors.gold.withValues(alpha: 0.10)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: completed
              ? AppColors.gold.withValues(alpha: 0.30)
              : AppColors.primary.withValues(alpha: 0.07),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: completed ? AppColors.gold : Colors.transparent,
                  border: Border.all(
                    color: completed
                        ? AppColors.gold
                        : AppColors.primary.withValues(alpha: 0.25),
                    width: 1.5,
                  ),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: completed
                      ? const Icon(
                          Icons.check_rounded,
                          key: ValueKey('completed'),
                          size: 16,
                          color: AppColors.primary,
                        )
                      : const SizedBox(key: ValueKey('incomplete')),
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  style: AppTextStyles.body.copyWith(
                    color: completed ? AppColors.muted : AppColors.primary,
                    fontWeight: completed ? FontWeight.w500 : FontWeight.w600,
                    decoration: completed ? TextDecoration.lineThrough : null,
                    decorationColor: AppColors.muted,
                  ),
                  child: Text(title),
                ),
              ),

              AnimatedOpacity(
                duration: const Duration(milliseconds: 180),
                opacity: completed ? 1 : 0,
                child: const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 18,
                  color: AppColors.goldDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
