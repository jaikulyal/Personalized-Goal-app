import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/progress_models.dart';
import '../widgets/weekly_reflection_card.dart';

class ProgressStatusCard extends StatelessWidget {
  final GoalProgressSummary summary;

  const ProgressStatusCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final style = _statusStyle(summary.status);

    //weekly refelection card.

    const WeeklyReflectionCard();
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
                child: Text(
                  summary.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.title,
                ),
              ),

              const SizedBox(width: AppSpacing.sm),

              _StatusBadge(
                label: _statusLabel(summary.status),
                icon: style.icon,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          Row(
            children: [
              Expanded(
                child: _ProgressMetric(
                  label: 'ACTUAL',
                  value: '${_percentage(summary.progress)}%',
                ),
              ),

              Container(width: 1, height: 38, color: AppColors.border),

              Expanded(
                child: _ProgressMetric(
                  label: 'EXPECTED',
                  value: '${_percentage(summary.expectedProgress)}%',
                ),
              ),

              Container(width: 1, height: 38, color: AppColors.border),

              Expanded(
                child: _ProgressMetric(
                  label: 'ACTIONS',
                  value:
                      '${summary.completedActions}/${summary.plannedActions}',
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: summary.progress.clamp(0.0, 1.0),
              minHeight: 5,
              backgroundColor: AppColors.background,
              valueColor: AlwaysStoppedAnimation(style.progressColor),
            ),
          ),

          if (summary.missedActions > 0) ...[
            const SizedBox(height: AppSpacing.sm),

            Row(
              children: [
                Icon(
                  Icons.remove_circle_outline_rounded,
                  size: 14,
                  color: style.progressColor,
                ),
                const SizedBox(width: 5),
                Text(
                  '${summary.missedActions} missed action'
                  '${summary.missedActions == 1 ? '' : 's'}',
                  style: AppTextStyles.label.copyWith(
                    color: style.progressColor,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  int _percentage(double value) {
    return (value.clamp(0.0, 1.0) * 100).round();
  }

  String _statusLabel(GoalProgressStatus status) {
    switch (status) {
      case GoalProgressStatus.ahead:
        return 'Ahead';

      case GoalProgressStatus.onTrack:
        return 'On Track';

      case GoalProgressStatus.needsAttention:
        return 'Needs Attention';

      case GoalProgressStatus.behind:
        return 'Behind';

      case GoalProgressStatus.completed:
        return 'Completed';
    }
  }

  _StatusStyle _statusStyle(GoalProgressStatus status) {
    switch (status) {
      case GoalProgressStatus.completed:
        return const _StatusStyle(
          icon: Icons.check_circle_rounded,
          progressColor: AppColors.gold,
        );

      case GoalProgressStatus.ahead:
        return const _StatusStyle(
          icon: Icons.trending_up_rounded,
          progressColor: AppColors.gold,
        );

      case GoalProgressStatus.onTrack:
        return const _StatusStyle(
          icon: Icons.radio_button_checked_rounded,
          progressColor: AppColors.gold,
        );

      case GoalProgressStatus.needsAttention:
        return const _StatusStyle(
          icon: Icons.info_outline_rounded,
          progressColor: AppColors.goldDark,
        );

      case GoalProgressStatus.behind:
        return const _StatusStyle(
          icon: Icons.trending_down_rounded,
          progressColor: AppColors.goldDark,
        );
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final IconData icon;

  const _StatusBadge({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.champagneSoft,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.goldDark),
          const SizedBox(width: 5),
          Text(
            label.toUpperCase(),
            style: AppTextStyles.label.copyWith(
              color: AppColors.goldDark,
              fontSize: 8,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressMetric extends StatelessWidget {
  final String label;
  final String value;

  const _ProgressMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: AppColors.muted,
            fontSize: 8,
            letterSpacing: 0.9,
          ),
        ),
      ],
    );
  }
}

class _StatusStyle {
  final IconData icon;
  final Color progressColor;

  const _StatusStyle({required this.icon, required this.progressColor});
}
