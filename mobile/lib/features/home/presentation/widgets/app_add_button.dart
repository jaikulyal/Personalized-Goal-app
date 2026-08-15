import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../goals/presentation/screens/create_goal_screen.dart';

class AppAddButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AppAddButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: () async {
          final created = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const CreateGoalScreen()),
          );

          if (created == true) {
            // Home will reload the newly created goal.
          }
        },
        customBorder: const CircleBorder(),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.background, width: 4),
          ),
          child: const Icon(
            Icons.add_rounded,
            color: AppColors.surface,
            size: 25,
          ),
        ),
      ),
    );
  }
}
