import 'package:bloc/bloc.dart';
import 'package:codo/features/menu/models/tag.dart';
import 'package:codo/features/menu/services/local_service.dart';
import 'package:equatable/equatable.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final _localService = LocalService();

  MenuBloc() : super(MenuState.initial()) {
    on<StartMenu>(_onMenuStarted);
    on<CreateTag>(_onCreateTag);
  }

  Future<void> _onMenuStarted(StartMenu event, Emitter<MenuState> emit) async {
    emit(
      MenuState(
        status: MenuStateStatus.loading,
        action: MenuStateAction.startMenu,
      ),
    );
    try {
      final data = await _localService.getTags();
      emit(state.copyWith(status: MenuStateStatus.success, tags: data));
    } catch (e) {
      emit(
        state.copyWith(
          status: MenuStateStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCreateTag(CreateTag event, Emitter<MenuState> emit) async {
    emit(
      state.copyWith(
        status: MenuStateStatus.loading,
        action: MenuStateAction.createTag,
      ),
    );
    try {
      await _localService.createTag(event.tag);
      await Future.delayed(const Duration(seconds: 1));

      final data = await _localService.getTags();

      emit(state.copyWith(status: MenuStateStatus.success, tags: data));
    } catch (e) {
      emit(
        state.copyWith(
          status: MenuStateStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
