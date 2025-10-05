import 'package:codo/core/widgets/tag_chip.dart';
import 'package:codo/features/my_day/cubit/my_day_cubit.dart';
import 'package:codo/features/my_day/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TaskCardWidget extends StatelessWidget {
  const TaskCardWidget(this.data, {super.key});
  final Task data;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    final daydifference = (data.dueDate != null)
        ? DateTime(2025, 3, 3).difference(data.dueDate!).inDays
        : null;
    final dueColor = (daydifference != null)
        ? daydifference < -10
              ? color.secondary
              : color.error
        : null;

    return Material(
      color: color.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          print("Card");
        },
        onLongPress: () {
          HapticFeedback.lightImpact();
          context.read<MyDayCubit>().deleteTask(data.id);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Checkbox(
                  //   value: false,
                  //   onChanged: (value) {
                  //     print("Check");
                  //   },
                  //   shape: CircleBorder(),
                  // ),

                  // Title
                  Text(
                    data.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  // Due Date
                  if (data.dueDate != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        spacing: 5,
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            color: dueColor,
                            size: 16,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 1),
                            child: Text(
                              DateFormat(
                                'HH:mm - d MMM y',
                              ).format(data.dueDate!),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: dueColor,
                                fontSize: 11,
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Note
                  if (data.note != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        data.note!,
                        style: TextStyle(
                          color: color.onSurfaceVariant,
                          fontSize: 13,
                          height: 1.53,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            if (data.tags.isNotEmpty)
              Column(
                children: [
                  Container(height: 2, color: color.surfaceContainerHighest),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 9),
                    child: Wrap(
                      runSpacing: 6,
                      children: [TagChip(data.tags.elementAt(0))],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
