part of 'my_day_cubit.dart';

enum MyDayStateStatus { initial, success }

class MyDayState extends Equatable {
  final MyDayStateStatus status;
  final List<Task> tasks;

  const MyDayState({required this.status, this.tasks = const []});

  const MyDayState.initial() : this(status: MyDayStateStatus.initial);

  MyDayState copyWith({MyDayStateStatus? status, List<Task>? tasks}) {
    return MyDayState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  List<Object> get props => [status, tasks];
}
