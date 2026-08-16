import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../actions/data/datasources/actions_local_datasource.dart';
import '../../../actions/data/local/action_local_model.dart';
import '../../data/datasources/goals_local_datasource.dart';
import '../../data/local/goal_local_model.dart';
import '../../../actions/presentation/screens/add_action_screen.dart';

class GoalDetailScreen extends StatefulWidget {
  final String goalId;
  final String title;
  final String category;
  final double progress;
  final int daysRemaining;

  const GoalDetailScreen({
    super.key,
    required this.goalId,
    required this.title,
    required this.category,
    required this.progress,
    required this.daysRemaining,
  });

  @override
  State<GoalDetailScreen> createState() => _GoalDetailScreenState();
}

class _GoalDetailScreenState extends State<GoalDetailScreen> {
  late double _progress;

  final GoalsLocalDataSource _goalsDataSource = GoalsLocalDataSource();
  final ActionsLocalDataSource _actionsDataSource = ActionsLocalDataSource();

  List<ActionLocalModel> _actions = [];
  bool _isLoadingActions = true;

  @override
  void initState() {
    super.initState();

    _progress = widget.progress.clamp(0.0, 1.0);

    _loadActions();
  }

  Future<void> _loadActions() async {
    if (mounted) {
      setState(() {
        _isLoadingActions = true;
      });
    }

    try {
      final actions = await _actionsDataSource.getActionsForGoal(widget.goalId);

      if (!mounted) return;

      setState(() {
        _actions = actions;
        _isLoadingActions = false;
      });

      await _syncProgressFromActions();
    } catch (error) {
      debugPrint('Action loading error: $error');

      if (!mounted) return;

      setState(() {
        _isLoadingActions = false;
      });
    }
  }

  //OPEN ACTION SCREEN METHOD-

  Future<void> _openAddActionScreen() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            AddActionScreen(goalId: widget.goalId, goalTitle: widget.title),
      ),
    );

    if (result == true && mounted) {
      await _loadActions();
      setState(() {});
    }
  }

  Future<void> _toggleAction(ActionLocalModel action) async {
    try {
      final updatedAction = await _actionsDataSource.toggleAction(action.id);

      if (updatedAction == null) {
        return;
      }

      if (!mounted) return;

      setState(() {
        final index = _actions.indexWhere(
          (item) => item.id == updatedAction.id,
        );

        if (index != -1) {
          _actions[index] = updatedAction;
        }
      });

      await _syncProgressFromActions();
    } catch (error) {
      debugPrint('Action toggle error: $error');
    }
  }

  Future<void> _syncProgressFromActions() async {
    if (_actions.isEmpty) {
      return;
    }

    final completed = _actions.where((action) => action.isCompleted).length;

    final calculatedProgress = (completed / _actions.length).clamp(0.0, 1.0);

    if (mounted) {
      setState(() {
        _progress = calculatedProgress;
      });
    }

    final goal = await _goalsDataSource.getGoalById(widget.goalId);

    if (goal == null) {
      return;
    }

    final updatedGoal = GoalLocalModel(
      id: goal.id,
      title: goal.title,
      category: goal.category,
      description: goal.description,
      startDate: goal.startDate,
      targetDate: goal.targetDate,
      progress: calculatedProgress,
      isCompleted: calculatedProgress >= 1.0,
      createdAt: goal.createdAt,
      updatedAt: DateTime.now(),
    );

    await _goalsDataSource.updateGoal(updatedGoal);
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (_progress * 100).round();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.md,
                AppSpacing.screen,
                40,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildTopBar(context),

                  const SizedBox(height: AppSpacing.xxl),

                  _buildGoalHeader(),

                  const SizedBox(height: AppSpacing.xxl),

                  _buildProgressSection(percentage),

                  const SizedBox(height: AppSpacing.xxl),

                  _buildStats(),

                  const SizedBox(height: AppSpacing.xxl),

                  _buildMilestones(),

                  const SizedBox(height: AppSpacing.xxl),

                  _buildTasks(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(true),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.08),
              ),
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ),

        const Spacer(),

        Text('GOAL', style: AppTextStyles.label.copyWith(letterSpacing: 1.5)),

        const Spacer(),

        GestureDetector(
          onTap: () {
            // Edit goal will be connected next.
          },
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.08),
              ),
            ),
            child: const Icon(
              Icons.more_horiz_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.champagneSoft,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            widget.category.toUpperCase(),
            style: AppTextStyles.label.copyWith(
              color: AppColors.goldDark,
              fontSize: 9,
              letterSpacing: 1,
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        Text(
          widget.title,
          style: AppTextStyles.display.copyWith(
            fontSize: 38,
            height: 1.05,
            letterSpacing: -1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(int percentage) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 105,
            height: 105,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 105,
                  height: 105,
                  child: CircularProgressIndicator(
                    value: _progress.clamp(0.0, 1.0),
                    strokeWidth: 8,
                    backgroundColor: AppColors.surface.withValues(alpha: 0.10),
                    valueColor: const AlwaysStoppedAnimation(AppColors.gold),
                  ),
                ),
                Text(
                  '$percentage%',
                  style: const TextStyle(
                    color: AppColors.surface,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.lg),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progress',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.muted,
                    fontSize: 10,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  percentage == 100 ? 'Goal completed' : 'Keep going.',
                  style: const TextStyle(
                    color: AppColors.surface,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '${widget.daysRemaining} days remaining',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    final completed = _actions.where((action) => action.isCompleted).length;

    final total = _actions.length;

    final status = _progress >= 1.0 ? 'DONE' : 'ACTIVE';

    return Row(
      children: [
        Expanded(child: _statItem('ACTIONS', '$completed/$total')),

        const SizedBox(width: AppSpacing.sm),

        Expanded(child: _statItem('DEADLINE', '${widget.daysRemaining} DAYS')),

        const SizedBox(width: AppSpacing.sm),

        Expanded(child: _statItem('STATUS', status)),
      ],
    );
  }

  Widget _statItem(String label, String value) {
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

  Widget _buildMilestones() {
    final progress = _progress;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Milestones', style: AppTextStyles.title),

        const SizedBox(height: AppSpacing.md),

        _milestone('Define the goal', true),

        _milestone('Complete first milestone', progress >= 0.25),

        _milestone('Reach 75% progress', progress >= 0.75),

        _milestone('Complete the goal', progress >= 1.0),
      ],
    );
  }

  Widget _milestone(String title, bool completed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: completed ? AppColors.gold : AppColors.surface,
              border: Border.all(
                color: completed
                    ? AppColors.gold
                    : AppColors.primary.withValues(alpha: 0.15),
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

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style: AppTextStyles.body.copyWith(
                color: completed ? AppColors.muted : AppColors.primary,
                decoration: completed ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasks() {
    final completed = _actions.where((action) => action.isCompleted).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: Text('Actions', style: AppTextStyles.title)),

            if (!_isLoadingActions)
              Text(
                '${_actions.isEmpty ? 0 : completed}/${_actions.length}',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.muted),
              ),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        if (_isLoadingActions)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(AppColors.gold),
              ),
            ),
          )
        else if (_actions.isEmpty)
          _buildEmptyActions()
        else
          ..._actions.map(_buildActionTile),
      ],
    );
  }

  Widget _buildEmptyActions() {
    return GestureDetector(
      onTap: _openAddActionScreen,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.07)),
        ),
        child: Column(
          children: [
            const Icon(Icons.add_task_rounded, color: AppColors.gold, size: 30),

            const SizedBox(height: AppSpacing.sm),

            Text('Add an action', style: AppTextStyles.title),

            const SizedBox(height: 4),

            Text(
              'Add an action to start tracking this goal.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.muted),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.md),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded, color: AppColors.surface, size: 17),
                  SizedBox(width: 6),
                  Text(
                    'Add Action',
                    style: TextStyle(
                      color: AppColors.surface,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(ActionLocalModel action) {
    return GestureDetector(
      onTap: () => _toggleAction(action),
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

                  const SizedBox(height: 3),

                  Text(
                    _formatActionDate(action.scheduledDate),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.muted,
                      fontSize: 11,
                    ),
                  ),
                ],
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
}
