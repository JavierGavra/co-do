part of 'create_tag_bloc.dart';

enum CreateTagStatus { initial, loading, success, failure }

final class CreateTagState extends Equatable {
  final CreateTagStatus status;
  final String? errorMessage;

  const CreateTagState({
    this.status = CreateTagStatus.initial,
    this.errorMessage,
  });

  bool get isLoading => status == CreateTagStatus.loading;

  CreateTagState copyWith({CreateTagStatus? status, String? errorMessage}) {
    return CreateTagState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
