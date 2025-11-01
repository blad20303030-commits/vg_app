import 'package:flutter/material.dart';
import '../../core/modules/module.dart';

class SalariesModule extends AppModule {
  @override
  String get id => 'salaries';

  @override
  String get title => 'Зарплаты';

  @override
  IconData get icon => Icons.payments_rounded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Модуль зарплат', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.calculate_rounded),
              title: const Text('Расчёт зарплат'),
              subtitle: const Text('Пока тестовый экран без логики'),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
