import 'package:codo/core/utils/time/time_utils.dart';
import 'package:codo/core/widgets/custom_snackbar.dart';
import 'package:codo/core/widgets/loading_dialog.dart';
import 'package:codo/features/menu/bloc/menu_bloc.dart';
import 'package:codo/features/menu/models/tag.dart';
import 'package:codo/features/menu/views/widgets/create_tags_dialog.dart';
import 'package:codo/features/menu/views/widgets/menu_button_widget.dart';
import 'package:codo/features/my_day/views/pages/my_day_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  void _nextPage(BuildContext context, Widget page) {
    context.pushTransition(
      type: PageTransitionType.rightToLeft,
      curve: Curves.easeInOutCubic,
      child: page,
    );
  }

  void _listener(BuildContext context, MenuState state) {
    if (state.status == MenuStateStatus.loading) {
      showLoadingDialog(context: context);
    } else if (state.status == MenuStateStatus.success) {
      Navigator.of(context).pop();
      if (state.action == MenuStateAction.startMenu && context.mounted) {
        _nextPage(context, const MyDayPage());
      }
    } else if (state.status == MenuStateStatus.failure) {
      showSnackBar(context, SnackBarType.failure);
    }
  }

  void _onCreateTag(BuildContext context) async {
    final tag = await showCreateTagsDialog(context: context);
    if (tag != null && context.mounted) {
      context.read<MenuBloc>().add(CreateTag(tag));
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
                MenuButtonWidget(
                  onTap: () => _nextPage(context, MyDayPage()),
                  icon: Icons.wb_sunny_outlined,
                  iconColor: color.primary,
                  label: "Hariku",
                  amount: 5,
                ),
                MenuButtonWidget(
                  onTap: () {},
                  icon: Icons.assignment_outlined,
                  iconColor: color.secondary,
                  label: "Semua Tugas",
                  amount: 64,
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
                BlocSelector<MenuBloc, MenuState, List<Tag>>(
                  selector: (state) => state.tags,
                  builder: (context, state) {
                    return Column(
                      children: List.generate(state.length, (index) {
                        final tag = state[index];
                        return MenuButtonWidget(
                          icon: Icons.format_list_bulleted_rounded,
                          iconColor: Color(
                            int.parse('0xFF${tag.backgroundHex}'),
                          ),
                          splashColor: Color(
                            int.parse('0xFF${tag.backgroundHex}'),
                          ),
                          label: tag.title,
                          amount: tag.amount,
                          onTap: () {},
                        );
                      }),
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
}
