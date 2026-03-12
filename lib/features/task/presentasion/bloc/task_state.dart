part of 'task_bloc.dart';

enum TaskStateStatus { initial, success, failure }

enum TaskStateAction { none, getTask, createTask, deleteTask, checkTask }

class TaskState extends Equatable {
  final TaskStateStatus status;
  final TaskStateAction action;
  final List<Task> doneTasks;
  final List<Task> undoneTasks;
  final String? errorMessage;

  const TaskState({
    required this.status,
    this.action = TaskStateAction.none,
    this.doneTasks = const [],
    this.undoneTasks = const [],
    this.errorMessage,
  });

  const TaskState.initial() : this(status: TaskStateStatus.initial);

  TaskState copyWith({
    TaskStateStatus? status,
    TaskStateAction? action,
    List<Task>? doneTasks,
    List<Task>? undoneTasks,
    String? errorMessage,
  }) {
    return TaskState(
      status: status ?? this.status,
      action: action ?? this.action,
      doneTasks: doneTasks ?? this.doneTasks,
      undoneTasks: undoneTasks ?? this.undoneTasks,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    action,
    doneTasks,
    undoneTasks,
    errorMessage,
  ];
}
