import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppColors.surface,
      elevation: 0,
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: 'Home',
            active: currentIndex == 0,
            onTap: () => onItemSelected(0),
          ),
          _NavItem(
            icon: Icons.flag_outlined,
            activeIcon: Icons.flag_rounded,
            label: 'Goals',
            active: currentIndex == 1,
            onTap: () => onItemSelected(1),
          ),

          const SizedBox(width: 48),

          _NavItem(
            icon: Icons.insights_outlined,
            activeIcon: Icons.insights_rounded,
            label: 'Progress',
            active: currentIndex == 2,
            onTap: () => onItemSelected(2),
          ),
          _NavItem(
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded,
            label: 'Profile',
            active: currentIndex == 3,
            onTap: () => onItemSelected(3),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 48,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              active ? activeIcon : icon,
              size: 22,
              color: active ? AppColors.primary : AppColors.secondary,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppTextStyles.label.copyWith(
                fontSize: 9,
                color: active ? AppColors.primary : AppColors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
