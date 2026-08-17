import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../actions/data/local/action_local_model.dart';
import 'goal_action_tile.dart';
import 'goal_empty_actions.dart';

class GoalActionsSection extends StatelessWidget {
  final List<ActionLocalModel> actions;
  final bool isLoading;
  final VoidCallback onAddAction;
  final ValueChanged<ActionLocalModel> onToggleAction;
  final Future<void> Function(ActionLocalModel action) onActionEdit;
  const GoalActionsSection({
    super.key,
    required this.actions,
    required this.isLoading,
    required this.onAddAction,
    required this.onToggleAction,
    required this.onActionEdit,
  });

  @override
  Widget build(BuildContext context) {
    final completed = actions.where((action) => action.isCompleted).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: Text('Actions', style: AppTextStyles.title)),

            if (!isLoading)
              Text(
                '${actions.isEmpty ? 0 : completed}/${actions.length}',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.muted),
              ),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        if (isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(AppColors.gold),
              ),
            ),
          )
        else if (actions.isEmpty)
          GoalEmptyActions(onAddAction: onAddAction)
        else ...[
          ...actions.map(
            (action) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: GoalActionTile(
                action: action,
                onTap: () => onToggleAction(action),
                onEdit: () => onActionEdit(action),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          _AddActionButton(onPressed: onAddAction),
        ],
      ],
    );
  }
}

class _AddActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddActionButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        splashColor: AppColors.gold.withValues(alpha: 0.08),
        highlightColor: AppColors.gold.withValues(alpha: 0.04),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 15,
          ),
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.28)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_rounded,
                  size: 19,
                  color: AppColors.goldDark,
                ),
              ),

              const SizedBox(width: AppSpacing.sm),

              Text(
                'Add another action',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
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
