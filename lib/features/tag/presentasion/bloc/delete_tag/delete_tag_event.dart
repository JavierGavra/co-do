part of 'delete_tag_bloc.dart';

sealed class DeleteTagEvent extends Equatable {
  final int id;

  const DeleteTagEvent(this.id);

  @override
  List<Object?> get props => [id];
}

final class DeleteTagOnlyRequested extends DeleteTagEvent {
  const DeleteTagOnlyRequested(super.id);
}

final class DeleteTagWithTasksRequested extends DeleteTagEvent {
  const DeleteTagWithTasksRequested(super.id);
}
