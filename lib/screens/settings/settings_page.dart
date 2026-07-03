import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Theme mode',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(value: ThemeMode.system, label: Text('System')),
              ButtonSegment(value: ThemeMode.light, label: Text('Light')),
              ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
            ],
            selected: {theme.mode},
            onSelectionChanged: (v) => theme.setThemeMode(v.first),
          ),
          const SizedBox(height: 24),
          const Text(
            'Accent color',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: [
              _ColorDot(color: Colors.green),
              _ColorDot(color: Colors.blue),
              _ColorDot(color: Colors.purple),
              _ColorDot(color: Colors.orange),
              _ColorDot(color: Colors.pink),
            ],
          ),
        ],
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;
  const _ColorDot({required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppThemeController>();
    final isSelected = theme.seedColor.value == color.value;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => theme.setSeedColor(color),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                )
              : null,
        ),
        child: CircleAvatar(
          backgroundColor: color,
          radius: 16,
        ),
      ),
    );
  }
}