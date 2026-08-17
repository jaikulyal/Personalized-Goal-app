import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class AppAddButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AppAddButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        splashColor: AppColors.primary.withValues(alpha: 0.12),
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.gold,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.surface, width: 5),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.18),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: const Icon(
            Icons.add_rounded,
            color: AppColors.primary,
            size: 30,
          ),
        ),
      ),
    );
  }
}
