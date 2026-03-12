import 'package:flutter/material.dart';

Future<bool> showDeleteDialog({required BuildContext context}) async {
  final color = Theme.of(context).colorScheme;
  final response = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Yakin ingin menghapus?"),
        titleTextStyle: TextStyle(fontSize: 16, color: color.onSurface),
        actionsPadding: EdgeInsets.only(right: 12, bottom: 16, top: 10),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Tidak"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Ya", style: TextStyle(color: color.error)),
          ),
        ],
      );
    },
  );
  return response ?? false;
}
