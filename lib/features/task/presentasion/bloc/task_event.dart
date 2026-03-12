part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

final class MyDayTaskEvent extends TaskEvent {}

final class GetAllTaskEvent extends TaskEvent {
  final int? tagId;

  const GetAllTaskEvent({this.tagId});

  @override
  List<Object?> get props => [tagId];
}

final class CreateTaskEvent extends TaskEvent {
  final Task task;

  const CreateTaskEvent({required this.task});

  @override
  List<Object?> get props => [task];
}

final class DeleteTaskEvent extends TaskEvent {
  final int id;

  const DeleteTaskEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

final class CheckTaskEvent extends TaskEvent {
  final int id;
  final bool status;

  const CheckTaskEvent({required this.id, required this.status});

  @override
  List<Object?> get props => [id, status];
}
