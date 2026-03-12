import 'package:codo/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/task_bloc.dart';
import 'my_day_view.dart';
import 'all_task_view.dart';

enum TaskPageType { myDay, all, byTag }

class TaskPage extends StatelessWidget {
  final TaskPageType type;
  final int? tagId;

  const TaskPage.all({super.key}) : type = TaskPageType.all, tagId = null;

  const TaskPage.myDay({super.key}) : type = TaskPageType.myDay, tagId = null;

  const TaskPage.byTag({super.key, required this.tagId})
    : type = TaskPageType.byTag;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TaskBloc>()
        ..add(switch (type) {
          TaskPageType.myDay => MyDayTaskEvent(),
          TaskPageType.all => GetAllTaskEvent(),
          TaskPageType.byTag => GetAllTaskEvent(tagId: tagId),
        }),
      child: switch (type) {
        TaskPageType.myDay => MyDayView(),
        TaskPageType.all => AllTaskView(),
        TaskPageType.byTag => MyDayView(),
      },
    );
  }
}
