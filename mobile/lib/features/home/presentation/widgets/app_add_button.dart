import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class AppAddButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AppAddButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
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
