import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/tag_menu_item.dart';
import '../repositories/menu_repository.dart';

class UpdateTagsOrder extends UseCase<void, UpdateTagsOrderParams> {
  final MenuRepository _repository;

  UpdateTagsOrder(this._repository);

  @override
  Future<Either<Failure, void>> call(UpdateTagsOrderParams params) {
    return _repository.updateTagsOrder(params);
  }
}

class UpdateTagsOrderParams extends Equatable {
  final List<TagMenuItem> tags;

  const UpdateTagsOrderParams({required this.tags});

  @override
  List<Object> get props => [tags];
}
