import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:codo/core/constant/audio_assets.dart';
import 'package:codo/core/utils/clipper/diagonal_clipper.dart';
import 'package:codo/core/widgets/snackbar/custom_snackbar.dart';
import 'package:codo/core/widgets/dialog/delete_dialog.dart';
import '../../../tag/presentasion/widgets/tag_chip.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import 'custom_check_box.dart';

class TaskCardWidget extends StatelessWidget {
  const TaskCardWidget(this.task, {super.key});
  final Task task;

  Future<void> _onChecked(BuildContext context) async {
    if (!task.status) {
      await AudioPlayer().play(AssetSource(AudioAssets.taskDone));
      if (context.mounted) showSnackBar(context, SnackBarType.taskComplete);
    }
    if (context.mounted) {
      context.read<TaskBloc>().add(
        CheckTaskEvent(id: task.id!, status: !task.status),
      );
    }
  }

  void _onLongPress(BuildContext context) async {
    HapticFeedback.lightImpact();
    final isYes = await showDeleteDialog(context: context);
    if (isYes && context.mounted) {
      context.read<TaskBloc>().add(DeleteTaskEvent(id: task.id!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    final daydifference = (task.dueDate != null)
        ? DateTime.now().difference(task.dueDate!).inDays
        : null;

    final dueColor =
        (daydifference != null && !task.status && daydifference > -10)
        ? color.error
        : color.secondary;

    final isLessThan3Days = (daydifference != null && daydifference >= -3);

    return Material(
      color: task.status ? color.surfaceDim : color.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          // print("Card");
        },
        onLongPress: () => _onLongPress(context),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: CustomCheckBox(
                      value: task.status,
                      onTap: () => _onChecked(context),
                    ),
                  ),
                  if (isLessThan3Days && !task.status) _warningMark(),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(12, 7, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title(color),
                  if (task.dueDate != null) _dueDate(dueColor),
                  if (task.note != null) _note(color),
                ],
              ),
            ),

            if (task.tag != null) _tags(color),
          ],
        ),
      ),
    );
  }

  Widget _warningMark() {
    return ClipPath(
      clipper: DiagonalClipper(),
      child: Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          color: Color(0xffE51111),
          borderRadius: BorderRadius.only(topRight: Radius.circular(12)),
        ),
      ),
    );
  }

  Widget _title(ColorScheme color) {
    return Text(
      task.title,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        height: 1.5,
        color: task.status ? color.onSurfaceVariant : color.onSurface,
        decoration: task.status ? TextDecoration.lineThrough : null,
      ),
    );
  }

  dynamic _dueDate(Color? dueColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          Icon(Icons.calendar_month_outlined, color: dueColor, size: 16),
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Text(
              DateFormat('HH:mm - d MMM y').format(task.dueDate!),
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
    );
  }

  Widget _note(ColorScheme color) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        task.note!,
        style: TextStyle(
          color: color.onSurfaceVariant,
          fontSize: 13,
          height: 1.53,
        ),
      ),
    );
  }

  Widget _tags(ColorScheme color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 2, color: color.surfaceContainerHighest),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 9),
          child: Wrap(runSpacing: 6, children: [TagChip(task.tag!)]),
        ),
      ],
    );
  }
}
