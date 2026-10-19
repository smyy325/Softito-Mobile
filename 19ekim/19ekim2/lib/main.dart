import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/calorie_tracker/controller/calorie_controller.dart';
import 'features/calorie_tracker/view/calorie_tracker_view.dart';
import 'features/reminders/controller/reminder_controller.dart';
import 'features/reminders/view/reminders_view.dart';
import 'features/water_tracker/controller/water_tracker_controller.dart';
import 'features/water_tracker/view/water_tracker_view.dart';
import 'features/workout/controller/workout_controller.dart';
import 'features/workout/view/workout_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SusadimApp());
}

class SusadimApp extends StatefulWidget {
  final ThemeController? themeController;

  const SusadimApp({super.key, this.themeController});

  @override
  State<SusadimApp> createState() => _SusadimAppState();
}

class _SusadimAppState extends State<SusadimApp> {
  late final ThemeController _themeController;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    if (widget.themeController != null) {
      _themeController = widget.themeController!;
      _ownsController = false;
    } else {
      _themeController = ThemeController();
      _ownsController = true;
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _themeController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeController.themeModeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'Susadım v1',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode,
          home: MainNavigationShell(themeController: _themeController),
        );
      },
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  final ThemeController? themeController;

  const MainNavigationShell({super.key, this.themeController});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  late final WaterTrackerController _waterController;
  late final WorkoutController _workoutController;
  late final CalorieController _calorieController;
  late final ReminderController _reminderController;

  @override
  void initState() {
    super.initState();
    _waterController = WaterTrackerController();
    _workoutController = WorkoutController();
    _calorieController = CalorieController();
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
    final screens = [
      WaterTrackerView(
        controller: _waterController,
        themeController: widget.themeController,
      ),
      WorkoutView(controller: _workoutController),
      CalorieTrackerView(controller: _calorieController),
      RemindersView(
        controller: _reminderController,
        themeController: widget.themeController,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).colorScheme.outline;
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: borderColor, width: 1)),
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.water_drop_outlined),
            selectedIcon: Icon(Icons.water_drop_rounded),
            label: 'Su Takibi',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center_rounded),
            label: 'Egzersiz',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_outlined),
            selectedIcon: Icon(Icons.restaurant_rounded),
            label: 'Kalori',
          ),
          NavigationDestination(
            icon: Icon(Icons.alarm_outlined),
            selectedIcon: Icon(Icons.alarm_rounded),
            label: 'Hatırlatıcı',
          ),
        ],
      ),
    );
  }
}
