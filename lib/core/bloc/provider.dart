import 'package:codo/features/menu/presentasion/bloc/menu_bloc.dart';
import 'package:codo/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Provider {
  static final List<BlocProvider> providers = [
    BlocProvider<MenuBloc>(
      create: (context) => sl<MenuBloc>()..add(MenuStarted()),
    ),
  ];
}
