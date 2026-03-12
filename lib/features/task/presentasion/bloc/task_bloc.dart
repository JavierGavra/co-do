import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:codo/core/usecase/usecase.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_all_tasks.dart';
import '../../domain/usecases/get_my_day.dart';
import '../../domain/usecases/post_task.dart';
import '../../domain/usecases/task_checked.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetMyDay _getMyDay;
  final GetAllTasks _getAllTasks;
  final PostTask _postTask;
  final DeleteTask _deleteTask;
  final TaskChecked _taskChecked;

  TaskBloc({
    required GetMyDay getMyDay,
    required GetAllTasks getAllTasks,
    required PostTask postTask,
    required DeleteTask deleteTask,
    required TaskChecked taskChecked,
  }) : _getMyDay = getMyDay,
       _getAllTasks = getAllTasks,
       _postTask = postTask,
       _deleteTask = deleteTask,
       _taskChecked = taskChecked,
       super(TaskState.initial()) {
    on<MyDayTaskEvent>(_onMyDayTask);
    on<GetAllTaskEvent>(_onGetAllTask);
    on<CreateTaskEvent>(_onCreateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<CheckTaskEvent>(_onCheckTask);
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

  Future<void> _handleTaskFetch({
    required Future<dynamic> Function() call,
    required Emitter<TaskState> emit,
  }) async {
    final either = await call();
    either.fold(
      (failure) {
        emit(
          state.copyWith(
            status: TaskStateStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (data) {
        final (doneTasks, undoneTasks) = _separateTasks(data);
        emit(
          state.copyWith(
            status: TaskStateStatus.success,
            doneTasks: doneTasks,
            undoneTasks: undoneTasks,
          ),
        );
      },
    );
  }

  Future<void> _handleMutation({
    required Future<dynamic> Function() call,
    required Emitter<TaskState> emit,
    required String? errorMessage,
  }) async {
    final either = await call();
    either.fold(
      (failure) => emit(
        state.copyWith(
          status: TaskStateStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (isSuccss) {
        if (isSuccss) emit(state.copyWith(status: TaskStateStatus.success));

        emit(
          state.copyWith(
            status: TaskStateStatus.failure,
            errorMessage: errorMessage,
          ),
        );
      },
    );
  }

  Future<void> _onMyDayTask(
    MyDayTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(action: TaskStateAction.getTask));
    await _handleTaskFetch(call: () => _getMyDay(NoParams()), emit: emit);
  }

  Future<void> _onGetAllTask(
    GetAllTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(action: TaskStateAction.getTask));
    await _handleTaskFetch(call: () => _getAllTasks(NoParams()), emit: emit);
  }

  Future<void> _onCreateTask(
    CreateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(action: TaskStateAction.createTask));
    await _handleMutation(
      call: () => _postTask(PostTaskParams(task: event.task)),
      emit: emit,
      errorMessage: "Gagal menambahkan tugas",
    );
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(action: TaskStateAction.deleteTask));
    await _handleMutation(
      call: () => _deleteTask(DeleteTaskParams(id: event.id)),
      emit: emit,
      errorMessage: "Gagal menghapus tugas",
    );
  }

  Future<void> _onCheckTask(
    CheckTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(action: TaskStateAction.checkTask));
    await _handleMutation(
      call: () =>
          _taskChecked(TaskCheckedParams(id: event.id, status: event.status)),
      emit: emit,
      errorMessage: "Terjadi suatu masalah",
    );
  }
}
