import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

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
        child: Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
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
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.30),
                blurRadius: 16,
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
