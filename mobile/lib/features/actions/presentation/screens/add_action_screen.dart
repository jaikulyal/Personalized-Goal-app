import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/datasources/actions_local_datasource.dart';
import '../../data/local/action_local_model.dart';

import '../widgets/add_action_form.dart';
import '../widgets/add_action_header.dart';
import '../widgets/add_action_save_button.dart';
import '../widgets/add_action_top_bar.dart';
import '../../../../core/notification/notification_service.dart';

class AddActionScreen extends StatefulWidget {
  final String goalId;
  final String goalTitle;

  const AddActionScreen({
    super.key,
    required this.goalId,
    required this.goalTitle,
  });

  @override
  State<AddActionScreen> createState() => _AddActionScreenState();
}

class _AddActionScreenState extends State<AddActionScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();

  final ActionsLocalDataSource _dataSource = ActionsLocalDataSource();

  DateTime _selectedDate = DateTime.now();

  TimeOfDay _selectedTime = TimeOfDay.now();

  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // DATE PICKER
  // ------------------------------------------------------------

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.surface,
              surface: AppColors.surface,
              onSurface: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      _selectedDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );
    });
  }

  // ------------------------------------------------------------
  // TIME PICKER
  // ------------------------------------------------------------

  Future<void> _selectTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.surface,
              surface: AppColors.surface,
              onSurface: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) {
      return;
    }

    setState(() {
      _selectedTime = pickedTime;

      _selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  // ------------------------------------------------------------
  // SAVE ACTION
  // ------------------------------------------------------------

  Future<void> _saveAction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final now = DateTime.now();

      final action = ActionLocalModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        goalId: widget.goalId,
        title: _titleController.text.trim(),
        scheduledDate: _selectedDate,
        isCompleted: false,
        completedAt: null,
        createdAt: now,
        updatedAt: now,
      );

      await _dataSource.saveAction(action);
      await NotificationService.instance.scheduleActionReminder(
        actionId: action.id,
        actionTitle: action.title,
        scheduledDate: action.scheduledDate,
      );
      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not add action: $error')));
    }
  }

  // ------------------------------------------------------------
  // DATE FORMATTER
  // ------------------------------------------------------------

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} '
        '${months[date.month - 1]} '
        '${date.year}';
  }

  // ------------------------------------------------------------
  // TIME FORMATTER
  // ------------------------------------------------------------

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;

    final minute = time.minute.toString().padLeft(2, '0');

    final period = time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

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
                  AddActionTopBar(
                    onBack: () {
                      Navigator.of(context).pop();
                    },
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  AddActionHeader(goalTitle: widget.goalTitle),

                  const SizedBox(height: AppSpacing.xxl),

                  AddActionForm(
                    formKey: _formKey,
                    titleController: _titleController,
                    selectedDate: _selectedDate,
                    selectedTime: _selectedTime,
                    onSelectDate: _selectDate,
                    onSelectTime: _selectTime,
                    formatDate: _formatDate,
                    formatTime: _formatTime,
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  AddActionSaveButton(
                    isSaving: _isSaving,
                    onPressed: _saveAction,
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
