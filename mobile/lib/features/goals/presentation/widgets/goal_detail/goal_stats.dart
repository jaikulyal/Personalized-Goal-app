import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

class GoalStats extends StatelessWidget {
  final int completedActions;
  final int totalActions;
  final int daysRemaining;
  final double progress;

  const GoalStats({
    super.key,
    required this.completedActions,
    required this.totalActions,
    required this.daysRemaining,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final status = progress >= 1.0 ? 'DONE' : 'ACTIVE';

    return Row(
      children: [
        Expanded(
          child: _StatItem(
            label: 'ACTIONS',
            value: '$completedActions/$totalActions',
          ),
        ),

        const SizedBox(width: AppSpacing.sm),

        Expanded(
          child: _StatItem(label: 'DEADLINE', value: '$daysRemaining DAYS'),
        ),

        const SizedBox(width: AppSpacing.sm),

        Expanded(
          child: _StatItem(label: 'STATUS', value: status),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.label.copyWith(fontSize: 8, letterSpacing: 1),
          ),

          const SizedBox(height: 7),

          Text(
            value,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
