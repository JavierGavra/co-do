part of 'rename_tag_bloc.dart';

sealed class RenameTagEvent extends Equatable {
  const RenameTagEvent();
}

final class RenameTagRequested extends RenameTagEvent {
  const RenameTagRequested({required this.tagId, required this.newTitle});

  final int tagId;
  final String newTitle;

  @override
  List<Object?> get props => [tagId, newTitle];
}
