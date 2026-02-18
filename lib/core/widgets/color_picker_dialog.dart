import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

Future<Color> showColorPickerDialog({
  required BuildContext context,
  Color initialColor = Colors.red,
}) async {
  final selectedColor = await showDialog<Color>(
    context: context,
    builder: (context) => _ColorPickerDialog(initialColor: initialColor),
  );

  return selectedColor ?? initialColor;
}

class _ColorPickerDialog extends StatefulWidget {
  final Color initialColor;

  const _ColorPickerDialog({required this.initialColor});

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late Color _currentColor;

  final _availableColor = <Color>[
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  @override
  void initState() {
    super.initState();
    _currentColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.only(bottom: 12),
      actionsPadding: const EdgeInsets.only(bottom: 16, right: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlockPicker(
          pickerColor: _currentColor,
          availableColors: _availableColor,
          onColorChanged: (value) => _currentColor = value,
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_currentColor),
          child: const Text('Pilih'),
        ),
      ],
    );
  }
}
