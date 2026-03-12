import 'package:flutter/material.dart';

SnackBar _createSnackBar(BuildContext context, SnackBarType type) {
  final color = Theme.of(context).colorScheme;
  Widget content = SizedBox();
  Color? backgroundColor;

  if (type == SnackBarType.taskComplete) {
    content = Row(
      children: [
        Icon(Icons.thumb_up, size: 18, color: color.inversePrimary),
        SizedBox(width: 15),
        Text(
          "Task Complete ;)",
          style: TextStyle(color: color.onInverseSurface),
        ),
      ],
    );
  } else if (type == SnackBarType.failure) {
    backgroundColor = color.error;
    content = Row(
      children: [
        Text("Terjadi kesalahan", style: TextStyle(color: color.onError)),
      ],
    );
  }

  return SnackBar(
    duration: const Duration(seconds: 1),
    backgroundColor: backgroundColor,
    content: content,
    showCloseIcon: true,
  );
}

enum SnackBarType { taskComplete, failure }

void showSnackBar(BuildContext context, SnackBarType type) {
  ScaffoldMessenger.of(context).showSnackBar(_createSnackBar(context, type));
}
