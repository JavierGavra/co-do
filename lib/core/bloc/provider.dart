import 'package:codo/features/my_day/cubit/my_day_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Provider {
  static List<BlocProvider> get providers {
    return [BlocProvider<MyDayCubit>(create: (context) => MyDayCubit())];
  }
}
