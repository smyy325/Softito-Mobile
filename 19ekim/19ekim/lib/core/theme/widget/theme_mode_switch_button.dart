import 'package:flutter/material.dart';
import '../theme_controller.dart';

/// Sistem / Karanlık / Aydınlık mod geçişini sağlayan reaktif buton bileşeni.
/// [SKILL.md] standartlarına uygun olarak küçük ve odaklı tutulmuştur.
class ThemeModeSwitchButton extends StatelessWidget {
  final ThemeController controller;

  const ThemeModeSwitchButton({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: controller.themeModeNotifier,
      builder: (context, currentMode, _) {
        final icon = switch (currentMode) {
          ThemeMode.system => Icons.brightness_auto_rounded,
          ThemeMode.dark => Icons.dark_mode_rounded,
          ThemeMode.light => Icons.light_mode_rounded,
        };

        final tooltip = switch (currentMode) {
          ThemeMode.system => 'Tema: Sistem',
          ThemeMode.dark => 'Tema: Karanlık',
          ThemeMode.light => 'Tema: Aydınlık',
        };

        return IconButton(
          icon: Icon(icon),
          tooltip: tooltip,
          onPressed: () => _showThemeSelectionSheet(context),
        );
      },
    );
  }

  void _showThemeSelectionSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return _ThemeSelectionSheet(controller: controller);
      },
    );
  }
}

class _ThemeSelectionSheet extends StatelessWidget {
  final ThemeController controller;

  const _ThemeSelectionSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SheetHeader(),
            const SizedBox(height: 12),
            _ThemeOptionTile(
              title: 'Sistem Varsayılanı',
              subtitle: 'Cihazınızın karanlık/aydınlık ayarını takip eder',
              icon: Icons.brightness_auto_rounded,
              mode: ThemeMode.system,
              controller: controller,
            ),
            _ThemeOptionTile(
              title: 'Karanlık Mod',
              subtitle: 'Obsidian siyah & neon gece spor salonu teması',
              icon: Icons.dark_mode_rounded,
              mode: ThemeMode.dark,
              controller: controller,
            ),
            _ThemeOptionTile(
              title: 'Aydınlık Mod',
              subtitle: 'Yüksek kontrastlı sportif gündüz teması',
              icon: Icons.light_mode_rounded,
              mode: ThemeMode.light,
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Tema Seçimi',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final ThemeMode mode;
  final ThemeController controller;

  const _ThemeOptionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.mode,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: controller.themeModeNotifier,
      builder: (context, currentMode, _) {
        final isSelected = currentMode == mode;
        final colorScheme = Theme.of(context).colorScheme;

        return ListTile(
          leading: Icon(
            icon,
            color: isSelected ? colorScheme.primary : colorScheme.onSurface,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? colorScheme.primary : colorScheme.onSurface,
            ),
          ),
          subtitle: Text(subtitle),
          trailing: isSelected
              ? Icon(Icons.check_circle_rounded, color: colorScheme.primary)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          onTap: () {
            controller.setThemeMode(mode);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
