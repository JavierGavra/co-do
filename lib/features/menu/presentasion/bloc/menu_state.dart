part of 'menu_bloc.dart';

enum MenuStateStatus { initial, loading, success, failure }

final class MenuState extends Equatable {
  final MenuStateStatus status;
  final bool isMenuStarted;
  final int myDayAmount;
  final int taskAmount;
  final List<TagMenuItem> tags;
  final String? errorMessage;

  const MenuState({
    required this.status,
    this.isMenuStarted = false,
    this.myDayAmount = 0,
    this.taskAmount = 0,
    this.tags = const [],
    this.errorMessage,
  });

  const MenuState.initial() : this(status: MenuStateStatus.initial);

  MenuState copyWith({
    MenuStateStatus? status,
    bool? isMenuStarted,
    int? myDayAmount,
    int? taskAmount,
    List<TagMenuItem>? tags,
    String? errorMessage,
  }) {
    return MenuState(
      status: status ?? this.status,
      isMenuStarted: isMenuStarted ?? this.isMenuStarted,
      myDayAmount: myDayAmount ?? this.myDayAmount,
      taskAmount: taskAmount ?? this.taskAmount,
      tags: tags ?? this.tags,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    isMenuStarted,
    myDayAmount,
    taskAmount,
    tags,
    errorMessage,
  ];
}
