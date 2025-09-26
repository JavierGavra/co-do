import 'package:codo/core/constant/image_assets.dart';
import 'package:codo/core/utils/time/time_utils.dart';
import 'package:codo/features/menu/views/pages/menu_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class MyDayPage extends StatefulWidget {
  const MyDayPage({super.key});

  @override
  State<MyDayPage> createState() => _MyDayPageState();
}

class _MyDayPageState extends State<MyDayPage> {
  final double _collapsedHeight = 64;
  final double _expandedHeight = 146;

  late ScrollController _scrollController;
  final ValueNotifier<bool> _isCollapsed = ValueNotifier(false);

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

    return Scaffold(
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
              _sliverAppBar(),
              SliverToBoxAdapter(
                child: Container(
                  height: 3140,
                  width: double.infinity,
                  // color: color.surface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ],
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

  Widget _sliverAppBar() {
    return SliverAppBar(
      pinned: true,
      foregroundColor: Colors.white,
      backgroundColor: Colors.transparent,
      forceMaterialTransparency: true,
      expandedHeight: _expandedHeight,
      collapsedHeight: _collapsedHeight,
      leading: IconButton(
        onPressed: () {
          context.pushTransition(
            type: PageTransitionType.leftToRight,
            curve: Curves.easeInOutCubic,
            child: MenuPage(),
          );
        },
        icon: Icon(Icons.menu_rounded),
      ),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_rounded)),
      ],
      title: ValueListenableBuilder(
        valueListenable: _isCollapsed,
        builder: (context, value, child) {
          return AnimatedOpacity(
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
          );
        },
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
  }
}
