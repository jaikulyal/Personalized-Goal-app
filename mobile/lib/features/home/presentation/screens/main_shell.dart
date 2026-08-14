import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [_HomeTab(), _GoalsTab(), _ProfileTab()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.track_changes_outlined),
            selectedIcon: Icon(Icons.track_changes_rounded),
            label: 'Goals',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'You',
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screen),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),

            const Text('HOME', style: AppTextStyles.label),

            const SizedBox(height: AppSpacing.md),

            const Text(
              'Your day,\nwith intention.',
              style: AppTextStyles.display,
            ),

            const SizedBox(height: AppSpacing.lg),

            Text(
              'Your dashboard is ready.',
              style: AppTextStyles.body.copyWith(color: AppColors.secondary),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _GoalsTab extends StatelessWidget {
  const _GoalsTab();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: Center(child: Text('Goals')));
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: Center(child: Text('You')));
  }
}
