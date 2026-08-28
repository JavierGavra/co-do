import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../core/utils/time/time_utils.dart';
import '../../../../core/widgets/dialog/loading_dialog.dart';
import '../../../../core/widgets/snackbar/custom_snackbar.dart';
import '../../../tag/presentasion/dialogs/create_tags_dialog.dart';
import '../../../task/presentasion/pages/task_page.dart';
import '../../domain/entities/tag_menu_item.dart';
import '../bloc/menu_bloc.dart';
import '../widgets/menu_button_widget.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  void _nextPage(BuildContext context, Widget page) async {
    await context.pushTransition(
      type: PageTransitionType.rightToLeft,
      curve: Curves.easeInOutCubic,
      child: page,
    );
    if (context.mounted) context.read<MenuBloc>().add(MenuReloadRequested());
  }

  void _listener(BuildContext context, MenuState state) {
    if (state.status == MenuStateStatus.loading) {
      showLoadingDialog(context: context);
    } else if (state.status == MenuStateStatus.success) {
      Navigator.of(context).pop();
      if (state.isMenuStarted && context.mounted) {
        _nextPage(context, const TaskPage.myDay());
      }
    } else if (state.status == MenuStateStatus.failure) {
      showSnackBar(context, SnackBarType.failure);
    }
  }

  void _onCreateTag(BuildContext context) async {
    final tag = await showCreateTagsDialog(context: context);
    if (tag != null && context.mounted) {
      context.read<MenuBloc>().add(
        MenuTagCreated(title: tag.title, backgroundHex: tag.backgroundHex),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final screenSize = MediaQuery.sizeOf(context);

    return BlocListener<MenuBloc, MenuState>(
      listener: _listener,
      child: Scaffold(
        appBar: _appbar(),
        body: SingleChildScrollView(
          child: SizedBox(
            width: screenSize.width,
            child: Column(
              children: [
                SizedBox(height: 2),
                BlocSelector<MenuBloc, MenuState, int>(
                  selector: (state) => state.myDayAmount,
                  builder: (context, amount) {
                    return MenuButtonWidget(
                      onTap: () => _nextPage(context, TaskPage.myDay()),
                      icon: Icons.wb_sunny_outlined,
                      iconColor: color.primary,
                      label: "Hariku",
                      amount: amount,
                    );
                  },
                ),
                BlocSelector<MenuBloc, MenuState, int>(
                  selector: (state) => state.taskAmount,
                  builder: (context, amount) {
                    return MenuButtonWidget(
                      onTap: () => _nextPage(context, TaskPage.all()),
                      icon: Icons.assignment_outlined,
                      iconColor: color.secondary,
                      label: "Semua Tugas",
                      amount: amount,
                    );
                  },
                ),
                _horizontalLine(color),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Kategori",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.33,
                        ),
                      ),
                      IconButton(
                        onPressed: () => _onCreateTag(context),
                        icon: Icon(Icons.add_rounded),
                      ),
                    ],
                  ),
                ),
                BlocSelector<MenuBloc, MenuState, List<TagMenuItem>>(
                  selector: (state) => state.tags,
                  builder: (context, state) {
                    return ReorderableListView.builder(
                      shrinkWrap: true,
                      itemCount: state.length,
                      physics: const NeverScrollableScrollPhysics(),
                      proxyDecorator: (child, index, animation) =>
                          _buildProxyDecorator(
                            child,
                            index,
                            animation,
                            color.surfaceContainerHigh,
                          ),
                      onReorder: (oldIndex, newIndex) {
                        final updatedTags = List<TagMenuItem>.from(state);

                        final item = updatedTags.removeAt(oldIndex);
                        updatedTags.insert(
                          newIndex > oldIndex ? newIndex - 1 : newIndex,
                          item,
                        );

                        context.read<MenuBloc>().add(
                          MenuTagsOrderUpdated(tags: updatedTags),
                        );
                      },
                      itemBuilder: (context, index) {
                        final tag = state[index];
                        return MenuButtonWidget(
                          key: ValueKey(tag.id),
                          icon: Icons.format_list_bulleted_rounded,
                          iconColor: Color(
                            int.parse('0xFF${tag.backgroundHex}'),
                          ),
                          splashColor: Color(
                            int.parse('0xFF${tag.backgroundHex}'),
                          ),
                          label: tag.title,
                          amount: tag.taskAmount,
                          onTap: () {},
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //============================================================================
  AppBar _appbar() {
    return AppBar(
      toolbarHeight: 64,
      automaticallyImplyLeading: false,
      title: Row(
        spacing: 16,
        children: [
          TimeUtils.currentDaylightIcon,
          Column(
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
        ],
      ),
    );
  }

  Widget _horizontalLine(ColorScheme color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(color: color.surfaceContainerHighest, height: 2),
    );
  }

  Widget _buildProxyDecorator(
    Widget child,
    int index,
    Animation<double> animation,
    Color draggableItemColor,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(0, 6, animValue)!;
        return Material(
          elevation: elevation,
          color: draggableItemColor,
          shadowColor: draggableItemColor,
          child: child,
        );
      },
      child: child,
    );
  }
}
