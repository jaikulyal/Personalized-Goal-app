import 'package:flutter/material.dart';
import 'core/storage/local_storage.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/screens/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalStorage.init();

  runApp(const GoalApp());
}

class GoalApp extends StatelessWidget {
  const GoalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const WelcomeScreen(),
    );
  }
}
