import 'package:audioplayers/audioplayers.dart';
import 'package:codo/core/constant/audio_assets.dart';
import 'package:codo/core/utils/clipper/diagonal_clipper.dart';
import 'package:codo/core/widgets/dialog/delete_dialog.dart';
import 'package:codo/core/widgets/snackbar/custom_snackbar.dart';
import 'package:codo/features/task/bloc/task_bloc.dart';
import 'package:codo/features/task/models/tag.dart';
import 'package:codo/features/task/models/task.dart';
import 'package:codo/features/task/views/widgets/custom_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TaskCardHorizontalWidget extends StatelessWidget {
  final Task task;

  const TaskCardHorizontalWidget({super.key, required this.task});

  Future<void> _onChecked(BuildContext context) async {
    if (!task.status) {
      await AudioPlayer().play(AssetSource(AudioAssets.taskDone));
      if (context.mounted) showSnackBar(context, SnackBarType.taskComplete);
    }
    if (context.mounted) {
      context.read<TaskBloc>().add(
        CheckTask(id: task.id, status: !task.status),
      );
    }
  }

  void _onLongPress(BuildContext context) async {
    HapticFeedback.lightImpact();
    final isYes = await showDeleteDialog(context: context);
    if (isYes && context.mounted) {
      context.read<TaskBloc>().add(DeleteTask(id: task.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final borderRadius = BorderRadius.circular(4);

    final daydifference = (task.dueDate != null)
        ? DateTime.now().difference(task.dueDate!).inDays
        : null;

    final dueColor =
        (daydifference != null && !task.status && daydifference > -10)
        ? color.error
        : color.secondary;

    final isLessThan3Days = (daydifference != null && daydifference >= -3);

    return ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                color: task.status
                    ? color.surfaceContainerHigh
                    : color.secondaryContainer,
                child: InkWell(
                  onTap: () {},
                  onLongPress: () => _onLongPress(context),
                  borderRadius: borderRadius,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: CustomCheckBox(
                            value: task.status,
                            onTap: () => _onChecked(context),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 1,
                            children: [
                              _buildTitle(),
                              if (task.dueDate != null)
                                _buildDate(task.dueDate!, dueColor),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (task.tag != null) _buildTag(task.tag!),
            ],
          ),
          if (isLessThan3Days && !task.status) _warningMark(color),
        ],
      ),
    );
  }

  Widget _warningMark(ColorScheme color) {
    return Align(
      alignment: Alignment.topRight,
      child: ClipPath(
        clipper: DiagonalClipper(),
        child: Container(
          height: 24,
          width: 24,
          decoration: const BoxDecoration(
            color: Color(0xffE51111),
            borderRadius: BorderRadius.only(topRight: Radius.circular(12)),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      task.title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        height: 1.428,
        decoration: task.status ? TextDecoration.lineThrough : null,
      ),
    );
  }

  Widget _buildDate(DateTime dateTime, Color? color) {
    return Text(
      DateFormat('HH:mm - d MMM y').format(dateTime),
      style: TextStyle(
        fontSize: 11,
        color: color,
        height: 1.454,
        fontStyle: task.status ? FontStyle.italic : null,
      ),
    );
  }

  Widget _buildTag(Tag tag) {
    return Container(
      color: Colors.red,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Text(
        tag.text,
        style: TextStyle(color: Colors.white, fontSize: 11, height: 1.454),
      ),
    );
  }
}
