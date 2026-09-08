import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/create_tag.dart';

part 'create_tag_event.dart';
part 'create_tag_state.dart';

class CreateTagBloc extends Bloc<CreateTagEvent, CreateTagState> {
  final CreateTag _createTag;

  CreateTagBloc({required CreateTag createTag})
    : _createTag = createTag,
      super(const CreateTagState()) {
    on<CreateTagSubmitted>(_onCreateTagSubmitted);
  }

  Future<void> _onCreateTagSubmitted(
    CreateTagSubmitted event,
    Emitter<CreateTagState> emit,
  ) async {
    emit(const CreateTagState(status: CreateTagStatus.loading));

    try {
      final result = await _createTag(
        CreateTagParams(title: event.title, backgroundHex: event.backgroundHex),
      );

      result.fold(
        (failure) => emit(
          state.copyWith(
            status: CreateTagStatus.failure,
            errorMessage: failure.toString(),
          ),
        ),
        (success) => emit(state.copyWith(status: CreateTagStatus.success)),
      );
    } catch (e) {
      emit(
        CreateTagState(
          status: CreateTagStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
