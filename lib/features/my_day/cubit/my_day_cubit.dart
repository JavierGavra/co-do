import 'package:bloc/bloc.dart';
import 'package:codo/features/my_day/models/task.dart';
import 'package:codo/features/my_day/services/local_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'my_day_state.dart';

class MyDayCubit extends Cubit<MyDayState> {
  MyDayCubit() : super(MyDayState.initial());
  final LocalService _localService = LocalService();

  Future addTask(Task task) async {
    try {
      await _localService.insertTask(task);
      getAllTask();
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future getAllTask() async {
    try {
      final List<Task> tasks = await _localService.getAllTasks();
      emit(state.copyWith(status: MyDayStateStatus.success, tasks: tasks));
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future deleteTask(int id) async {
    try {
      await _localService.deleteTask(id);
      getAllTask();
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }
}
