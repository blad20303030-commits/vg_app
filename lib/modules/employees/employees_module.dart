import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../core/modules/module.dart';
import '../../core/theme/app_theme.dart';
import '../../core/api/api_client.dart';

class EmployeesModule extends AppModule {
  @override
  String get id => 'employees';
  @override
  String get title => 'Сотрудники';
  @override
  IconData get icon => Icons.people;
  @override
  Widget build(BuildContext context) => const _EmployeesPage();
}

class _EmployeesPage extends StatefulWidget {
  const _EmployeesPage();

  @override
  State<_EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<_EmployeesPage> {
  List<Employee> _employees = [];
  bool _isLoading = false;
  String? _error;

  String _query = '';
  String _roleFilter = 'Все роли';
  String _branchFilter = 'Все филиалы';

  static const List<String> _roles = [
    'Все роли',
    'Оператор',
    'Менеджер',
    'Администратор',
    'Управляющий',
  ];

  static const List<String> _branches = [
    'Все филиалы',
    'Бутово',
    'Охотный ряд',
    'Римская',
    'Химки 2а',
    'Химки 3а',
  ];

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await ApiClient.getEmployees();
      final items = data
          .whereType<Map<String, dynamic>>()
          .map(Employee.fromJson)
          .toList();
      setState(() => _employees = items);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<Employee> _filteredEmployees() {
    final q = _query.trim().toLowerCase();
    final filtered = _employees.where((e) {
      final roleOk = _roleFilter == 'Все роли' || e.role == _roleFilter;
      final branchOk =
          _branchFilter == 'Все филиалы' || e.branch == _branchFilter;
      if (q.isEmpty) return roleOk && branchOk;

      final name = ('${e.firstName} ${e.lastName}').toLowerCase();
      final email = (e.email).toLowerCase();
      final phone = e.phone;
      final qDigits = q.replaceAll(RegExp(r'[^0-9+]'), '');

      final hit =
          name.contains(q) ||
          email.contains(q) ||
          phone.replaceAll(RegExp(r'[^0-9+]'), '').contains(qDigits);

      return roleOk && branchOk && hit;
    }).toList();
    return filtered;
  }

  Future<void> _addEmployee() async {
    final dto = await showDialog<_SimpleEmployeeDTO>(
      context: context,
      builder: (_) => const _EmployeeDialog(),
    );
    if (dto == null) return;

    try {
      await ApiClient.createEmployee({
        'firstName': dto.firstName,
        'lastName': dto.lastName,
        'role': dto.role,
        'branch': dto.branch,
        'email': dto.email,
        'phone': dto.phone,
        'isActive': dto.isActive,
      });
      await _loadEmployees();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Сотрудник создан')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка создания: $e')));
    }
  }

  Future<void> _editEmployee(Employee e) async {
    final dto = await showDialog<_SimpleEmployeeDTO>(
      context: context,
      builder: (_) =>
          _EmployeeDialog(initial: e, title: 'Редактировать сотрудника'),
    );
    if (dto == null) return;

    try {
      await ApiClient.updateEmployee(e.id, {
        'firstName': dto.firstName,
        'lastName': dto.lastName,
        'role': dto.role,
        'branch': dto.branch,
        'email': dto.email,
        'phone': dto.phone,
        'isActive': dto.isActive,
      });
      await _loadEmployees();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Изменения сохранены')));
    } catch (err) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка сохранения: $err')));
    }
  }

  void _confirmDelete(Employee e) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Удалить сотрудника?'),
        content: Text(
          'Вы уверены, что хотите удалить ${e.firstName} ${e.lastName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ApiClient.deleteEmployee(e.id);
                await _loadEmployees();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Сотрудник удалён')),
                );
              } catch (err) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ошибка удаления: $err')),
                );
              }
            },
            child: const Text('Удалить', style: TextStyle(color: vgPrimary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredEmployees();
    return Scaffold(
      backgroundColor: vgSurface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок и кнопки
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Сотрудники',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: vgTextMain,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _loadEmployees,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Обновить'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: vgSurface,
                          foregroundColor: vgTextMain,
                          side: const BorderSide(color: vgPrimary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: _addEmployee,
                        icon: const Icon(Icons.add),
                        label: const Text('Добавить'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: vgPrimary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Поиск и фильтры
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: 260,
                    child: TextField(
                      onChanged: (v) => setState(() => _query = v),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Поиск (имя, email, телефон)…',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: DropdownButtonFormField<String>(
                      value: _roleFilter,
                      items: _roles
                          .map(
                            (r) => DropdownMenuItem(value: r, child: Text(r)),
                          )
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _roleFilter = v ?? _roleFilter),
                      decoration: InputDecoration(
                        labelText: 'Роль',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: DropdownButtonFormField<String>(
                      value: _branchFilter,
                      items: _branches
                          .map(
                            (b) => DropdownMenuItem(value: b, child: Text(b)),
                          )
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _branchFilter = v ?? _branchFilter),
                      decoration: InputDecoration(
                        labelText: 'Филиал',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Таблица
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                    ? Center(child: Text('Ошибка: $_error'))
                    : filtered.isEmpty
                    ? const Center(child: Text('Нет сотрудников'))
                    : RefreshIndicator(
                        onRefresh: _loadEmployees,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingTextStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: vgTextMain,
                              ),
                              columns: const [
                                DataColumn(label: Text('Имя')),
                                DataColumn(label: Text('Роль')),
                                DataColumn(label: Text('Филиал')),
                                DataColumn(label: Text('Email')),
                                DataColumn(label: Text('Телефон')),
                                DataColumn(label: Text('Статус')),
                                DataColumn(label: Text('Действия')),
                              ],
                              rows: filtered.map((e) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Text('${e.firstName} ${e.lastName}'),
                                    ),
                                    DataCell(Text(e.role)),
                                    DataCell(Text(e.branch)),
                                    DataCell(Text(e.email)),
                                    DataCell(Text(e.phone)),
                                    DataCell(
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            size: 10,
                                            color: e.isActive
                                                ? Colors.green
                                                : Colors.grey,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            e.isActive ? 'Активен' : 'Архив',
                                          ),
                                        ],
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        children: [
                                          IconButton(
                                            tooltip: 'Редактировать',
                                            icon: const Icon(
                                              Icons.edit,
                                              color: vgTextMain,
                                            ),
                                            onPressed: () => _editEmployee(e),
                                          ),
                                          IconButton(
                                            tooltip: 'Удалить',
                                            icon: const Icon(
                                              Icons.delete_outline,
                                              color: vgPrimary,
                                            ),
                                            onPressed: () => _confirmDelete(e),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────────
//  Диалог добавления / редактирования
// ───────────────────────────────
class _EmployeeDialog extends StatefulWidget {
  final Employee? initial;
  final String title;
  const _EmployeeDialog({this.initial, this.title = 'Добавить сотрудника'});

  @override
  State<_EmployeeDialog> createState() => _EmployeeDialogState();
}

class _EmployeeDialogState extends State<_EmployeeDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstName;
  late TextEditingController _lastName;
  late TextEditingController _email;
  late TextEditingController _phone;

  final _phoneMask = MaskTextInputFormatter(
    mask: '+7 (###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  String _role = 'Менеджер';
  String _branch = 'Бутово';
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    _firstName = TextEditingController(text: i?.firstName ?? '');
    _lastName = TextEditingController(text: i?.lastName ?? '');
    _email = TextEditingController(text: i?.email ?? '');
    _phone = TextEditingController(text: i?.phone ?? '');
    _role = i?.role ?? 'Менеджер';
    _branch = i?.branch ?? 'Бутово';
    _isActive = i?.isActive ?? true;
  }

  bool _isPhoneValid(String masked) {
    final digits = masked.replaceAll(RegExp(r'\D'), '');
    return digits.length == 11 && digits.startsWith('7');
  }

  final RegExp _emailRegex = RegExp(
    r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$',
    caseSensitive: false,
  );

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: vgTextMain,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstName,
                        decoration: const InputDecoration(labelText: 'Имя'),
                        textCapitalization: TextCapitalization.words,
                        onChanged: (v) {
                          final c = _capitalize(v);
                          if (v != c) {
                            _firstName.value = _firstName.value.copyWith(
                              text: c,
                              selection: TextSelection.collapsed(
                                offset: c.length,
                              ),
                            );
                          }
                        },
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Введите имя'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _lastName,
                        decoration: const InputDecoration(labelText: 'Фамилия'),
                        textCapitalization: TextCapitalization.words,
                        onChanged: (v) {
                          final c = _capitalize(v);
                          if (v != c) {
                            _lastName.value = _lastName.value.copyWith(
                              text: c,
                              selection: TextSelection.collapsed(
                                offset: c.length,
                              ),
                            );
                          }
                        },
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Введите фамилию'
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _role,
                        items:
                            const [
                                  'Менеджер',
                                  'Оператор',
                                  'Администратор',
                                  'Управляющий',
                                ]
                                .map(
                                  (r) => DropdownMenuItem(
                                    value: r,
                                    child: Text(r),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) => setState(() => _role = v ?? _role),
                        decoration: const InputDecoration(labelText: 'Роль'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _branch,
                        items:
                            const [
                                  'Бутово',
                                  'Охотный ряд',
                                  'Римская',
                                  'Химки 2а',
                                  'Химки 3а',
                                ]
                                .map(
                                  (b) => DropdownMenuItem(
                                    value: b,
                                    child: Text(b),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) =>
                            setState(() => _branch = v ?? _branch),
                        decoration: const InputDecoration(labelText: 'Филиал'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  validator: (v) {
                    final value = (v ?? '').trim();
                    if (value.isEmpty) return 'Введите email';
                    if (!_emailRegex.hasMatch(value))
                      return 'Некорректный email';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phone,
                  decoration: const InputDecoration(
                    labelText: 'Телефон (+7 ...)',
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    _phoneMask,
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9+\s\-\(\)]'),
                    ),
                  ],
                  validator: (v) {
                    final value = (v ?? '').trim();
                    if (value.isEmpty) return 'Введите телефон';
                    if (!_isPhoneValid(value)) {
                      return 'Телефон в формате +7 (900) 123-45-67';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('Активен'),
                  value: _isActive,
                  onChanged: (v) => setState(() => _isActive = v),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Отмена'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: vgPrimary,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) return;
                          Navigator.pop(
                            context,
                            _SimpleEmployeeDTO(
                              firstName: _firstName.text.trim(),
                              lastName: _lastName.text.trim(),
                              role: _role,
                              branch: _branch,
                              email: _email.text.trim(),
                              phone: _phone.text.trim(),
                              isActive: _isActive,
                            ),
                          );
                        },
                        child: const Text('Сохранить'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SimpleEmployeeDTO {
  final String firstName;
  final String lastName;
  final String role;
  final String branch;
  final String email;
  final String phone;
  final bool isActive;

  _SimpleEmployeeDTO({
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.branch,
    required this.email,
    required this.phone,
    required this.isActive,
  });
}

class Employee {
  final String id;
  final String firstName;
  final String lastName;
  final String role;
  final String branch;
  final String email;
  final String phone;
  final bool isActive;

  Employee({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.branch,
    required this.email,
    required this.phone,
    required this.isActive,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      firstName: (json['firstName'] ?? '').toString(),
      lastName: (json['lastName'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
      branch: (json['branch'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      isActive: (json['isActive'] ?? true) == true,
    );
  }
}
