part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

final class MyDayTask extends TaskEvent {}

final class GetAllTask extends TaskEvent {
  final int? tagId;

  const GetAllTask({this.tagId});

  @override
  List<Object?> get props => [tagId];
}

final class CreateTask extends TaskEvent {
  final Task task;

  const CreateTask({required this.task});

  @override
  List<Object?> get props => [task];
}

final class DeleteTask extends TaskEvent {
  final int id;

  const DeleteTask({required this.id});

  @override
  List<Object?> get props => [id];
}

final class CheckTask extends TaskEvent {
  final int id;
  final bool status;

  const CheckTask({required this.id, required this.status});

  @override
  List<Object?> get props => [id, status];
}
