part of 'delete_tag_bloc.dart';

enum DeleteTagStateStatus { initial, loading, success, failure }

final class DeleteTagState extends Equatable {
  final DeleteTagStateStatus status;
  final String? errorMessage;

  const DeleteTagState({
    this.status = DeleteTagStateStatus.initial,
    this.errorMessage,
  });

  bool get isLoading => status == DeleteTagStateStatus.loading;
  bool get isSuccess => status == DeleteTagStateStatus.success;
  bool get isFailure => status == DeleteTagStateStatus.failure;

  DeleteTagState copyWith({
    DeleteTagStateStatus? status,
    String? errorMessage,
  }) {
    return DeleteTagState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
