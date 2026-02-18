import 'package:flutter/material.dart';

Future<void> showLoadingDialog({required BuildContext context}) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      shape: CircleBorder(),
      constraints: BoxConstraints(maxWidth: 90, maxHeight: 90),
      child: const Center(child: CircularProgressIndicator()),
    ),
  );
}
