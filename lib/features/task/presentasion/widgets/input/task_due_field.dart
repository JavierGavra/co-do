import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskDueField extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDueChanged;

  const TaskDueField({
    super.key,
    required this.initialDate,
    required this.onDueChanged,
  });

  @override
  State<TaskDueField> createState() => _TaskDueFieldState();
}

class _TaskDueFieldState extends State<TaskDueField> {
  late DateTime _dueDate = widget.initialDate;

  void _handleDateChanged(DateTime date) {
    _dueDate = _dueDate.copyWith(
      year: date.year,
      month: date.month,
      day: date.day,
    );
    widget.onDueChanged(_dueDate);
  }

  void _handleTimeChanged(TimeOfDay time) {
    _dueDate = _dueDate.copyWith(
      hour: time.hour,
      minute: time.minute,
      second: 0,
    );
    widget.onDueChanged(_dueDate);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Expanded(
          flex: 3,
          child: _DueDateField(
            initialDate: widget.initialDate,
            onChanged: _handleDateChanged,
          ),
        ),
        Expanded(
          child: _DueTimeField(
            initialTime: TimeOfDay.fromDateTime(widget.initialDate),
            onChanged: _handleTimeChanged,
          ),
        ),
      ],
    );
  }
}

class _DueDateField extends StatefulWidget {
  const _DueDateField({required this.initialDate, required this.onChanged});

  final DateTime initialDate;
  final ValueChanged<DateTime> onChanged;

  @override
  State<_DueDateField> createState() => _DueDateFieldState();
}

class _DueDateFieldState extends State<_DueDateField> {
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

class _DueTimeField extends StatefulWidget {
  const _DueTimeField({required this.initialTime, required this.onChanged});

  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onChanged;

  @override
  State<_DueTimeField> createState() => _DueTimeFieldState();
}

class _DueTimeFieldState extends State<_DueTimeField> {
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
