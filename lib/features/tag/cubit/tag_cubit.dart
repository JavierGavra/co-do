import 'package:bloc/bloc.dart';
import 'package:codo/features/tag/models/tag.dart';
import 'package:codo/features/tag/services/local_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'tag_state.dart';

class TagCubit extends Cubit<TagState> {
  final _localService = LocalService();

  TagCubit() : super(TagState.initial());

  Future<void> initDialog() async {
    try {
      final tags = await _localService.getTags();
      emit(TagState(status: TagStateStatus.success, tags: tags));
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }
}
