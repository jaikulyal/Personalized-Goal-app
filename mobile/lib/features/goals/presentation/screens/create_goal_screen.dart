import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
//import '../../data/repositories/goals_repository.dart';
import 'package:uuid/uuid.dart';

import '../../data/local/goal_local_model.dart';
import '../../data/local/goals_local_datasource.dart';

class CreateGoalScreen extends StatefulWidget {
  const CreateGoalScreen({super.key});

  @override
  State<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final GoalsLocalDataSource _localDataSource = GoalsLocalDataSource();

  bool _isSaving = false;
  //final GoalsRepository _goalsRepository = GoalsRepository();
  //bool _isLoading = false;

  String _selectedCategory = 'Development';

  DateTime _startDate = DateTime.now();
  DateTime _targetDate = DateTime.now().add(const Duration(days: 7));

  final List<String> _categories = const [
    'Development',
    'Learning',
    'Health',
    'Career',
    'Personal',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate({required bool isStartDate}) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _targetDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );

    if (selected == null) return;

    setState(() {
      if (isStartDate) {
        _startDate = selected;

        if (_targetDate.isBefore(selected)) {
          _targetDate = selected.add(const Duration(days: 1));
        }
      } else {
        _targetDate = selected;
      }
    });
  }

  Future<void> _createGoal() async {
    if (_isSaving) return;

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty) {
      _showMessage('Give your goal a name first.');
      return;
    }

    if (_selectedCategory.isEmpty) {
      _showMessage('Choose a category.');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final now = DateTime.now();

      final goal = GoalLocalModel(
        id: const Uuid().v4(),
        title: title,
        category: _selectedCategory,
        description: description,
        startDate: _startDate,
        targetDate: _targetDate,
        progress: 0,
        isCompleted: false,
        createdAt: now,
        updatedAt: now,
      );

      await _localDataSource.saveGoal(goal);

      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      _showMessage('Goal created');

      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      _showMessage('Unable to save your goal. Please try again.');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  String _formatDate(DateTime date) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];

    return '${date.day} ${months[date.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
        ),
        title: Text(
          'CREATE GOAL',
          style: AppTextStyles.label.copyWith(letterSpacing: 1.5),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.lg,
            AppSpacing.screen,
            40,
          ),
          children: [
            Text(
              'What do you want\nto accomplish?',
              style: AppTextStyles.display.copyWith(fontSize: 38),
            ),

            const SizedBox(height: AppSpacing.xxl),

            _sectionLabel('GOAL'),

            const SizedBox(height: AppSpacing.sm),

            _textField(
              controller: _titleController,
              hint: 'Build something meaningful...',
              maxLines: 1,
            ),

            const SizedBox(height: AppSpacing.xl),

            _sectionLabel('CATEGORY'),

            const SizedBox(height: AppSpacing.md),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((category) {
                final selected = category == _selectedCategory;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: selected ? AppColors.primary : AppColors.border,
                      ),
                    ),
                    child: Text(
                      category,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: selected ? AppColors.surface : AppColors.primary,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: AppSpacing.xl),

            _sectionLabel('DESCRIPTION'),

            const SizedBox(height: AppSpacing.sm),

            _textField(
              controller: _descriptionController,
              hint: 'Why does this goal matter to you?',
              maxLines: 4,
            ),

            const SizedBox(height: AppSpacing.xl),

            _sectionLabel('WHEN'),

            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: _dateCard(
                    label: 'START',
                    date: _startDate,
                    onTap: () => _selectDate(isStartDate: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _dateCard(
                    label: 'TARGET',
                    date: _targetDate,
                    onTap: () => _selectDate(isStartDate: false),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xxl),

            _buildCreateButton(),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(text, style: AppTextStyles.label.copyWith(letterSpacing: 1.2));
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required int maxLines,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: AppTextStyles.body.copyWith(color: AppColors.primary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.body.copyWith(color: AppColors.secondary),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.all(18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
        ),
      ),
    );
  }

  Widget _dateCard({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.label.copyWith(fontSize: 9)),
            const SizedBox(height: 8),
            Text(
              _formatDate(date),
              style: AppTextStyles.title.copyWith(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF80681F),
              AppColors.gold,
              Color(0xFFFFE58A),
              AppColors.gold,
              Color(0xFF80681F),
            ],
            stops: [0.0, 0.25, 0.5, 0.75, 1.0],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withValues(alpha: 0.30),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: _isSaving ? null : _createGoal,
            child: Center(
              child: _isSaving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    )
                  : const Text(
                      'Create Goal',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
