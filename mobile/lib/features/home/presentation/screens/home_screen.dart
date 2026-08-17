import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';

import '../../../goals/data/datasources/goals_local_datasource.dart';
import '../../../goals/data/local/goal_local_model.dart';
//import '../../../goals/presentation/screens/create_goal_screen.dart';
import '../../../goals/presentation/screens/goal_detail_screen.dart';

import '../widgets/home_active_goals_section.dart';
import '../widgets/home_focus_goal_section.dart';
import '../widgets/home_goals_section.dart';
import '../widgets/home_header.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../../../actions/data/datasources/actions_local_datasource.dart';
import '../../../actions/data/local/action_local_model.dart';
import '../widgets/today_actions_section.dart';
import '../../../actions/presentation/screens/edit_action_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  //int _currentIndex = 0;

  List<GoalLocalModel> _goals = [];
  bool _isLoadingGoals = true;

  final GoalsLocalDataSource _localDataSource = GoalsLocalDataSource();

  final ActionsLocalDataSource _actionsDataSource = ActionsLocalDataSource();

  List<ActionLocalModel> _todayActions = [];
  bool _isLoadingTodayActions = true;

  Future<void> _loadTodayActions() async {
    try {
      final actions = await _actionsDataSource.getActions();

      final now = DateTime.now();

      final today = DateTime(now.year, now.month, now.day);

      final tomorrow = today.add(const Duration(days: 1));

      final todayActions = actions.where((action) {
        final date = action.scheduledDate;

        return !date.isBefore(today) && date.isBefore(tomorrow);
      }).toList();

      if (!mounted) return;

      setState(() {
        _todayActions = todayActions;
        _isLoadingTodayActions = false;
      });
    } catch (error) {
      debugPrint('Today actions loading error: $error');

      if (!mounted) return;

      setState(() {
        _isLoadingTodayActions = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    refreshHome();
    //_loadTodayActions();
  }

  Future<void> refreshHome() async {
    if (mounted) {
      setState(() {
        _isLoadingGoals = true;
        _isLoadingTodayActions = true;
      });
    }

    try {
      final goals = await _localDataSource.getGoals();

      debugPrint('GOALS LOADED: ${goals.length}');

      for (final goal in goals) {
        debugPrint('GOAL: ${goal.title} | progress: ${goal.progress}');
      }

      final actions = await _actionsDataSource.getActions();

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));

      final todayActions = actions.where((action) {
        final date = action.scheduledDate;

        return !date.isBefore(today) && date.isBefore(tomorrow);
      }).toList();

      if (!mounted) return;

      setState(() {
        _goals = goals;
        _todayActions = todayActions;
        _isLoadingGoals = false;
        _isLoadingTodayActions = false;
      });
    } catch (error) {
      debugPrint('HOME REFRESH ERROR: $error');

      if (!mounted) return;

      setState(() {
        _isLoadingGoals = false;
        _isLoadingTodayActions = false;
      });
    }
  }

  int _daysRemaining(GoalLocalModel goal) {
    if (goal.targetDate == null) {
      return 0;
    }

    final difference = goal.targetDate!.difference(DateTime.now()).inDays;

    return difference < 0 ? 0 : difference;
  }

  Future<void> _toggleTodayAction(ActionLocalModel action) async {
    try {
      final updatedAction = await _actionsDataSource.toggleAction(action.id);

      if (updatedAction == null || !mounted) return;

      setState(() {
        final index = _todayActions.indexWhere(
          (item) => item.id == updatedAction.id,
        );

        if (index != -1) {
          _todayActions[index] = updatedAction;
        }
      });

      await refreshHome();
    } catch (error) {
      debugPrint('Today action toggle error: $error');
    }
  }

  Future<void> _openEditAction(ActionLocalModel action) async {
    final goal = _goals.cast<GoalLocalModel?>().firstWhere(
      (item) => item?.id == action.goalId,
      orElse: () => null,
    );

    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) =>
            EditActionScreen(action: action, goalTitle: goal?.title ?? 'Goal'),
      ),
    );

    if (updated == true) {
      await _loadTodayActions();
      await refreshHome();
    }
  }

  Future<void> _openGoal(GoalLocalModel goal) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => GoalDetailScreen(
          goalId: goal.id,
          title: goal.title,
          category: goal.category,
          progress: goal.progress,
          daysRemaining: _daysRemaining(goal),
        ),
      ),
    );

    if (changed == true && mounted) {
      await refreshHome();
      await _loadTodayActions();
    }
  }

  Widget _buildEmptyGoals() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.track_changes_rounded,
            size: 28,
            color: AppColors.gold,
          ),

          const SizedBox(height: AppSpacing.lg),

          Text(
            'Nothing competing\nfor your attention.',
            style: AppTextStyles.title.copyWith(fontSize: 22),
          ),

          const SizedBox(height: AppSpacing.sm),

          Text(
            'Create your first goal and start making progress.',
            style: AppTextStyles.bodySmall,
          ),

          const SizedBox(height: AppSpacing.lg),

          Text(
            'Tap + to begin',
            style: AppTextStyles.label.copyWith(color: AppColors.goldDark),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.lg,
                AppSpacing.screen,
                120,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const HomeHeader(),

                  const SizedBox(height: AppSpacing.xxl),

                  if (_isLoadingGoals)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.xxl),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (_goals.isEmpty)
                    _buildEmptyGoals()
                  else
                    HomeFocusGoalSection(
                      title: _goals.first.title,
                      progress: _goals.first.progress,
                      daysRemaining: _daysRemaining(_goals.first),
                      onTap: () => _openGoal(_goals.first),
                    ),

                  const SizedBox(height: AppSpacing.xxl),

                  if (!_isLoadingGoals)
                    HomeActiveGoalsSection(
                      goals: _goals,
                      daysRemaining: _daysRemaining,
                      onGoalTap: _openGoal,
                    ),

                  const SizedBox(height: AppSpacing.xxl),

                  if (!_isLoadingGoals && _goals.isNotEmpty)
                    HomeGoalsSection(
                      goals: _goals,
                      daysRemaining: _daysRemaining,
                      onGoalTap: _openGoal,
                    ),

                  const SizedBox(height: AppSpacing.xxl),

                  TodayActionsSection(
                    actions: _todayActions,
                    isLoading: _isLoadingTodayActions,
                    onActionToggled: _toggleTodayAction,
                    onActionEdit: _openEditAction,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
