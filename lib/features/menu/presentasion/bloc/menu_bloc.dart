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
import '../../domain/usecases/update_tags_order.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final GetTagMenuItems _getTagMenuItems;
  final GetTaskAmount _getTaskAmount;
  final GetMyDayAmount _getMyDayAmount;
  final CreateTag _createTag;
  final UpdateTagsOrder _updateTagsOrder;

  MenuBloc({
    required GetTagMenuItems getTagMenuItems,
    required GetTaskAmount getTaskAmount,
    required GetMyDayAmount getMyDayAmount,
    required CreateTag createTag,
    required UpdateTagsOrder updateTagsOrder,
  }) : _getTagMenuItems = getTagMenuItems,
       _getTaskAmount = getTaskAmount,
       _getMyDayAmount = getMyDayAmount,
       _createTag = createTag,
       _updateTagsOrder = updateTagsOrder,
       super(MenuState.initial()) {
    on<MenuStarted>(_onMenuStarted);
    on<MenuReloadRequested>(_onMenuReloadRequested);
    on<MenuTagCreated>(_onMenuTagCreated);
    on<MenuTagsOrderUpdated>(_onMenuTagsOrderUpdated);
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
    Emitter<MenuState> emit, {
    bool isMenuStarted = false,
  }) async {
    emit(state.copyWith(status: MenuStateStatus.loading));

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
        isMenuStarted: isMenuStarted,
        tags: tagsResult.getOrElse(() => []),
        taskAmount: taskAmountResult.getOrElse(() => 0),
        myDayAmount: myDayAmountResult.getOrElse(() => 0),
      ),
    );
  }

  Future<void> _onMenuStarted(
    MenuStarted event,
    Emitter<MenuState> emit,
  ) async => await _loadMenu(emit, isMenuStarted: true);

  Future<void> _onMenuReloadRequested(
    MenuReloadRequested event,
    Emitter<MenuState> emit,
  ) async => await _loadMenu(emit);

  Future<void> _onMenuTagCreated(
    MenuTagCreated event,
    Emitter<MenuState> emit,
  ) async {
    emit(state.copyWith(status: MenuStateStatus.loading));

    final result = await _createTag(
      CreateTagParams(title: event.title, backgroundHex: event.backgroundHex),
    );

    if (result.isLeft()) {
      _emitFailure(result, emit);
      return;
    }

    await _loadMenu(emit);
  }

  Future<void> _onMenuTagsOrderUpdated(
    MenuTagsOrderUpdated event,
    Emitter<MenuState> emit,
  ) async {
    emit(state.copyWith(status: MenuStateStatus.loading));

    final result = await _updateTagsOrder(
      UpdateTagsOrderParams(tags: event.tags),
    );

    if (result.isLeft()) {
      _emitFailure(result, emit);
      return;
    }

    final tagsResult = await _getTagMenuItems(NoParams());
    tagsResult.fold(
      (failure) => _emitFailure(tagsResult, emit),
      (tags) =>
          emit(state.copyWith(status: MenuStateStatus.success, tags: tags)),
    );
  }
}
