import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class GoalDetailScreen extends StatefulWidget {
  final String title;
  final String category;
  final double progress;
  final int daysRemaining;

  const GoalDetailScreen({
    super.key,
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

  final List<bool> _tasks = [true, false, false];

  @override
  void initState() {
    super.initState();
    _progress = widget.progress;
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
          onTap: () => Navigator.of(context).pop(),
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
    return Row(
      children: [
        Expanded(child: _statItem('STARTED', '14 AUG')),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: _statItem('DEADLINE', '${widget.daysRemaining} DAYS')),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _statItem('STATUS', widget.progress >= 1 ? 'DONE' : 'ACTIVE'),
        ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Milestones', style: AppTextStyles.title),

        const SizedBox(height: AppSpacing.md),

        _milestone('Define the goal', true),

        _milestone('Complete first milestone', true),

        _milestone('Reach 75% progress', false),

        _milestone('Complete the goal', false),
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
              widget.title,
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
    final tasks = ['Work on the goal', 'Review progress', 'Plan tomorrow'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Today', style: AppTextStyles.title),

        const SizedBox(height: AppSpacing.md),

        ...List.generate(
          tasks.length,
          (index) => _task(tasks[index], _tasks[index], index),
        ),
      ],
    );
  }

  Widget _task(String title, bool completed, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _tasks[index] = !_tasks[index];

          final completedTasks = _tasks.where((task) => task).length;

          _progress = completedTasks / _tasks.length;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: completed
              ? AppColors.gold.withValues(alpha: 0.10)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: completed
                ? AppColors.gold.withValues(alpha: 0.30)
                : AppColors.primary.withValues(alpha: 0.07),
          ),
        ),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Icon(
                completed ? Icons.check_circle_rounded : Icons.circle_outlined,
                key: ValueKey(completed),
                color: completed ? AppColors.gold : AppColors.muted,
                size: 21,
              ),
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
      ),
    );
  }
}
