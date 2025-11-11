part of 'my_day_cubit.dart';

enum MyDayStateStatus { initial, success }

class MyDayState extends Equatable {
  final MyDayStateStatus status;
  final List<Task> doneTasks;
  final List<Task> undoneTasks;

  const MyDayState({
    required this.status,
    this.doneTasks = const [],
    this.undoneTasks = const [],
  });

  const MyDayState.initial() : this(status: MyDayStateStatus.initial);

  MyDayState copyWith({
    MyDayStateStatus? status,
    List<Task>? doneTasks,
    List<Task>? undoneTasks,
  }) {
    return MyDayState(
      status: status ?? this.status,
      doneTasks: doneTasks ?? this.doneTasks,
      undoneTasks: undoneTasks ?? this.undoneTasks,
    );
  }

  @override
  List<Object> get props => [status, doneTasks, undoneTasks];
}
