import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/app_add_button.dart';
import '../widgets/app_bottom_navigation.dart';
import '../widgets/focus_goal_card.dart';
import '../widgets/task_tile.dart';
import '/core/theme/app_colors.dart';
import '../widgets/active_goal_card.dart';
import '../../../goals/presentation/screens/goal_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _toggleTask(int index) {
    setState(() {
      _todayTasks[index]['completed'] =
          !(_todayTasks[index]['completed'] as bool);
    });
  }

  int _currentIndex = 0;
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

                  FocusGoalCard(
                    title: 'Build my\nGoal App',
                    progress: 0.72,
                    daysRemaining: 3,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const GoalDetailScreen(
                            title: 'Build my Goal App',
                            category: 'Productivity',
                            progress: 0.72,
                            daysRemaining: 3,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  _buildActiveGoals(),

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

      floatingActionButton: const AppAddButton(),

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
