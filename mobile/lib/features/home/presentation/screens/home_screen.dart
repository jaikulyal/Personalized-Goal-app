import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/app_add_button.dart';
import '../widgets/app_bottom_navigation.dart';
import '../widgets/focus_goal_card.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

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

                  const FocusGoalCard(
                    title: 'Build my\nGoal App',
                    progress: 0.72,
                    daysRemaining: 3,
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  _buildTodaySection(),
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
        Text(
          'FRIDAY, AUGUST 14',
          style: AppTextStyles.label.copyWith(letterSpacing: 1.2),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Good morning.', style: AppTextStyles.headline),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Make today count.',
          style: AppTextStyles.display.copyWith(fontSize: 36),
        ),
      ],
    );
  }

  Widget _buildTodaySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Today', style: AppTextStyles.title),
            Text('2 of 3 complete', style: AppTextStyles.bodySmall),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        const TaskTile(title: 'Finish authentication', completed: false),

        const SizedBox(height: AppSpacing.sm),

        const TaskTile(title: 'Design goal screen', completed: false),

        const SizedBox(height: AppSpacing.sm),

        const TaskTile(title: 'Setup database', completed: true),
      ],
    );
  }
}
