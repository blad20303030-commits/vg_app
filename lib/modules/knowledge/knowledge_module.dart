import 'package:flutter/material.dart';
import '../../core/modules/module.dart';

class KnowledgeModule extends AppModule {
  @override
  String get id => 'knowledge';

  @override
  String get title => 'База знаний';

  @override
  IconData get icon => Icons.menu_book_rounded;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text('База знаний', style: t.textTheme.headlineSmall),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.school_rounded),
              title: const Text('Материалы для обучения'),
              subtitle: const Text('Регламенты, инструкции, документация'),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.folder_special_rounded),
              title: const Text('По отделам'),
              subtitle: const Text('Контент по роли сотрудника'),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
