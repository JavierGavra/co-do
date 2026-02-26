import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DueDateField extends StatefulWidget {
  const DueDateField({
    super.key,
    required this.initialDate,
    required this.onChanged,
  });

  final DateTime initialDate;
  final ValueChanged<DateTime> onChanged;

  @override
  State<DueDateField> createState() => _DueDateFieldState();
}

class _DueDateFieldState extends State<DueDateField> {
  final ValueNotifier<DateTime> _selectedate = ValueNotifier(DateTime.now());

  @override
  void initState() {
    super.initState();
    widget.onChanged(_selectedate.value);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Material(
      color: color.errorContainer,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: () async {
          _selectedate.value =
              await showDatePicker(
                context: context,
                initialDate: _selectedate.value,
                firstDate: widget.initialDate.subtract(
                  const Duration(days: 60),
                ),
                lastDate: widget.initialDate.add(const Duration(days: 60)),
              ) ??
              _selectedate.value;

          widget.onChanged(_selectedate.value);
        },
        borderRadius: BorderRadius.circular(4),
        child: Ink(
          height: 52,
          padding: EdgeInsets.only(left: 16, right: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 5,
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 20,
                color: color.onErrorContainer,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: ValueListenableBuilder(
                  valueListenable: _selectedate,
                  builder: (context, value, child) {
                    return Text(
                      DateFormat("d MMMM y").format(value),
                      style: TextStyle(
                        color: color.onErrorContainer,
                        fontWeight: FontWeight.w500,
                        height: 1.42,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
