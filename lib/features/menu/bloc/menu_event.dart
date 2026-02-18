part of 'menu_bloc.dart';

sealed class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object> get props => [];
}

class StartMenu extends MenuEvent {}

class CreateTag extends MenuEvent {
  final Tag tag;

  const CreateTag(this.tag);

  @override
  List<Object> get props => [tag];
}
