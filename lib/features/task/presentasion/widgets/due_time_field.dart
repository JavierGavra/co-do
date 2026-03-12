import 'package:flutter/material.dart';

class DueTimeField extends StatefulWidget {
  const DueTimeField({
    super.key,
    required this.initialTime,
    required this.onChanged,
  });

  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onChanged;

  @override
  State<DueTimeField> createState() => _DueTimeFieldState();
}

class _DueTimeFieldState extends State<DueTimeField> {
  late final ValueNotifier<TimeOfDay> _selecteTime;

  @override
  void initState() {
    super.initState();
    _selecteTime = ValueNotifier(widget.initialTime);
    widget.onChanged(_selecteTime.value);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Material(
      color: color.primaryContainer,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: () async {
          _selecteTime.value =
              await showTimePicker(
                context: context,
                initialTime: _selecteTime.value,
              ) ??
              _selecteTime.value;

          widget.onChanged(_selecteTime.value);
        },
        borderRadius: BorderRadius.circular(4),
        child: Ink(
          height: 52,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: ValueListenableBuilder(
              valueListenable: _selecteTime,
              builder: (context, value, child) {
                return Text(
                  value.format(context),
                  style: TextStyle(height: 1.42, fontWeight: FontWeight.w500),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
