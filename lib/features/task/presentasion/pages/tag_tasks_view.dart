import 'package:codo/features/tag/presentasion/dialogs/rename_tag_dialog.dart';
import 'package:codo/features/task/presentasion/widgets/task_app_bar_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/domain/entities/tag.dart';
import '../../../tag/presentasion/dialogs/delete_tag_dialog.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../../../../core/utils/color/color_utils.dart';
import '../widgets/add_task_bottom_sheet.dart';
import '../widgets/empty_list_widget.dart';
import '../widgets/task_card_horizontal_widget.dart';

class TagTasksView extends StatefulWidget {
  final Tag tag;

  const TagTasksView({super.key, required this.tag});

  @override
  State<TagTasksView> createState() => _TagTasksViewState();
}

class _TagTasksViewState extends State<TagTasksView> {
  final double _collapsedHeight = 56;
  final double _expandedHeight = 146;

  // Temporary save biar title nya keubah kalau renameTag()
  late String _title;

  late ScrollController _scrollController;
  final ValueNotifier<bool> _isCollapsed = ValueNotifier(false);

  void _listener(BuildContext context, TaskState state) {
    if (state.status == TaskStateStatus.success) {
      if (state.action != TaskStateAction.getTask) {
        context.read<TaskBloc>().add(GetAllTaskEvent(tagId: widget.tag.id));
      }
    }
  }

  void _onTagRename(BuildContext context) async {
    await showRenameTagDialog(
      context: context,
      tagId: widget.tag.id,
      currentTitle: widget.tag.title,
    ).then((newTitle) {
      if (newTitle != null && context.mounted) {
        setState(() => _title = newTitle);
      }
    });
  }

  void _onTagDelete(BuildContext context) async {
    await showDeleteTagDialog(context: context, tagId: widget.tag.id).then((
      isTagDeleted,
    ) {
      if (isTagDeleted == true && context.mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _title = widget.tag.title;
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
      seedColor: ColorUtils.fromHex(widget.tag.backgroundHex),
    );

    return BlocListener<TaskBloc, TaskState>(
      listener: _listener,
      child: Scaffold(
        backgroundColor: isDark ? color.surface : color.primary,
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            _buildSliverAppBar(color, isDark),
            BlocSelector<TaskBloc, TaskState, bool>(
              selector: (state) {
                return state.undoneTasks.isEmpty && state.doneTasks.isEmpty;
              },
              builder: (context, state) {
                return SliverVisibility(
                  visible: state,
                  sliver: SliverToBoxAdapter(
                    child: EmptyListWidget(colorScheme: color),
                  ),
                );
              },
            ),

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
                );
              },
            ),
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
            // IconButton(onPressed: () {}, icon: Icon(Icons.grid_view_outlined)),
            TaskAppBarMenu(
              colorScheme: color,
              items: [
                TaskAppBarMenuItem(
                  onTap: () => _onTagRename(context),
                  icon: Icons.edit_outlined,
                  label: 'Ganti nama kategori',
                ),
                TaskAppBarMenuItem(
                  onTap: () => _onTagDelete(context),
                  icon: Icons.delete_forever_outlined,
                  label: 'Hapus kategori',
                  color: color.error,
                ),
              ],
            ),
          ],
          title: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: value ? 1 : 0,
            child: Text(
              _title,
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
                _title,
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
