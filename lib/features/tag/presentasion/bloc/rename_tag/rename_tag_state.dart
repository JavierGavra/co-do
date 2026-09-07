part of 'rename_tag_bloc.dart';

enum RenameTagStateStatus { initial, loading, success, failure }

final class RenameTagState extends Equatable {
  final RenameTagStateStatus status;
  final String? errorMessage;

  const RenameTagState({
    this.status = RenameTagStateStatus.initial,
    this.errorMessage,
  });

  bool get isLoading => status == RenameTagStateStatus.loading;
  bool get isSuccess => status == RenameTagStateStatus.success;
  bool get isFailure => status == RenameTagStateStatus.failure;

  RenameTagState copyWith({
    RenameTagStateStatus? status,
    String? errorMessage,
  }) {
    return RenameTagState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
