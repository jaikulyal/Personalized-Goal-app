import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/progress_local_datasource.dart';
import '../../domain/progress_models.dart';

class WeeklyReflectionCard extends StatefulWidget {
  const WeeklyReflectionCard({super.key});

  @override
  State<WeeklyReflectionCard> createState() => _WeeklyReflectionCardState();
}

class _WeeklyReflectionCardState extends State<WeeklyReflectionCard> {
  final ProgressLocalDataSource _dataSource = ProgressLocalDataSource();

  WeeklyReflection? _reflection;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReflection();
  }

  Future<void> _loadReflection() async {
    final reflection = await _dataSource.getWeeklyReflection();

    if (!mounted) return;

    setState(() {
      _reflection = reflection;
      _isLoading = false;
    });
  }

  Future<void> _openReflectionSheet() async {
    final result = await showModalBottomSheet<WeeklyReflection>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _ReflectionBottomSheet(reflection: _reflection);
      },
    );

    if (result == null) return;

    await _dataSource.saveWeeklyReflection(
      whatWentWell: result.whatWentWell,
      whatWasDifficult: result.whatWasDifficult,
      whatToImprove: result.whatToImprove,
    );

    if (!mounted) return;

    setState(() {
      _reflection = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    final hasReflection = _reflection != null;

    return GestureDetector(
      onTap: _openReflectionSheet,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: AppColors.champagneSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.edit_note_rounded,
                    color: AppColors.goldDark,
                    size: 19,
                  ),
                ),

                const SizedBox(width: AppSpacing.md),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Weekly Wins', style: AppTextStyles.title),
                      const SizedBox(height: 3),
                      Text(
                        hasReflection
                            ? 'Your reflection is saved.'
                            : 'Take a moment to look back.',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),

                const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            if (!hasReflection) ...[
              const _ReflectionPrompt(
                icon: Icons.check_circle_outline_rounded,
                text: 'What went well this week?',
              ),

              const SizedBox(height: AppSpacing.sm),

              const _ReflectionPrompt(
                icon: Icons.help_outline_rounded,
                text: 'What made things difficult?',
              ),

              const SizedBox(height: AppSpacing.sm),

              const _ReflectionPrompt(
                icon: Icons.arrow_forward_rounded,
                text: 'What would you like to improve?',
              ),
            ] else ...[
              _SavedReflectionItem(
                icon: Icons.check_circle_outline_rounded,
                label: 'What went well',
                value: _reflection!.whatWentWell,
              ),

              const SizedBox(height: AppSpacing.sm),

              _SavedReflectionItem(
                icon: Icons.help_outline_rounded,
                label: 'What was difficult',
                value: _reflection!.whatWasDifficult,
              ),

              const SizedBox(height: AppSpacing.sm),

              _SavedReflectionItem(
                icon: Icons.arrow_forward_rounded,
                label: 'What to improve',
                value: _reflection!.whatToImprove,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ReflectionPrompt extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ReflectionPrompt({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 17, color: AppColors.goldDark),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: AppColors.muted,
          ),
        ],
      ),
    );
  }
}

class _SavedReflectionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;

  const _SavedReflectionItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.goldDark),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.label.copyWith(color: AppColors.muted),
                ),
                const SizedBox(height: 4),
                Text(
                  hasValue ? value! : 'Not added',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: hasValue ? AppColors.primary : AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReflectionBottomSheet extends StatefulWidget {
  final WeeklyReflection? reflection;

  const _ReflectionBottomSheet({required this.reflection});

  @override
  State<_ReflectionBottomSheet> createState() => _ReflectionBottomSheetState();
}

class _ReflectionBottomSheetState extends State<_ReflectionBottomSheet> {
  late final TextEditingController _wentWellController;
  late final TextEditingController _difficultController;
  late final TextEditingController _improveController;

  @override
  void initState() {
    super.initState();

    _wentWellController = TextEditingController(
      text: widget.reflection?.whatWentWell ?? '',
    );

    _difficultController = TextEditingController(
      text: widget.reflection?.whatWasDifficult ?? '',
    );

    _improveController = TextEditingController(
      text: widget.reflection?.whatToImprove ?? '',
    );
  }

  @override
  void dispose() {
    _wentWellController.dispose();
    _difficultController.dispose();
    _improveController.dispose();
    super.dispose();
  }

  void _save() {
    final now = DateTime.now();

    final weekStart = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));

    Navigator.of(context).pop(
      WeeklyReflection(
        whatWentWell: _clean(_wentWellController.text),
        whatWasDifficult: _clean(_difficultController.text),
        whatToImprove: _clean(_improveController.text),
        weekStart: weekStart,
      ),
    );
  }

  String? _clean(String value) {
    final text = value.trim();

    if (text.isEmpty) {
      return null;
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg + bottomInset,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            Text('My Weekly reflection', style: AppTextStyles.headline),

            const SizedBox(height: AppSpacing.xs),

            Text(
              'Keep it simple. A few honest notes are enough.',
              style: AppTextStyles.bodySmall,
            ),

            const SizedBox(height: AppSpacing.xl),

            _ReflectionField(
              controller: _wentWellController,
              label: 'What went well this week?',
              hint: 'Something you are proud of...',
              icon: Icons.check_circle_outline_rounded,
            ),

            const SizedBox(height: AppSpacing.md),

            _ReflectionField(
              controller: _difficultController,
              label: 'What made things difficult?',
              hint: 'Anything that got in the way...',
              icon: Icons.help_outline_rounded,
            ),

            const SizedBox(height: AppSpacing.md),

            _ReflectionField(
              controller: _improveController,
              label: 'What would you like to improve?',
              hint: 'One thing to focus on next...',
              icon: Icons.arrow_forward_rounded,
            ),

            const SizedBox(height: AppSpacing.xl),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.surface,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Save reflection',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReflectionField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;

  const _ReflectionField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 17, color: AppColors.goldDark),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.sm),

        TextField(
          controller: controller,
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.muted),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.gold, width: 1),
            ),
            contentPadding: const EdgeInsets.all(AppSpacing.md),
          ),
        ),
      ],
    );
  }
}
