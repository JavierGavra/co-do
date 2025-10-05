import 'dart:async';

import 'package:codo/core/utils/time/time_utils.dart';
import 'package:codo/core/widgets/add_task_bottom_sheet.dart';
import 'package:codo/features/menu/views/widgets/menu_button_widget.dart';
import 'package:codo/features/my_day/views/pages/my_day_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(milliseconds: 100),
      () => _nextPage(context, MyDayPage()),
    );
  }

  void _nextPage(BuildContext context, Widget page) {
    context.pushTransition(
      type: PageTransitionType.rightToLeft,
      curve: Curves.easeInOutCubic,
      child: page,
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
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
                  children: [
                    Text(
                      "Kategori",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.33,
                      ),
                    ),
                    Spacer(),
                    IconButton(onPressed: () {}, icon: Icon(Icons.add_rounded)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTaskBottomSheet(context),
        backgroundColor: color.primary,
        foregroundColor: color.onPrimary,
        child: Icon(Icons.add_rounded),
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
