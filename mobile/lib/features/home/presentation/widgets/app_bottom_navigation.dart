import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_colors.dart';

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
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: SizedBox(
          height: 76,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              CustomPaint(
                size: const Size(double.infinity, 76),
                painter: _BottomNavigationPainter(),
              ),

              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: _NavigationItem(
                          icon: FontAwesomeIcons.house,
                          label: 'Home',
                          selected: currentIndex == 0,
                          onTap: () => onItemSelected(0),
                        ),
                      ),

                      Expanded(
                        child: _NavigationItem(
                          icon: FontAwesomeIcons.bullseye,
                          label: 'Goals',
                          selected: currentIndex == 1,
                          onTap: () => onItemSelected(1),
                        ),
                      ),

                      const SizedBox(width: 65),

                      Expanded(
                        child: _NavigationItem(
                          icon: FontAwesomeIcons.chartArea,
                          label: 'Progress',
                          selected: currentIndex == 2,
                          onTap: () => onItemSelected(2),
                        ),
                      ),

                      Expanded(
                        child: _NavigationItem(
                          icon: FontAwesomeIcons.user,
                          label: 'Profile',
                          selected: currentIndex == 3,
                          onTap: () => onItemSelected(3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavigationItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: AppColors.gold.withValues(alpha: 0.08),
        highlightColor: AppColors.gold.withValues(alpha: 0.04),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.gold.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                icon,
                size: 18,
                color: selected ? AppColors.gold : AppColors.muted,
              ),

              const SizedBox(height: 5),

              Text(
                label,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  color: selected ? AppColors.gold : AppColors.muted,
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavigationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    const radius = 30.0;

    final path = Path();

    final centerX = size.width / 2;

    const notchRadius = 45.0;
    const notchDepth = 30.0;

    path.moveTo(radius, 0);

    path.lineTo(centerX - notchRadius, 0);

    path.cubicTo(
      centerX - 29,
      0,
      centerX - 28,
      notchDepth,
      centerX,
      notchDepth,
    );

    path.cubicTo(
      centerX + 28,
      notchDepth,
      centerX + 29,
      0,
      centerX + notchRadius,
      0,
    );

    path.lineTo(size.width - radius, 0);

    path.quadraticBezierTo(size.width, 0, size.width, radius);

    path.lineTo(size.width, size.height - radius);

    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - radius,
      size.height,
    );

    path.lineTo(radius, size.height);

    path.quadraticBezierTo(0, size.height, 0, size.height - radius);

    path.lineTo(0, radius);

    path.quadraticBezierTo(0, 0, radius, 0);

    path.close();

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawPath(path.shift(const Offset(0, 3)), shadowPaint);

    final paint = Paint()
      ..color = AppColors.surface
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.07)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawPath(path, borderPaint);

    // Keeps the compiler aware that the full bounds
    // are intentionally used by this painter.
    canvas.drawRect(
      rect,
      Paint()
        ..color = Colors.transparent
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
