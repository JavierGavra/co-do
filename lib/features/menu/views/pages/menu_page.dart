import 'package:codo/core/utils/time/time_utils.dart';
import 'package:codo/features/menu/views/widgets/menu_button_widget.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

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
                onTap: () => Navigator.pop(context),
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
              Container(
                // color: Colors.amber,
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
        onPressed: () {},
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
