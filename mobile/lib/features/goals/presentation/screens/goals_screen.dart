import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../../data/datasources/goals_local_datasource.dart';
import '../../data/local/goal_local_model.dart';

import '../screens/goal_detail_screen.dart';
import '../widgets/goal_card.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final GoalsLocalDataSource _dataSource = GoalsLocalDataSource();

  List<GoalLocalModel> _goals = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final goals = await _dataSource.getGoals();

      if (!mounted) return;

      setState(() {
        _goals = goals;
        _isLoading = false;
      });
    } catch (error) {
      debugPrint('Goals screen loading error: $error');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
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

    if (changed == true) {
      await _loadGoals();
    }
  }

  int _daysRemaining(GoalLocalModel goal) {
    if (goal.targetDate == null) {
      return 0;
    }

    final difference = goal.targetDate!.difference(DateTime.now()).inDays;

    return difference < 0 ? 0 : difference;
  }

  List<GoalLocalModel> get _activeGoals {
    return _goals.where((goal) => goal.progress < 1.0).toList();
  }

  List<GoalLocalModel> get _completedGoals {
    return _goals.where((goal) => goal.progress >= 1.0).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        color: AppColors.gold,
        backgroundColor: AppColors.primary,
        onRefresh: _loadGoals,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.lg,
                AppSpacing.screen,
                100,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildHeader(),

                  const SizedBox(height: AppSpacing.xxl),

                  if (_isLoading)
                    const _GoalsLoadingState()
                  else
                    _buildContent(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'YOUR GOALS',
          style: AppTextStyles.label.copyWith(
            letterSpacing: 1.5,
            color: AppColors.gold,
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        Text(
          'Turn intentions\ninto progress.',
          style: AppTextStyles.display.copyWith(fontSize: 38),
        ),

        const SizedBox(height: AppSpacing.xxl),

        _buildStats(_activeGoals.length, _completedGoals.length),
      ],
    );
  }

  Widget _buildContent() {
    if (_goals.isEmpty) {
      return _buildEmptyState();
    }

    final activeGoals = _activeGoals;
    final completedGoals = _completedGoals;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (activeGoals.isNotEmpty) ...[
          Text(
            'ACTIVE',
            style: AppTextStyles.label.copyWith(
              letterSpacing: 1.3,
              color: AppColors.gold,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          ...activeGoals.map(
            (goal) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GoalCard(goal: goal, onTap: () => _openGoal(goal)),
            ),
          ),
        ],

        if (completedGoals.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),

          Text(
            'COMPLETED',
            style: AppTextStyles.label.copyWith(
              letterSpacing: 1.3,
              color: AppColors.gold,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          ...completedGoals.map(
            (goal) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GoalCard(goal: goal, onTap: () => _openGoal(goal)),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStats(int active, int completed) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(value: '$active', label: 'ACTIVE'),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _StatCard(value: '$completed', label: 'COMPLETED'),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
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
            size: 30,
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
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppTextStyles.display.copyWith(fontSize: 30)),

          const SizedBox(height: 4),

          Text(
            label,
            style: AppTextStyles.label.copyWith(
              fontSize: 9,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalsLoadingState extends StatelessWidget {
  const _GoalsLoadingState();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 300,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(AppColors.gold),
        ),
      ),
    );
  }
}
