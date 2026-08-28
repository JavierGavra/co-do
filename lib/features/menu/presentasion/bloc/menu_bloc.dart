import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/tag_menu_item.dart';
import '../../domain/usecases/create_tag.dart';
import '../../domain/usecases/get_my_day_amount.dart';
import '../../domain/usecases/get_tag_menu_items.dart';
import '../../domain/usecases/get_task_amount.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final GetTagMenuItems _getTagMenuItems;
  final GetTaskAmount _getTaskAmount;
  final GetMyDayAmount _getMyDayAmount;
  final CreateTag _createTag;

  MenuBloc({
    required GetTagMenuItems getTagMenuItems,
    required GetTaskAmount getTaskAmount,
    required GetMyDayAmount getMyDayAmount,
    required CreateTag createTag,
  }) : _getTagMenuItems = getTagMenuItems,
       _getTaskAmount = getTaskAmount,
       _getMyDayAmount = getMyDayAmount,
       _createTag = createTag,
       super(MenuState.initial()) {
    on<StartMenuEvent>(_onMenuStarted);
    on<ReloadMenuEvent>(_onReloadMenu);
    on<CreateTagEvent>(_onCreateTag);
  }

  void _emitFailure(Either<Failure, dynamic> result, Emitter<MenuState> emit) {
    emit(
      state.copyWith(
        status: MenuStateStatus.failure,
        errorMessage: result.swap().getOrElse(() => throw Exception()).message,
      ),
    );
  }

  Future<void> _loadMenu(
    MenuStateAction action,
    Emitter<MenuState> emit,
  ) async {
    emit(state.copyWith(status: MenuStateStatus.loading, action: action));

    final tagsResult = await _getTagMenuItems(NoParams());
    final taskAmountResult = await _getTaskAmount(NoParams());
    final myDayAmountResult = await _getMyDayAmount(NoParams());

    if (tagsResult.isLeft()) {
      _emitFailure(tagsResult, emit);
      return;
    }

    if (taskAmountResult.isLeft()) {
      _emitFailure(taskAmountResult, emit);
      return;
    }

    if (myDayAmountResult.isLeft()) {
      _emitFailure(myDayAmountResult, emit);
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

    final result = await _createTag(
      CreateTagParams(title: event.title, backgroundHex: event.backgroundHex),
    );

    if (result.isLeft()) {
      _emitFailure(result, emit);
      return;
    }

    await _loadMenu(MenuStateAction.createTag, emit);
  }
}
