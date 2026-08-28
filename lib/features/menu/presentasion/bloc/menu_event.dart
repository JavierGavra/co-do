part of 'menu_bloc.dart';

sealed class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object> get props => [];
}

class StartMenuEvent extends MenuEvent {}

class ReloadMenuEvent extends MenuEvent {}

class CreateTagEvent extends MenuEvent {
  final String title;
  final String backgroundHex;

  const CreateTagEvent({required this.title, required this.backgroundHex});

  @override
  List<Object> get props => [title, backgroundHex];
}
