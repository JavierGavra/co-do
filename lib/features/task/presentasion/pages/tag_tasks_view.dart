import 'package:codo/features/task/domain/entities/task.dart';
import 'package:codo/features/task/presentasion/bloc/task_bloc.dart';
import 'package:codo/features/task/presentasion/widgets/add_task_bottom_sheet.dart';
import 'package:codo/features/task/presentasion/widgets/task_card_horizontal_widget.dart';
import 'package:codo/shared/domain/entities/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TagTasksView extends StatefulWidget {
  final Tag tag;

  const TagTasksView({super.key, required this.tag});

  @override
  State<TagTasksView> createState() => _TagTasksViewState();
}

class _TagTasksViewState extends State<TagTasksView> {
  late final Color seedColor;
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
    seedColor = Color(int.parse('0xFF${widget.tag.backgroundHex}'));
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
    final isDark = Theme.brightnessOf(context) == Brightness.dark;
    final color = ColorScheme.fromSeed(
      contrastLevel: isDark ? 0 : -0.1,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
      brightness: Theme.brightnessOf(context),
      seedColor: seedColor,
    );

    return BlocListener<TaskBloc, TaskState>(
      listener: _listener,
      child: Scaffold(
        backgroundColor: isDark ? color.surface : color.primary,
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            _buildSliverAppBar(color, isDark),
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
                        return TaskCardHorizontalWidget(
                          task: task,
                          colorScheme: color,
                          showTag: false,
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 5),
                    ),
                    // sliver: SliverMasonryGrid(
                    //   mainAxisSpacing: 10,
                    //   crossAxisSpacing: 10,
                    //   gridDelegate:
                    //       SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    //         crossAxisCount: 2,
                    //       ),
                    //   delegate: SliverChildBuilderDelegate((context, index) {
                    //     final task = state[index];
                    //     return TaskCardWidget(
                    //       task,
                    //       colorScheme: color,
                    //       showTag: false,
                    //     );
                    //   }, childCount: state.length),
                    // ),
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
                      return TaskCardHorizontalWidget(
                        task: task,
                        colorScheme: color,
                        showTag: false,
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 5),
                  ),
                  // sliver: SliverMasonryGrid(
                  //   mainAxisSpacing: 10,
                  //   crossAxisSpacing: 10,
                  //   gridDelegate:
                  //       SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  //         crossAxisCount: 2,
                  //       ),
                  //   delegate: SliverChildBuilderDelegate((context, index) {
                  //     final Task task = state[index];
                  //     return TaskCardWidget(
                  //       task,
                  //       colorScheme: color,
                  //       showTag: false,
                  //     );
                  //   }, childCount: state.length),
                  // ),
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

  Widget _buildSliverAppBar(ColorScheme color, bool isDark) {
    return ValueListenableBuilder(
      valueListenable: _isCollapsed,
      builder: (context, value, child) {
        return SliverAppBar(
          pinned: true,
          foregroundColor: isDark ? color.primary : color.onPrimary,
          backgroundColor: isDark ? color.surface : color.primary,
          scrolledUnderElevation: 0,
          expandedHeight: _expandedHeight,
          collapsedHeight: _collapsedHeight,
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_rounded)),
          ],
          title: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: value ? 1 : 0,
            child: Text(
              widget.tag.title,
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
                widget.tag.title,
                style: TextStyle(
                  fontSize: 32,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                  color: isDark ? color.primary : color.onPrimary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
