import 'package:flutter/material.dart';

/// Базовый контракт для модулей.
/// На V1 у нас простая навигация: модуль сам даёт Widget для отрисовки.
abstract class AppModule {
  String get id; // уникальный ключ модуля
  String get title; // имя в меню
  IconData get icon; // иконка в меню
  Widget build(BuildContext context);
}
