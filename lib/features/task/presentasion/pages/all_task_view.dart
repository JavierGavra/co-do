import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../widgets/add_task_bottom_sheet.dart';
import '../widgets/task_card_horizontal_widget.dart';

class AllTaskView extends StatefulWidget {
  const AllTaskView({super.key});

  @override
  State<AllTaskView> createState() => _AllTaskViewState();
}

class _AllTaskViewState extends State<AllTaskView> {
  final double _collapsedHeight = 56;
  final double _expandedHeight = 146;

  late ScrollController _scrollController;
  final ValueNotifier<bool> _isCollapsed = ValueNotifier(false);

  void _listener(BuildContext context, TaskState state) {
    if (state.status == TaskStateStatus.success) {
      if (state.action != TaskStateAction.getTask) {
        context.read<TaskBloc>().add(GetAllTaskEvent());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        _isCollapsed.value =
            _scrollController.hasClients &&
            _scrollController.offset > (_expandedHeight - _collapsedHeight);
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _isCollapsed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final isDark = Theme.brightnessOf(context) == Brightness.dark;

    return BlocListener<TaskBloc, TaskState>(
      listener: _listener,
      child: Scaffold(
        backgroundColor: isDark ? color.surface : color.secondary,
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            _sliverAppBar(color, isDark),
            BlocSelector<TaskBloc, TaskState, List<Task>>(
              selector: (state) => state.undoneTasks,
              builder: (context, state) {
                return SliverVisibility(
                  visible: state.isNotEmpty,
                  sliver: SliverPadding(
                    padding: EdgeInsetsGeometry.fromLTRB(16, 24, 16, 0),
                    sliver: SliverList.separated(
                      itemCount: state.length,
                      itemBuilder: (context, index) {
                        final task = state[index];
                        return TaskCardHorizontalWidget(task: task);
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 5),
                    ),
                  ),
                );
              },
            ),

            BlocSelector<TaskBloc, TaskState, List<Task>>(
              selector: (state) => state.doneTasks,
              builder: (context, state) {
                return SliverPadding(
                  padding: EdgeInsetsGeometry.fromLTRB(16, 24, 16, 100),
                  sliver: SliverList.separated(
                    itemCount: state.length,
                    itemBuilder: (context, index) {
                      final task = state[index];
                      return TaskCardHorizontalWidget(task: task);
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 5),
                  ),
                );
              },
            ),
            SliverToBoxAdapter(child: SizedBox(height: 2000)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final task = await showAddTaskBottomSheet(context);
            if (task != null && context.mounted) {
              context.read<TaskBloc>().add(CreateTaskEvent(task: task));
            }
          },
          backgroundColor: color.primaryContainer,
          foregroundColor: color.onPrimaryContainer,
          child: Icon(Icons.add_rounded),
        ),
      ),
    );
  }
  //============================================================================

  Widget _sliverAppBar(ColorScheme color, bool isDark) {
    return ValueListenableBuilder(
      valueListenable: _isCollapsed,
      builder: (context, value, child) {
        return SliverAppBar(
          pinned: true,
          foregroundColor: isDark ? color.secondary : Colors.white,
          backgroundColor: isDark ? color.surface : color.secondary,
          expandedHeight: _expandedHeight,
          collapsedHeight: _collapsedHeight,
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_rounded)),
          ],
          title: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: value ? 1 : 0,
            child: Text(
              "Semua Tugas",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 1.33,
              ),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(left: 16),
            collapseMode: CollapseMode.pin,
            background: Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(left: 16),
              child: Text(
                "Semua Tugas",
                style: TextStyle(
                  fontSize: 32,
                  height: 1.5,
                  color: isDark ? color.secondary : Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
