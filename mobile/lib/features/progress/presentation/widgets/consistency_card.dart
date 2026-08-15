import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class ConsistencyCard extends StatelessWidget {
  final int currentDays;
  final int weeklyCompleted;
  final int weeklyPlanned;
  final double monthlyPercentage;

  const ConsistencyCard({
    super.key,
    required this.currentDays,
    required this.weeklyCompleted,
    required this.weeklyPlanned,
    required this.monthlyPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final weeklyProgress = weeklyPlanned == 0
        ? 0.0
        : (weeklyCompleted / weeklyPlanned).clamp(0.0, 1.0);

    final monthly = (monthlyPercentage * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'CONSISTENCY',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.goldDark,
                  letterSpacing: 1.2,
                  fontSize: 10,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.auto_graph_rounded,
                size: 19,
                color: AppColors.goldDark,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          Row(
            children: [
              Expanded(
                child: _Metric(
                  value: '$currentDays',
                  label: currentDays == 1 ? 'current day' : 'current days',
                ),
              ),
              _VerticalDivider(),
              Expanded(
                child: _Metric(
                  value: '$weeklyCompleted / $weeklyPlanned',
                  label: 'this week',
                ),
              ),
              _VerticalDivider(),
              Expanded(
                child: _Metric(value: '$monthly%', label: 'monthly'),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: weeklyProgress,
              minHeight: 4,
              backgroundColor: AppColors.background,
              valueColor: const AlwaysStoppedAnimation(AppColors.gold),
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          Text(
            _buildMessage(),
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.muted),
          ),
        ],
      ),
    );
  }

  String _buildMessage() {
    if (weeklyPlanned == 0) {
      return 'Consistency becomes visible as you complete planned actions.';
    }

    if (weeklyCompleted == weeklyPlanned) {
      return 'You are maintaining your planned rhythm this week.';
    }

    if (weeklyCompleted >= weeklyPlanned * 0.75) {
      return 'Your consistency is holding strong this week.';
    }

    if (weeklyCompleted > 0) {
      return 'A few more completed actions will strengthen your rhythm.';
    }

    return 'Start with one planned action today.';
  }
}

class _Metric extends StatelessWidget {
  final String value;
  final String label;

  const _Metric({required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 21,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.label.copyWith(
              color: AppColors.muted,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 42,
      color: AppColors.border,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
