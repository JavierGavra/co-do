import 'package:flutter/material.dart';

class MenuButtonWidget extends StatelessWidget {
  const MenuButtonWidget({
    super.key,
    this.amount = 0,
    required this.label,
    required this.icon,
    required this.iconColor,
    this.splashColor,
    required this.onTap,
  });
  final int amount;
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color? splashColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      splashColor: splashColor,
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w500, height: 1.42),
            ),
            Spacer(),

            if (amount > 0)
              Text(
                "$amount",
                textAlign: TextAlign.right,
                style: TextStyle(color: color.onSurfaceVariant, height: 1.42),
              ),
          ],
        ),
      ),
    );
  }
}
