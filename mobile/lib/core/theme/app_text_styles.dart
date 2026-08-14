import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  static const display = TextStyle(
    fontSize: 40,
    height: 1.05,
    fontWeight: FontWeight.w600,
    letterSpacing: -1.5,
    color: AppColors.primary,
  );

  static const headline = TextStyle(
    fontSize: 28,
    height: 1.15,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.8,
    color: AppColors.primary,
  );

  static const title = TextStyle(
    fontSize: 20,
    height: 1.25,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    color: AppColors.primary,
  );

  static const body = TextStyle(
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
  );

  static const bodySmall = TextStyle(
    fontSize: 14,
    height: 1.4,
    fontWeight: FontWeight.w400,
    color: AppColors.secondary,
  );

  static const label = TextStyle(
    fontSize: 12,
    height: 1.2,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppColors.secondary,
  );
}
