import 'package:flutter/material.dart';
import '../../core/modules/module.dart';

class ProfileModule extends AppModule {
  @override
  String get id => 'profile';

  @override
  String get title => 'Личный кабинет';

  @override
  IconData get icon => Icons.person_rounded;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    // Заглушки — подменим на реальные данные позже
    const name = 'Владислав Г.';
    const email = 'jackmanston@vk.com';
    const role = 'Управляющий';
    const photo =
        'https://i.postimg.cc/zDK0jXBy/84f300c6-7a57-4968-a1ad-50bef27216af.jpg';

    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundImage: NetworkImage(photo),
              backgroundColor: t.colorScheme.primary.withOpacity(0.2),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              name,
              style: t.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Center(
            child: Text(
              email,
              style: t.textTheme.bodyMedium?.copyWith(
                color: t.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: const Icon(Icons.badge_outlined),
              title: const Text('Роль'),
              subtitle: Text(role),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.account_circle_outlined),
              title: const Text('Редактировать профиль'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Редактирование пока не реализовано'),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.red),
              title: const Text('Выйти из аккаунта'),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
