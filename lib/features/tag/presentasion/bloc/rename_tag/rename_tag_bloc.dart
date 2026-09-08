import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/rename_tag.dart';

part 'rename_tag_event.dart';
part 'rename_tag_state.dart';

class RenameTagBloc extends Bloc<RenameTagEvent, RenameTagState> {
  final RenameTag _renameTag;

  RenameTagBloc({required RenameTag renameTag})
    : _renameTag = renameTag,
      super(const RenameTagState()) {
    on<RenameTagRequested>(_onRenameTagRequested);
  }

  Future<void> _onRenameTagRequested(
    RenameTagRequested event,
    Emitter<RenameTagState> emit,
  ) async {
    emit(state.copyWith(status: RenameTagStateStatus.loading));

    final result = await _renameTag(
      RenameTagParams(tagId: event.tagId, newTitle: event.newTitle),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RenameTagStateStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: RenameTagStateStatus.success)),
    );
  }
}
