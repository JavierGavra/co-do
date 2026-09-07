import 'package:flutter/material.dart';

class TaskNoteField extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const TaskNoteField({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return TextField(
      onChanged: onChanged,
      textInputAction: TextInputAction.newline,
      maxLines: null,
      style: const TextStyle(fontSize: 13, height: 1.53),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(),
        labelText: "Catatan",
        hintText: "Catatan...",
        hintStyle: TextStyle(
          color: color.onSurfaceVariant.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
