import 'package:bloc/bloc.dart';
import 'package:codo/features/tag/domain/usecases/delete_tag_only.dart';
import 'package:codo/features/tag/domain/usecases/delete_tag_with_tasks.dart';
import 'package:equatable/equatable.dart';

part 'delete_tag_event.dart';
part 'delete_tag_state.dart';

class DeleteTagBloc extends Bloc<DeleteTagEvent, DeleteTagState> {
  final DeleteTagOnly _deleteTagOnly;
  final DeleteTagWithTasks _deleteTagWithTasks;

  DeleteTagBloc({
    required DeleteTagOnly deleteTagOnly,
    required DeleteTagWithTasks deleteTagWithTasks,
  }) : _deleteTagOnly = deleteTagOnly,
       _deleteTagWithTasks = deleteTagWithTasks,
       super(DeleteTagState()) {
    on<DeleteTagOnlyRequested>(_onDeleteTagOnlyRequested);
    on<DeleteTagWithTasksRequested>(_onDeleteTagWithTasksRequested);
  }

  Future<void> _onDeleteTagOnlyRequested(
    DeleteTagOnlyRequested event,
    Emitter<DeleteTagState> emit,
  ) async {
    emit(state.copyWith(status: DeleteTagStateStatus.loading));

    final result = await _deleteTagOnly(DeleteTagOnlyParams(id: event.id));
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DeleteTagStateStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: DeleteTagStateStatus.success)),
    );
  }

  Future<void> _onDeleteTagWithTasksRequested(
    DeleteTagWithTasksRequested event,
    Emitter<DeleteTagState> emit,
  ) async {
    emit(state.copyWith(status: DeleteTagStateStatus.loading));

    final result = await _deleteTagWithTasks(
      DeleteTagWithTasksParams(id: event.id),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DeleteTagStateStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: DeleteTagStateStatus.success)),
    );
  }
}
