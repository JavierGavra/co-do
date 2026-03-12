import 'package:codo/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/menu_bloc.dart';
import 'menu_view.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MenuBloc>()..add(StartMenuEvent()),
      child: const MenuView(),
    );
  }
}
