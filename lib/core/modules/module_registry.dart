import 'package:flutter/material.dart';

import 'module.dart';

// Активные модули
import '../../modules/employees/employees_module.dart';
import '../../modules/salaries/salaries_module.dart';
import '../../modules/knowledge/knowledge_module.dart';
import '../../modules/settings/settings_module.dart';
import '../../modules/profile/profile_module.dart';

/// Реестр всех подключённых модулей VG App.
/// Теперь без "Главной" — приложение стартует сразу с первого модуля.
class ModuleRegistry {
  final List<AppModule> modules;

  ModuleRegistry({required this.modules});

  /// Основная конфигурация активных модулей.
  factory ModuleRegistry.defaultModules() {
    return ModuleRegistry(
      modules: [
        EmployeesModule(), // Сотрудники и роли
        SalariesModule(), // Зарплаты
        KnowledgeModule(), // База знаний
        SettingsModule(), // Настройки
        ProfileModule(), // ← Личный кабинет
      ],
    );
  }

  /// Добавление модуля
  ModuleRegistry enable(AppModule module) =>
      ModuleRegistry(modules: [...modules, module]);

  /// Отключение модуля по ID
  ModuleRegistry disableById(String id) =>
      ModuleRegistry(modules: modules.where((m) => m.id != id).toList());

  /// Поиск модуля по ID
  AppModule? findById(String id) {
    try {
      return modules.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }
}
