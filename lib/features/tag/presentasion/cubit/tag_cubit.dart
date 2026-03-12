import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:codo/core/usecase/usecase.dart';
import '../../domain/usecases/get_tags.dart';
import '../../domain/entities/tag.dart';

part 'tag_state.dart';

class TagCubit extends Cubit<TagState> {
  final GetTags _getTags;

  TagCubit({required GetTags getTags})
    : _getTags = getTags,
      super(TagState.initial());

  Future<void> initDialog() async {
    final response = await _getTags(NoParams());
    response.fold(
      (failure) => emit(
        TagState(status: TagStateStatus.failure, errorMessage: "$failure"),
      ),
      (tags) => emit(TagState(status: TagStateStatus.success, tags: tags)),
    );
  }
}
