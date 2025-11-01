import 'package:flutter/material.dart';
import '../../core/modules/module.dart';

class EmployeesModule extends AppModule {
  @override
  String get id => 'employees';

  @override
  String get title => 'Сотрудники';

  @override
  IconData get icon => Icons.people_alt_rounded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Сотрудники и роли', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.person_add_alt_1_rounded),
              title: const Text('Добавить сотрудника'),
              subtitle: const Text(
                'Создание нового пользователя и назначение роли',
              ),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.groups_2_rounded),
              title: const Text('Список сотрудников'),
              subtitle: const Text('Просмотр и редактирование'),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
