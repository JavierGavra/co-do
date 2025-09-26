import 'package:flutter/material.dart';

class MenuButtonWidget extends StatelessWidget {
  const MenuButtonWidget({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
    this.amount = 0,
  });
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;
  final int amount;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
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
