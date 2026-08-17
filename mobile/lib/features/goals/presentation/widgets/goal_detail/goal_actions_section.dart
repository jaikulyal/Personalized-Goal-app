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
        else
          ...actions.map(
            (action) => GoalActionTile(
              action: action,
              onTap: () => onToggleAction(action),
              onEdit: () => onActionEdit(action),
            ),
          ),
      ],
    );
  }
}
