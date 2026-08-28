part of 'menu_bloc.dart';

sealed class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object> get props => [];
}

final class MenuStarted extends MenuEvent {}

final class MenuReloadRequested extends MenuEvent {}

final class MenuTagCreated extends MenuEvent {
  final String title;
  final String backgroundHex;

  const MenuTagCreated({required this.title, required this.backgroundHex});

  @override
  List<Object> get props => [title, backgroundHex];
}

final class MenuTagsOrderUpdated extends MenuEvent {
  final List<TagMenuItem> tags;

  const MenuTagsOrderUpdated({required this.tags});

  @override
  List<Object> get props => [tags];
}
