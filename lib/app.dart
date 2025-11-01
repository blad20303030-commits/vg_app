import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/modules/module_registry.dart';
import 'core/modules/module.dart';

class VGApp extends StatelessWidget {
  const VGApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VG App',
      theme: buildLightTheme(),
      debugShowCheckedModeBanner: false,
      home: const _Shell(),
    );
  }
}

class _Shell extends StatefulWidget {
  const _Shell({super.key});

  @override
  State<_Shell> createState() => _ShellState();
}

class _ShellState extends State<_Shell> {
  final _registry = ModuleRegistry.defaultModules();
  final _selected = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    final modules = _registry.modules;

    return ValueListenableBuilder<int>(
      valueListenable: _selected,
      builder: (context, index, _) {
        final AppModule current = modules[index];

        return Scaffold(
          appBar: AppBar(
            title: Text(current.title),
            elevation: 0,
            backgroundColor: const Color(0xFFF3F3F3),
            foregroundColor: const Color(0xFF212121),
          ),
          drawer: Drawer(
            backgroundColor: const Color(0xFF212121),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _BrandHeader(),
                  const Divider(height: 1, color: Colors.white24),

                  // список модулей
                  Expanded(
                    child: ListView.builder(
                      itemCount: modules.length,
                      itemBuilder: (context, i) {
                        final m = modules[i];
                        final bool isActive = i == index;
                        return _HoverTile(
                          icon: m.icon,
                          title: m.title,
                          isActive: isActive,
                          onTap: () {
                            Navigator.of(context).pop();
                            _selected.value = i;
                          },
                        );
                      },
                    ),
                  ),

                  // нижний блок профиля
                  _UserPanel(
                    onTap: () {
                      Navigator.of(context).pop();
                      final profileIndex = modules.indexWhere(
                        (m) => m.id == 'profile',
                      );
                      if (profileIndex != -1) _selected.value = profileIndex;
                    },
                  ),
                ],
              ),
            ),
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: KeyedSubtree(
              key: ValueKey(current.id),
              child: current.build(context),
            ),
          ),
        );
      },
    );
  }
}

/// ===== ЛОГОТИП (верхняя часть Drawer) =====
class _BrandHeader extends StatelessWidget {
  const _BrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF212121),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 60,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// ===== ЭЛЕМЕНТ МЕНЮ С HOVER И АКЦЕНТОМ =====
class _HoverTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _HoverTile({
    required this.title,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_HoverTile> createState() => _HoverTileState();
}

class _HoverTileState extends State<_HoverTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFDA513C);
    const normalText = Color(0xFFF3F3F3);
    const hoverBg = Color(0x33FFFFFF); // лёгкий серый при наведении

    final isActive = widget.isActive;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isActive
              ? accent
              : (_isHovered ? hoverBg : Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Icon(widget.icon, color: isActive ? normalText : normalText),
          title: Text(
            widget.title,
            style: TextStyle(
              color: isActive ? normalText : normalText,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
          onTap: widget.onTap,
        ),
      ),
    );
  }
}

/// ===== НИЖНЯЯ КАРТОЧКА ПРОФИЛЯ =====
class _UserPanel extends StatelessWidget {
  final VoidCallback onTap;
  const _UserPanel({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const name = 'Владислав Г.';
    const email = 'jackmanston@vk.com';
    const avatarUrl =
        'https://i.postimg.cc/zDK0jXBy/84f300c6-7a57-4968-a1ad-50bef27216af.jpg';

    return Container(
      color: const Color(0xFF212121),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFFF3F3F3),
              foregroundImage: NetworkImage(avatarUrl),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    name,
                    style: TextStyle(
                      color: Color(0xFFF3F3F3),
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    email,
                    style: TextStyle(color: Color(0xFFF3F3F3), fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFFF3F3F3)),
          ],
        ),
      ),
    );
  }
}
