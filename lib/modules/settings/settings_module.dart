import 'package:flutter/material.dart';
import '../../core/modules/module.dart';

class SettingsModule extends AppModule {
  @override
  String get id => 'settings';

  @override
  String get title => 'Настройки';

  @override
  IconData get icon => Icons.settings_rounded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text('Настройки приложения', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SwitchListTile(
                    value: true,
                    onChanged: (_) {},
                    title: const Text('Материальный дизайн (Material 3)'),
                    subtitle: const Text('Включено по умолчанию'),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Тема'),
                    subtitle: const Text('Светлая (по умолчанию)'),
                    trailing: const Icon(Icons.palette_outlined),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              title: const Text('О приложении'),
              subtitle: const Text('VG App • ядро CRM\nВерсия: 0.1.0 (dev)'),
              trailing: const Icon(Icons.info_outline_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
