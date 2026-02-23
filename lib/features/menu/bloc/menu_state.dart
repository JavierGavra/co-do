part of 'menu_bloc.dart';

enum MenuStateStatus { initial, loading, success, failure }

enum MenuStateAction { none, startMenu, reload, createTag }

final class MenuState extends Equatable {
  final MenuStateStatus status;
  final MenuStateAction action;
  final int myDayAmount;
  final int taskAmount;
  final List<Tag> tags;
  final String? errorMessage;

  const MenuState({
    required this.status,
    this.myDayAmount = 0,
    this.taskAmount = 0,
    this.action = MenuStateAction.none,
    this.tags = const [],
    this.errorMessage,
  });

  const MenuState.initial() : this(status: MenuStateStatus.initial);

  MenuState copyWith({
    MenuStateStatus? status,
    MenuStateAction? action,
    int? myDayAmount,
    int? taskAmount,
    List<Tag>? tags,
    String? errorMessage,
  }) {
    return MenuState(
      status: status ?? this.status,
      action: action ?? this.action,
      myDayAmount: myDayAmount ?? this.myDayAmount,
      taskAmount: taskAmount ?? this.taskAmount,
      tags: tags ?? this.tags,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    action,
    myDayAmount,
    taskAmount,
    tags,
    errorMessage,
  ];
}
