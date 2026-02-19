import 'package:codo/features/task/bloc/task_bloc.dart';
import 'package:codo/features/task/views/pages/my_day_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      create: (context) => TaskBloc()
        ..add(switch (type) {
          TaskPageType.myDay => MyDayTask(),
          TaskPageType.all => GetAllTask(),
          TaskPageType.byTag => GetAllTask(tagId: tagId),
        }),
      child: switch (type) {
        TaskPageType.myDay => MyDayView(),
        TaskPageType.all => MyDayView(),
        TaskPageType.byTag => MyDayView(),
      },
    );
  }
}
