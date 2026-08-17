import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../actions/data/datasources/actions_local_datasource.dart';
import '../../../actions/data/local/action_local_model.dart';
import '../../../actions/presentation/screens/add_action_screen.dart';
import '../../data/datasources/goals_local_datasource.dart';
import '../../data/local/goal_local_model.dart';
import '../widgets/goal_detail/goal_actions_section.dart';
import '../widgets/goal_detail/goal_header.dart';
import '../widgets/goal_detail/goal_milestones.dart';
import '../widgets/goal_detail/goal_progress_card.dart';
import '../widgets/goal_detail/goal_stats.dart';
import '../widgets/goal_detail/goal_top_bar.dart';
import '../../../actions/presentation/screens/edit_action_screen.dart';

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

  Future<void> _openAddActionScreen() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            AddActionScreen(goalId: widget.goalId, goalTitle: widget.title),
      ),
    );

    if (result == true && mounted) {
      await _loadActions();
    }
  }

  Future<void> _openEditAction(ActionLocalModel action) async {
    final goal = await _goalsDataSource.getGoalById(widget.goalId);

    if (!mounted) return;

    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => EditActionScreen(
          action: action,
          goalTitle: goal?.title ?? widget.title,
        ),
      ),
    );

    if (updated == true) {
      await _loadActions();
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
                  GoalTopBar(
                    onBack: () {
                      Navigator.of(context).pop(true);
                    },
                    onMore: () {
                      // Edit goal will be connected next.
                    },
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  GoalHeader(title: widget.title, category: widget.category),

                  const SizedBox(height: AppSpacing.xxl),

                  GoalProgressCard(
                    progress: _progress,
                    daysRemaining: widget.daysRemaining,
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  GoalStats(
                    completedActions: _actions
                        .where((action) => action.isCompleted)
                        .length,
                    totalActions: _actions.length,
                    daysRemaining: widget.daysRemaining,
                    progress: _progress,
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  GoalMilestones(progress: _progress),

                  const SizedBox(height: AppSpacing.xxl),

                  GoalActionsSection(
                    actions: _actions,
                    isLoading: _isLoadingActions,
                    onAddAction: _openAddActionScreen,
                    onToggleAction: _toggleAction,
                    onActionEdit: _openEditAction,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
