import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:codo/core/usecase/usecase.dart';
import '../../../tag/domain/entities/tag.dart';
import '../../../tag/domain/usecases/get_tags.dart';
import '../../../tag/domain/usecases/post_tag.dart';
import '../../../task/domain/usecases/get_task_amount.dart';
import '../../../task/domain/usecases/get_my_day_amount.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final GetTags _getTags;
  final GetTaskAmount _getTaskAmount;
  final GetMyDayAmount _getMyDayAmount;
  final PostTag _postTag;

  MenuBloc({
    required GetTags getTags,
    required GetTaskAmount getTaskAmount,
    required GetMyDayAmount getMyDayAmount,
    required PostTag postTag,
  }) : _getTags = getTags,
       _getTaskAmount = getTaskAmount,
       _getMyDayAmount = getMyDayAmount,
       _postTag = postTag,
       super(MenuState.initial()) {
    on<StartMenuEvent>(_onMenuStarted);
    on<ReloadMenuEvent>(_onReloadMenu);
    on<CreateTagEvent>(_onCreateTag);
  }

  Future<void> _loadMenu(
    MenuStateAction action,
    Emitter<MenuState> emit,
  ) async {
    emit(state.copyWith(status: MenuStateStatus.loading, action: action));

    final tagsResult = await _getTags(NoParams());
    final taskAmountResult = await _getTaskAmount(NoParams());
    final myDayAmountResult = await _getMyDayAmount(NoParams());

    if (tagsResult.isLeft()) {
      emit(
        state.copyWith(
          status: MenuStateStatus.failure,
          errorMessage: tagsResult
              .swap()
              .getOrElse(() => throw Exception())
              .message,
        ),
      );
      return;
    }

    if (taskAmountResult.isLeft()) {
      emit(
        state.copyWith(
          status: MenuStateStatus.failure,
          errorMessage: taskAmountResult
              .swap()
              .getOrElse(() => throw Exception())
              .message,
        ),
      );
      return;
    }

    if (myDayAmountResult.isLeft()) {
      emit(
        state.copyWith(
          status: MenuStateStatus.failure,
          errorMessage: myDayAmountResult
              .swap()
              .getOrElse(() => throw Exception())
              .message,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: MenuStateStatus.success,
        tags: tagsResult.getOrElse(() => []),
        taskAmount: taskAmountResult.getOrElse(() => 0),
        myDayAmount: myDayAmountResult.getOrElse(() => 0),
      ),
    );
  }

  Future<void> _onMenuStarted(
    StartMenuEvent event,
    Emitter<MenuState> emit,
  ) async {
    await _loadMenu(MenuStateAction.startMenu, emit);
  }

  Future<void> _onReloadMenu(
    ReloadMenuEvent event,
    Emitter<MenuState> emit,
  ) async {
    await _loadMenu(MenuStateAction.reload, emit);
  }

  Future<void> _onCreateTag(
    CreateTagEvent event,
    Emitter<MenuState> emit,
  ) async {
    emit(
      state.copyWith(
        status: MenuStateStatus.loading,
        action: MenuStateAction.createTag,
      ),
    );

    final result = await _postTag(PostTagParams(tag: event.tag));

    if (result.isLeft()) {
      emit(
        state.copyWith(
          status: MenuStateStatus.failure,
          errorMessage: result
              .swap()
              .getOrElse(() => throw Exception())
              .message,
        ),
      );
      return;
    }

    await _loadMenu(MenuStateAction.createTag, emit);
  }
}
