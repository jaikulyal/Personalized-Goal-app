import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../actions/data/local/action_local_model.dart';
import '../../../goals/presentation/widgets/goal_detail/goal_action_tile.dart';

class TodayActionsSection extends StatelessWidget {
  final List<ActionLocalModel> actions;
  final bool isLoading;
  final Future<void> Function(ActionLocalModel action) onActionToggled;
  final Future<void> Function(ActionLocalModel action) onActionEdit;

  const TodayActionsSection({
    super.key,
    required this.actions,
    required this.isLoading,
    required this.onActionToggled,
    required this.onActionEdit,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(AppColors.gold),
          ),
        ),
      );
    }

    final completed = actions.where((action) => action.isCompleted).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: Text('Today', style: AppTextStyles.title)),

            if (actions.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: completed == actions.length
                      ? AppColors.gold.withValues(alpha: 0.14)
                      : AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  '$completed of ${actions.length} complete',
                  style: AppTextStyles.label.copyWith(
                    color: completed == actions.length
                        ? AppColors.goldDark
                        : AppColors.muted,
                    fontSize: 9,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        if (actions.isEmpty)
          _buildEmptyState()
        else
          ...actions.map(
            (action) => GoalActionTile(
              action: action,
              onTap: () => onActionToggled(action),
              onEdit: () => onActionEdit(action),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.07)),
      ),
      child: Column(
        children: [
          const Icon(Icons.task_alt_rounded, color: AppColors.gold, size: 28),

          const SizedBox(height: AppSpacing.sm),

          const Text(
            'No actions scheduled for today',
            style: AppTextStyles.title,
          ),

          const SizedBox(height: 4),

          Text(
            'Your scheduled actions will appear here.',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.muted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
