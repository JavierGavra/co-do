import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection.dart';
import '../../../../shared/domain/entities/tag.dart';
import '../bloc/task_bloc.dart';
import 'all_task_view.dart';
import 'my_day_view.dart';
import 'tag_tasks_view.dart';

enum TaskPageType { myDay, all, byTag }

class TaskPage extends StatelessWidget {
  final TaskPageType type;
  final Tag? tag;

  const TaskPage.all({super.key}) : type = TaskPageType.all, tag = null;

  const TaskPage.myDay({super.key}) : type = TaskPageType.myDay, tag = null;

  const TaskPage.byTag({super.key, required this.tag})
    : type = TaskPageType.byTag;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TaskBloc>()
        ..add(switch (type) {
          TaskPageType.myDay => MyDayTaskEvent(),
          TaskPageType.all => GetAllTaskEvent(),
          TaskPageType.byTag => GetAllTaskEvent(tagId: tag!.id),
        }),
      child: switch (type) {
        TaskPageType.myDay => MyDayView(),
        TaskPageType.all => AllTaskView(),
        TaskPageType.byTag => TagTasksView(tag: tag!),
      },
    );
  }
}
