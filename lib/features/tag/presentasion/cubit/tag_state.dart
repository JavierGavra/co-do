part of 'tag_cubit.dart';

enum TagStateStatus { initial, success, failure }

final class TagState extends Equatable {
  final TagStateStatus status;
  final List<Tag> tags;
  final String? errorMessage;

  const TagState({
    required this.status,
    this.tags = const [],
    this.errorMessage,
  });

  const TagState.initial() : this(status: TagStateStatus.initial);

  @override
  List<Object?> get props => [status, tags, errorMessage];
}
