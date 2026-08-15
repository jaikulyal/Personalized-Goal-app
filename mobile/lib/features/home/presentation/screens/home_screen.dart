import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/app_add_button.dart';
import '../widgets/app_bottom_navigation.dart';
import '../widgets/focus_goal_card.dart';
import '../widgets/task_tile.dart';
import '/core/theme/app_colors.dart';
import '../widgets/active_goal_card.dart';

import '../../../goals/data/datasources/goals_local_datasource.dart';
import '../../../goals/data/local/goal_local_model.dart';
import '../../../goals/presentation/screens/create_goal_screen.dart';
import '../../../goals/presentation/screens/goal_detail_screen.dart';
import '../widgets/goal_list_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  List<GoalLocalModel> _goals = [];
  bool _isLoadingGoals = true;

  void _toggleTask(int index) {
    setState(() {
      _todayTasks[index]['completed'] =
          !(_todayTasks[index]['completed'] as bool);
    });
  }

  final GoalsLocalDataSource _localDataSource = GoalsLocalDataSource();

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  //access data form locla storage.
  Future<void> _loadGoals() async {
    final goals = await _localDataSource.getGoals();

    debugPrint('GOALS LOADED: ${goals.length}');

    for (final goal in goals) {
      debugPrint('GOAL: ${goal.title} | progress: ${goal.progress}');
    }

    if (!mounted) return;

    setState(() {
      _goals = goals;
      _isLoadingGoals = false;
    });
  }

  //temp chnge for local data action or removal.
  /*Future<void> _loadGoals() async {
    final goals = await _localDataSource.getGoals();

    if (!mounted) return;

    setState(() {
      _goals = goals;
      _isLoadingGoals = false;
    });
  }*/

  int _daysRemaining(GoalLocalModel goal) {
    if (goal.targetDate == null) {
      return 0;
    }

    final difference = goal.targetDate!.difference(DateTime.now()).inDays;

    return difference < 0 ? 0 : difference;
  }

  Future<void> _openCreateGoal() async {
    final created = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute(builder: (_) => const CreateGoalScreen()));

    if (created == true) {
      await _loadGoals();
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

  Widget _buildGoalsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('My Goals', style: AppTextStyles.title),
            Text('${_goals.length}', style: AppTextStyles.bodySmall),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        ..._goals.map(
          (goal) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: GoalListCard(
              title: goal.title,
              category: goal.category,
              progress: goal.progress,
              isCompleted: goal.isCompleted,
              onTap: () async {
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

                if (changed == true) {
                  await _loadGoals();
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  final List<Map<String, dynamic>> _todayTasks = [
    {'title': 'Finish authentication', 'completed': false},
    {'title': 'Design goal screen', 'completed': false},
    {'title': 'Setup database', 'completed': true},
  ];
  Widget _buildActiveGoals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Active goals', style: AppTextStyles.title),

            const Spacer(),

            Text(
              'View all',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.goldDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        const ActiveGoalCard(
          title: 'Build a consistent workout routine',
          category: 'Health',
          progress: 0.48,
          daysRemaining: 18,
        ),

        const SizedBox(height: AppSpacing.sm),

        const ActiveGoalCard(
          title: 'Read 12 books this year',
          category: 'Learning',
          progress: 0.66,
          daysRemaining: 42,
        ),
      ],
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
                  _buildHeader(),

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
                    //Focus Goal card.
                    FocusGoalCard(
                      title: _goals.first.title,
                      progress: _goals.first.progress,
                      daysRemaining: _daysRemaining(_goals.first),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => GoalDetailScreen(
                              goalId: _goals.first.id,
                              title: _goals.first.title,
                              category: _goals.first.category,
                              progress: _goals.first.progress,
                              daysRemaining: _daysRemaining(_goals.first),
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: AppSpacing.xxl),

                  _buildActiveGoals(),

                  const SizedBox(height: AppSpacing.xxl),
                  _buildGoalsSection(),

                  const SizedBox(height: AppSpacing.xxl),
                  _buildTodaySection(),
                  const SizedBox(height: AppSpacing.xxl),

                  //_buildTodaySection(),
                ]),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });

          // Navigation will be connected here next.
        },
      ),

      floatingActionButton: AppAddButton(onPressed: _openCreateGoal),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gold,
              ),
            ),
            const SizedBox(width: 9),
            Text(
              'FRIDAY, AUGUST 14',
              style: AppTextStyles.label.copyWith(
                letterSpacing: 1.4,
                fontSize: 10,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

        Text(
          'Good morning,',
          style: AppTextStyles.headline.copyWith(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          'Make today count.',
          style: AppTextStyles.display.copyWith(
            fontSize: 36,
            letterSpacing: -1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildTodaySection() {
    final completedCount = _todayTasks
        .where((task) => task['completed'] == true)
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('Today', style: AppTextStyles.title),

            const Spacer(),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Container(
                key: ValueKey(completedCount),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: completedCount == _todayTasks.length
                      ? AppColors.gold.withValues(alpha: 0.14)
                      : AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  '$completedCount of ${_todayTasks.length} complete',
                  style: AppTextStyles.label.copyWith(
                    color: completedCount == _todayTasks.length
                        ? AppColors.goldDark
                        : AppColors.muted,
                    fontSize: 9,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        ...List.generate(_todayTasks.length, (index) {
          final task = _todayTasks[index];

          return Padding(
            padding: EdgeInsets.only(
              bottom: index == _todayTasks.length - 1 ? 0 : AppSpacing.sm,
            ),
            child: TaskTile(
              title: task['title'] as String,
              completed: task['completed'] as bool,
              onTap: () => _toggleTask(index),
            ),
          );
        }),
      ],
    );
  }
}
