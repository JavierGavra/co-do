import 'package:codo/features/menu/bloc/menu_bloc.dart';
import 'package:codo/features/menu/views/pages/menu_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuBloc()..add(StartMenu()),
      child: const MenuView(),
    );
  }
}
