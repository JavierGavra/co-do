import 'package:flutter/material.dart';

enum AdditionalField { note, dueDate, tag }

class TaskAdditionalChip extends StatelessWidget {
  final ValueChanged<AdditionalField> onPressed;
  final AdditionalField fieldType;
  final String label;
  final IconData icon;
  final Color color;

  const TaskAdditionalChip({
    super.key,
    required this.onPressed,
    required this.fieldType,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).colorScheme.surfaceContainer;
    return ActionChip(
      onPressed: () => onPressed(fieldType),
      label: Text(label),
      side: BorderSide(color: color),
      backgroundColor: backgroundColor,
      avatar: Icon(icon, color: color),
      labelStyle: TextStyle(color: color),
      visualDensity: VisualDensity.comfortable,
    );
  }
}
