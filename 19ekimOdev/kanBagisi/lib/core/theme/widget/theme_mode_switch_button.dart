import 'package:flutter/material.dart';
import '../../extensions/context_extensions.dart';
import '../theme_controller.dart';

/// Tema modunu (Sistem / Karanlık / Aydınlık) değiştiren açılır menü butonu.
class ThemeModeSwitchButton extends StatelessWidget {
  const ThemeModeSwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeModeNotifier,
      builder: (context, currentMode, _) {
        return PopupMenuButton<ThemeMode>(
          tooltip: 'Tema Seçimi',
          icon: Icon(
            _getModeIcon(currentMode),
            color: context.colorScheme.primary,
          ),
          onSelected: (mode) => ThemeController.instance.setThemeMode(mode),
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: ThemeMode.system,
              child: _ThemeOptionRow(
                icon: Icons.brightness_auto,
                title: 'Sistem Teması',
              ),
            ),
            PopupMenuItem(
              value: ThemeMode.light,
              child: _ThemeOptionRow(
                icon: Icons.light_mode,
                title: 'Aydınlık Mod (Modern Medikal)',
              ),
            ),
            PopupMenuItem(
              value: ThemeMode.dark,
              child: _ThemeOptionRow(
                icon: Icons.dark_mode,
                title: 'Karanlık Mod (Dark Obsidian)',
              ),
            ),
          ],
        );
      },
    );
  }

  IconData _getModeIcon(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.system => Icons.brightness_auto,
      ThemeMode.light => Icons.light_mode,
      ThemeMode.dark => Icons.dark_mode,
    };
  }
}

class _ThemeOptionRow extends StatelessWidget {
  final IconData icon;
  final String title;

  const _ThemeOptionRow({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: context.colorScheme.primary),
        const SizedBox(width: 12),
        Text(title, style: context.textTheme.bodyMedium),
      ],
    );
  }
}
