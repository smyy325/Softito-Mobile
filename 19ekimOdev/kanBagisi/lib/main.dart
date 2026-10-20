import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'core/theme/widget/theme_mode_switch_button.dart';
import 'features/blood_stats/view/blood_stats_view.dart';
import 'features/donation_tracker/view/donation_tracker_view.dart';
import 'features/urgent_requests/view/urgent_requests_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KanVerApp());
}

/// KanVer uygulaması ana kök widget'ı.
class KanVerApp extends StatelessWidget {
  const KanVerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeModeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'KanVer',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: const MainNavigationScaffold(),
        );
      },
    );
  }
}

/// Ana navigasyon yapısı ve 3 modül arasındaki geçişi yöneten Scaffold.
class MainNavigationScaffold extends StatelessWidget {
  const MainNavigationScaffold({super.key});

  static final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);

  static final List<Widget> _views = [
    DonationTrackerView(),
    BloodStatsView(),
    UrgentRequestsView(),
  ];

  static const List<String> _titles = [
    'Kan Bağışı Takibi',
    'Kan Stokları & Analiz',
    'Acil Kan Talepleri',
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _currentIndexNotifier,
      builder: (context, index, _) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Icon(Icons.bloodtype_rounded, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(_titles[index]),
              ],
            ),
            actions: const [
              ThemeModeSwitchButton(),
              SizedBox(width: 8),
            ],
          ),
          body: IndexedStack(index: index, children: _views),
          bottomNavigationBar: _BottomNav(
            currentIndex: index,
            onDestinationSelected: (val) => _currentIndexNotifier.value = val,
          ),
        );
      },
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  const _BottomNav({
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.water_drop_outlined),
          selectedIcon: Icon(Icons.water_drop_rounded),
          label: 'Takip',
        ),
        NavigationDestination(
          icon: Icon(Icons.analytics_outlined),
          selectedIcon: Icon(Icons.analytics_rounded),
          label: 'Stoklar',
        ),
        NavigationDestination(
          icon: Icon(Icons.emergency_outlined),
          selectedIcon: Icon(Icons.emergency_rounded),
          label: 'Acil',
        ),
      ],
    );
  }
}
