part of 'menu_bloc.dart';

sealed class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object> get props => [];
}

class StartMenuEvent extends MenuEvent {}

class ReloadMenuEvent extends MenuEvent {}

class CreateTagEvent extends MenuEvent {
  final Tag tag;

  const CreateTagEvent(this.tag);

  @override
  List<Object> get props => [tag];
}
