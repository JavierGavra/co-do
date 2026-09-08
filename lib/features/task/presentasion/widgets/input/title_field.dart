import 'package:flutter/material.dart';

class TitleField extends StatelessWidget {
  final String? title;
  final TextEditingController titleController;

  const TitleField({super.key, required this.titleController, this.title});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return TextFormField(
      key: key,
      autofocus: true,
      controller: titleController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hint: Text(
          title ?? "Judul",
          style: TextStyle(
            color: color.onSurfaceVariant.withValues(alpha: 0.5),
          ),
        ),
        border: OutlineInputBorder(),
        visualDensity: VisualDensity.comfortable,
      ),
      validator: (value) {
        return (value == null || value.isEmpty) ? "Wajib di isi" : null;
      },
    );
  }
}
