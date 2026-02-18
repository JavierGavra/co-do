part of 'menu_bloc.dart';

enum MenuStateStatus { initial, loading, success, failure }

enum MenuStateAction { none, startMenu, createTag }

final class MenuState extends Equatable {
  final MenuStateStatus status;
  final MenuStateAction action;
  final List<Tag> tags;
  final String? errorMessage;

  const MenuState({
    required this.status,
    this.action = MenuStateAction.none,
    this.tags = const [],
    this.errorMessage,
  });

  const MenuState.initial() : this(status: MenuStateStatus.initial);

  MenuState copyWith({
    MenuStateStatus? status,
    MenuStateAction? action,
    List<Tag>? tags,
    String? errorMessage,
  }) {
    return MenuState(
      status: status ?? this.status,
      action: action ?? this.action,
      tags: tags ?? this.tags,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, action, tags, errorMessage];
}
