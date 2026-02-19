import 'package:bloc/bloc.dart';
import 'package:codo/features/task/models/task.dart';
import 'package:codo/features/task/services/local_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final _localService = LocalService();

  TaskBloc() : super(TaskState.initial()) {
    on<MyDayTask>(_onMyDayTask);
    on<GetAllTask>(_onGetAllTask);
    on<CreateTask>(_onCreateTask);
    on<DeleteTask>(_onDeleteTask);
    on<CheckTask>(_onCheckTask);
  }

  (List<Task>, List<Task>) _separateTasks(List<Task> tasks) {
    final doneTasks = <Task>[];
    final undoneTasks = <Task>[];

    for (final task in tasks) {
      if (task.status) {
        doneTasks.add(task);
      } else {
        undoneTasks.add(task);
      }
    }

    return (doneTasks, undoneTasks);
  }

  Future<void> _onMyDayTask(MyDayTask event, Emitter<TaskState> emit) async {
    emit(state.copyWith(action: TaskStateAction.getTask));
    try {
      final List<Task> tasks = await _localService.getMyDayTasks();
      final (doneTasks, undoneTasks) = _separateTasks(tasks);

      emit(
        state.copyWith(
          status: TaskStateStatus.success,
          doneTasks: doneTasks,
          undoneTasks: undoneTasks,
        ),
      );
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<void> _onGetAllTask(GetAllTask event, Emitter<TaskState> emit) async {
    emit(state.copyWith(action: TaskStateAction.getTask));
    try {
      final List<Task> tasks = await _localService.getAllTasks();
      final (doneTasks, undoneTasks) = _separateTasks(tasks);

      emit(
        state.copyWith(
          status: TaskStateStatus.success,
          doneTasks: doneTasks,
          undoneTasks: undoneTasks,
        ),
      );
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<void> _onCreateTask(CreateTask event, Emitter<TaskState> emit) async {
    emit(state.copyWith(action: TaskStateAction.createTask));
    try {
      await _localService.insertTask(event.task);
      emit(state.copyWith(status: TaskStateStatus.success));
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    emit(state.copyWith(action: TaskStateAction.deleteTask));
    try {
      await _localService.deleteTask(event.id);
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<void> _onCheckTask(CheckTask event, Emitter<TaskState> emit) async {
    emit(state.copyWith(action: TaskStateAction.checkTask));
    try {
      await _localService.taskChecked(event.id, event.status);
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }
}
