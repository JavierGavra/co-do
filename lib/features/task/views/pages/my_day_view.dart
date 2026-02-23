import 'package:codo/core/constant/image_assets.dart';
import 'package:codo/core/utils/time/time_utils.dart';
import 'package:codo/features/task/views/widgets/add_task_bottom_sheet.dart';
import 'package:codo/features/task/bloc/task_bloc.dart';
import 'package:codo/features/task/models/task.dart';
import 'package:codo/features/task/views/widgets/task_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MyDayView extends StatefulWidget {
  const MyDayView({super.key});

  @override
  State<MyDayView> createState() => _MyDayViewState();
}

class _MyDayViewState extends State<MyDayView> {
  final double _collapsedHeight = 56;
  final double _expandedHeight = 146;

  late ScrollController _scrollController;
  final ValueNotifier<bool> _isCollapsed = ValueNotifier(false);

  void _listener(BuildContext context, TaskState state) {
    if (state.status == TaskStateStatus.success) {
      if (state.action != TaskStateAction.getTask) {
        context.read<TaskBloc>().add(MyDayTask());
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
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Image.asset(
              isDark ? ImageAssets.skyNight : ImageAssets.tvTower,
              fit: BoxFit.cover,
              height: double.infinity,
            ),
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                _sliverAppBar(color),
                BlocSelector<TaskBloc, TaskState, List<Task>>(
                  selector: (state) => state.undoneTasks,
                  builder: (context, state) {
                    return SliverVisibility(
                      visible: state.isNotEmpty,
                      sliver: SliverPadding(
                        padding: EdgeInsetsGeometry.fromLTRB(16, 32, 16, 0),
                        sliver: SliverMasonryGrid(
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          gridDelegate:
                              SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final Task model = state[index];
                            return TaskCardWidget(model);
                          }, childCount: state.length),
                        ),
                      ),
                    );
                  },
                ),

                // Sementara
                BlocSelector<TaskBloc, TaskState, List<Task>>(
                  selector: (state) => state.doneTasks,
                  builder: (context, state) {
                    return SliverPadding(
                      padding: EdgeInsetsGeometry.fromLTRB(16, 32, 16, 100),
                      sliver: SliverMasonryGrid(
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        gridDelegate:
                            SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final Task model = state[index];
                          return TaskCardWidget(model);
                        }, childCount: state.length),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final task = await showAddTaskBottomSheet(context);
            if (task != null && context.mounted) {
              context.read<TaskBloc>().add(CreateTask(task: task));
            }
          },
          backgroundColor: color.primary,
          foregroundColor: color.onPrimary,
          child: Icon(Icons.add_rounded),
        ),
      ),
    );
  }

  //============================================================================

  Widget _sliverAppBar(ColorScheme color) {
    return ValueListenableBuilder(
      valueListenable: _isCollapsed,
      builder: (context, value, child) {
        return SliverAppBar(
          pinned: true,
          foregroundColor: value ? color.onSurface : Colors.white,
          backgroundColor: value ? color.surface : Colors.transparent,
          expandedHeight: _expandedHeight,
          collapsedHeight: _collapsedHeight,
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_rounded)),
          ],
          title: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: value ? 1 : 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Selamat ${TimeUtils.currentDaylight}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    height: 1.33,
                  ),
                ),
                Text(
                  TimeUtils.currentDate,
                  style: TextStyle(fontSize: 12, height: 1.33),
                ),
              ],
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(left: 16),
            collapseMode: CollapseMode.pin,
            background: Container(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Selamat ${TimeUtils.currentDaylight}",
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                  Text(
                    TimeUtils.currentDate,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xffdee3e5),
                      height: 1.33,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
