part of 'create_tag_bloc.dart';

sealed class CreateTagEvent extends Equatable {
  const CreateTagEvent();
}

final class CreateTagSubmitted extends CreateTagEvent {
  final String title;
  final String backgroundHex;

  const CreateTagSubmitted({required this.title, required this.backgroundHex});

  @override
  List<Object> get props => [title, backgroundHex];
}
