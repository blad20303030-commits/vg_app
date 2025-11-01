import 'dart:convert';
import 'package:http/http.dart' as http;

/// Класс для всех запросов к backend VG CRM
class ApiClient {
  /// ⚙️ Базовый URL для API
  /// Если ты тестируешь на телефоне — замени localhost на IP своего ПК
  static const String baseUrl = 'http://localhost:3000/api';

  /// 📥 Получить список сотрудников (GET)
  static Future<List<dynamic>> getEmployees() async {
    final uri = Uri.parse('$baseUrl/employees');
    final res = await http.get(uri);

    if (res.statusCode == 200) {
      final body = res.body.isEmpty ? '[]' : res.body;
      final decoded = jsonDecode(body);
      if (decoded is List) return decoded;
      throw Exception('Некорректный формат ответа (ожидался List)');
    } else {
      throw Exception('Ошибка загрузки: ${res.statusCode} ${res.body}');
    }
  }

  /// ➕ Создать сотрудника (POST)
  static Future<Map<String, dynamic>> createEmployee(
    Map<String, dynamic> data,
  ) async {
    final uri = Uri.parse('$baseUrl/employees');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (res.statusCode == 201) {
      final decoded = jsonDecode(res.body);
      if (decoded is Map<String, dynamic>) return decoded;
      throw Exception('Некорректный формат ответа (ожидался Map)');
    } else {
      throw Exception('Ошибка создания: ${res.statusCode} ${res.body}');
    }
  }

  /// ✏️ Обновить сотрудника (PUT)
  static Future<Map<String, dynamic>> updateEmployee(
    String id,
    Map<String, dynamic> data,
  ) async {
    final uri = Uri.parse('$baseUrl/employees/$id');
    final res = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      if (decoded is Map<String, dynamic>) return decoded;
      throw Exception('Некорректный формат ответа (ожидался Map)');
    } else if (res.statusCode == 404) {
      throw Exception('Сотрудник не найден');
    } else {
      throw Exception('Ошибка обновления: ${res.statusCode} ${res.body}');
    }
  }

  /// 🗑️ Удалить сотрудника (DELETE)
  static Future<void> deleteEmployee(String id) async {
    final uri = Uri.parse('$baseUrl/employees/$id');
    final res = await http.delete(uri);

    if (res.statusCode == 200) return;
    if (res.statusCode == 404) throw Exception('Сотрудник не найден');
    throw Exception('Ошибка удаления: ${res.statusCode} ${res.body}');
  }
}
