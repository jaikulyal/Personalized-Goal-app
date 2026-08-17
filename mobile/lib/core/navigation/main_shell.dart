import 'package:flutter/material.dart';

import '/features/home/presentation/widgets/app_bottom_navigation.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/goals/presentation/screens/goals_screen.dart';
import '../../features/progress/presentation/screens/progress_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/goals/presentation/screens/create_goal_screen.dart';
import '../../features/home/presentation/widgets/app_add_button.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final GlobalKey<HomeScreenState> _homeScreenKey =
      GlobalKey<HomeScreenState>();
  final GlobalKey<ProgressScreenState> _progressScreenKey =
      GlobalKey<ProgressScreenState>();
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      HomeScreen(key: _homeScreenKey),
      const GoalsScreen(),
      ProgressScreen(key: _progressScreenKey),
      const ProfileScreen(),
    ];
  }

  Future<void> _openCreateGoal() async {
    final created = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute(builder: (_) => const CreateGoalScreen()));

    if (created == true) {
      await _homeScreenKey.currentState?.refreshHome();
      await _progressScreenKey.currentState?.refreshProgress();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),

      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      floatingActionButton: _currentIndex == 0 || _currentIndex == 1
          ? AppAddButton(onPressed: _openCreateGoal)
          : null,
    );
  }
}
