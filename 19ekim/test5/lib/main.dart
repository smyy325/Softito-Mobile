import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'features/calorie_tracker/controller/calorie_tracker_controller.dart';
import 'features/calorie_tracker/view/calorie_tracker_view.dart';
import 'features/reminders/controller/reminder_controller.dart';
import 'features/reminders/view/reminders_view.dart';
import 'features/water_tracker/controller/water_tracker_controller.dart';
import 'features/water_tracker/view/water_tracker_view.dart';
import 'features/workout/controller/workout_controller.dart';
import 'features/workout/view/workout_view.dart';

void main() {
  runApp(const SusadimApp());
}

/// Susadım uygulaması giriş noktası ve tema yapılandırması.
class SusadimApp extends StatelessWidget {
  const SusadimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Susadım',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SusadimMainScreen(),
    );
  }
}

/// Ana navigasyon ve 4 modül yönlendirici kabuk ekranı.
class SusadimMainScreen extends StatefulWidget {
  const SusadimMainScreen({super.key});

  @override
  State<SusadimMainScreen> createState() => _SusadimMainScreenState();
}

class _SusadimMainScreenState extends State<SusadimMainScreen> {
  int _currentIndex = 0;

  late final WaterTrackerController _waterController;
  late final WorkoutController _workoutController;
  late final CalorieTrackerController _calorieController;
  late final ReminderController _reminderController;

  @override
  void initState() {
    super.initState();
    _waterController = WaterTrackerController();
    _workoutController = WorkoutController();
    _calorieController = CalorieTrackerController();
    _reminderController = ReminderController();
  }

  @override
  void dispose() {
    _waterController.dispose();
    _workoutController.dispose();
    _calorieController.dispose();
    _reminderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      WaterTrackerView(controller: _waterController),
      WorkoutView(controller: _workoutController),
      CalorieTrackerView(controller: _calorieController),
      RemindersView(controller: _reminderController),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      backgroundColor: AppColors.obsidianCard,
      destinations: const <NavigationDestination>[
        NavigationDestination(
          icon: Icon(Icons.water_drop_outlined),
          selectedIcon:
              Icon(Icons.water_drop_rounded, color: AppColors.neonCyan),
          label: 'Su',
        ),
        NavigationDestination(
          icon: Icon(Icons.fitness_center_outlined),
          selectedIcon:
              Icon(Icons.fitness_center_rounded, color: AppColors.neonLime),
          label: 'Egzersiz',
        ),
        NavigationDestination(
          icon: Icon(Icons.restaurant_outlined),
          selectedIcon:
              Icon(Icons.restaurant_rounded, color: AppColors.neonAmber),
          label: 'Kalori',
        ),
        NavigationDestination(
          icon: Icon(Icons.notifications_outlined),
          selectedIcon: Icon(
            Icons.notifications_active_rounded,
            color: AppColors.neonCyan,
          ),
          label: 'Hatırlatıcı',
        ),
      ],
    );
  }
}
