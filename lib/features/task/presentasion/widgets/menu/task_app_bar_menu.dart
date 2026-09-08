import 'package:flutter/material.dart';

class TaskAppBarMenuItem {
  final VoidCallback onTap;
  final IconData icon;
  final String label;
  final Color? color;

  const TaskAppBarMenuItem({
    required this.onTap,
    required this.icon,
    required this.label,
    this.color,
  });
}

class TaskAppBarMenu extends StatelessWidget {
  final List<TaskAppBarMenuItem> items;
  final ColorScheme? colorScheme;

  const TaskAppBarMenu({super.key, required this.items, this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final color = colorScheme ?? Theme.of(context).colorScheme;
    return PopupMenuButton(
      itemBuilder: (context) {
        return items
            .map(
              (item) => PopupMenuItem(
                onTap: item.onTap,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8,
                  children: [
                    Icon(item.icon, color: item.color ?? color.onSurface),
                    Text(
                      item.label,
                      style: TextStyle(color: item.color ?? color.onSurface),
                    ),
                  ],
                ),
              ),
            )
            .toList();
      },
    );
  }
}
