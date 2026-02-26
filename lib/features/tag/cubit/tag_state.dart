part of 'tag_cubit.dart';

enum TagStateStatus { initial, success }

final class TagState extends Equatable {
  final TagStateStatus status;
  final List<Tag> tags;

  const TagState({required this.status, this.tags = const []});

  const TagState.initial() : this(status: TagStateStatus.initial);

  @override
  List<Object> get props => [status, tags];
}
